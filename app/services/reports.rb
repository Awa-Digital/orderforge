require "csv"

class Reports
  attr_accessor :orders, :requester, :csv_url

  def initialize(orders, requester, filters)
    @orders = orders
    @requester = requester
    @filters = filters
    @file_name = nil
    @csv_url = nil
    @file = nil
  end

  def process
    @file_name = "report-#{DateTime.now.strftime('%Y-%m-%d-%H-%M-%S')}.csv"
    upload_file
    deliver_report
  end

  def upload_file
    # Write CSV string to a temp file
    file_path = Rails.root.join('tmp', @file_name)
    File.write(file_path, generate_report)
    file = File.open(file_path)
    csv_uploader = CsvUploader.new
    csv_uploader.store!(file)
    @csv_url = csv_uploader.url

    file.close
    FileUtils.rm_f(file_path)
  end

  def deliver_report
    report = Report.create(
      admin_user_id: @requester.id,
      csv_url: @csv_url,
      file_name: @file_name,
      filters: @filters
    )
    ReportMailer.with(report: report).report_email.deliver_later
  end

  HEADERS = [
    "Id",
    "Recipient Name",
    "Status",
    "Reference",
    "Order No",
    "Franchise",
    "Total",
    "Delivery Charge",
    "Discount Amount",
    "Order Total",
    "Payment Gateway",
    "Paid At",
    "Updated At",
    "Created At",
    "Affiliate Order"
  ].freeze

  def generate_report
    return @file_data if @file_data.present?

    @file_data = CSV.generate(headers: true) do |csv|
      csv << HEADERS
      insert_orders(csv)
      insert_sums(csv)

      csv << [""]
      csv << ["Products Bought in this period"]
      products_sold.each do |product|
        csv << [product[:id], product[:title], product[:count]]
      end
    end
  end

  def insert_orders(csv)
    @orders.each do |order|
      stamp = order.order_stamp || {}
      csv << [
        order.id,
        order.recipient_name,
        order.status,
        order.reference,
        order.order_no,
        order.franchise&.title,
        stamp["subtotal"],
        stamp["delivery_charge"],
        stamp["discount_amount"],
        stamp["order_total"],
        order.payment&.gateway,
        order.payment&.paid_at,
        order.updated_at,
        order.created_at,
        order.influencer_id.present? ? "Yes" : "No"
      ]
    end
  end

  def insert_sums(csv)
    csv << [
      "Total Orders: #{@orders.count}",
      "",
      "",
      "",
      "",
      "",
      @orders.map { |o| o.order_stamp&.dig("subtotal").to_d }.sum,
      @orders.map { |o| o.order_stamp&.dig("delivery_charge").to_d }.sum,
      @orders.map { |o| o.order_stamp&.dig("discount_amount").to_d }.sum,
      @orders.map { |o| o.order_stamp&.dig("order_total").to_d }.sum,
      "",
      "",
      "",
      "",
      ""
    ]
  end

  def products_sold
    products = {}

    @orders.each do |order|
      next unless order.order_stamp&.dig("items")

      order.order_stamp["items"].each do |item|
        item["combo_items"]&.any? ? products_in_combo(products, item) : direct_products_sold(products, item)
      end
    end

    products.values
  end

  def products_in_combo(products, item)
    item["combo_items"].each do |combo_item|
      product_id = combo_item["product_id"]
      unless products[product_id]
        products[product_id] = { id: product_id, title: combo_item["product_name"], count: 0 }
      end
      products[product_id][:count] += item["quantity"] * combo_item["quantity"]
    end
  end

  def direct_products_sold(products, item)
    product_id = item["product_id"]
    unless products[product_id]
      products[product_id] = { id: product_id, title: item["product_name"], count: 0 }
    end
    products[product_id][:count] += item["quantity"]
  end
end
