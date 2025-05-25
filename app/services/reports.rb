class Reports
  attr_accessor :orders, :requester, :csv_url

  def initialize(orders, requester)
    @orders = orders
    @requester = requester
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
    report = Report.create(admin_user_id: @requester.id, csv_url: @csv_url, file_name: @file_name)
    ReportMailer.report_email(report: report).deliver_later
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
    "Affiliate Order"
  ].freeze

  def generate_report
    return @file_data if @file_data.present?

    @file_data = CSV.generate(headers: true) do |csv|
      csv << HEADERS
      insert_orders(csv)

      csv << [""]
      csv << ["Products Bought in this period"]
      products_sold.each do |product|
        csv << [product[:id], product[:title], product[:count]]
      end
    end
  end

  def insert_orders(csv)
    @orders.each do |order|
      csv << [
        order.id,
        order.recipient_name,
        order.status,
        order.reference,
        order.order_no,
        order.franchise&.title,
        order.total,
        order.delivery_charge,
        order.discount_amount,
        order.order_total,
        order.payment&.gateway,
        order.payment&.paid_at,
        order.influencer_id.present? ? "Yes" : "No"
      ]
    end
  end

  def products_sold
    products = {}

    @orders.each do |order|
      order.order_items.each do |item|
        item.product.combo_products.any? ? products_in_combo(products, item) : direct_products_sold(products, item)
      end
    end

    products.values
  end

  def products_in_combo(products, item)
    item.product.combo_products.each do |combo_product|
      unless products[combo_product.product_id]
        products[combo_product.product_id] = {
          id: combo_product.product_id,
          title: combo_product.product.title,
          count: 0
        }
      end
      products[combo_product.product_id][:count] += item.quantity * combo_product.quantity
    end
  end

  def direct_products_sold(products, item)
    unless products[item.product.id]
      products[item.product.id] = {
        id: item.product.id,
        title: item.product.title,
        count: 0
      }
    end
    products[item.product.id][:count] += item.quantity
  end
end
