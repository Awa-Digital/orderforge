ActiveAdmin.register Order do
  # Specify parameters which should be permitted for assignment

  permit_params :address_id, :user_id, :status, :completed, :paid,
                :reference, :recipient_name, :recipient_phone, :total,
                :recipient_email, :processing_date, :priority, :sent_receipt_notification,
                :sent_processing_notification, :sent_delivering_notification,
                :sent_completed_notification, :sent_guest_receipt_notification, :order_no, :franchise_id

  actions :all, except: [:destroy]

  belongs_to :influencer, optional: true

  # Add controller customization to scope orders by franchise
  controller do
    def scoped_collection
      if current_admin_user.super_user?
        super.includes(:franchise, :payment, :order_items)
      else
        super.where(franchise_id: current_admin_user.franchise.id).includes(:franchise, :payment, :order_items)
      end
    end
  end

  scope "Today's Orders", :today, default: false do |orders|
    if current_admin_user.super_user?
      orders.today
    else
      orders.today.where(franchise_id: current_admin_user.franchise.id)
    end
  end

  scope "All Paid Orders", :paid, default: true do |orders|
    if current_admin_user.super_user?
      orders.paid
    else
      orders.paid.where(franchise_id: current_admin_user.franchise.id)
    end
  end

  scope 'All Orders', :all do |orders|
    if current_admin_user.super_user?
      orders.all
    else
      orders.where(franchise_id: current_admin_user.franchise.id)
    end
  end

  config.sort_order = 'updated_at_desc'

  sidebar 'Business Management', only: %i[show edit] do
    ul class: 'flex flex-col gap-4' do
      li link_to '🛒 Order Address', admin_order_order_address_path(order_id: resource.id, id: resource.order_address.id), class: 'action-item-button'
    end
  end

  filter :id
  filter :order_no
  filter :reference_eq, label: "Order Reference"
  filter :franchise, if: proc { current_admin_user.super_user? }
  filter :payment_paid_at_gteq, label: "Start Date", as: :date_picker
  filter :payment_paid_at_lteq_end_of_day, label: "End Date", as: :date_picker
  filter :status, as: :select, collection: {
    'Initiated' => 'initiated',
    'Paid' => 'paid',
    'Awaiting Processing' => 'awaiting_processing',
    'Processing' => 'processing',
    'Awaiting Packaging' => 'awaiting_packaging',
    'Packaged' => 'packaged',
    'Delivering' => 'delivering',
    'Completed' => 'completed'
  }

  action_item :download_receipt, only: :show do
    link_to 'Download Receipt 🧾',
            download_receipt_admin_order_path(resource),
            method: :post,
            class: 'action-item-button'
  end

  action_item :generate_report, only: :index do
    form_with url: generate_report_admin_orders_path, method: :post, local: true do |f|
      # Preserve current filters as hidden inputs
      if params[:q].present?
        params[:q].each do |key, value|
          concat hidden_field_tag "q[#{key}]", value
        end
      end

      concat f.submit 'Generate Report 📊', class: 'action-item-button'
    end
  end

  collection_action :generate_report, method: :post do
    filters = params[:q]
    orders = collection.except(:limit, :offset)
    params = { order_ids: orders.pluck(:id), user_id: current_admin_user.id, filters: filters }
    ReportTaskJob.perform_async(params.to_json)
    # report = Reports.new(orders, current_admin_user, filters)
    # report.process
    redirect_to admin_orders_path, notice: 'Report generation started. You will receive an email when it is ready.'
  end

  # Define the custom member action
  member_action :download_receipt, method: :post do
    pdf = resource.generate_pdf_receipt
    send_data File.read(pdf), filename: "#{resource.reference}.pdf", type: 'application/pdf', disposition: 'attachment'
  end

  # Add or remove columns to toggle their visibility in the index action
  index do
    selectable_column
    id_column
    column :status do |resource|
      status_tag resource.status, class: case resource.status
                                         when 'initiated' then 'bg-gray-400 text-white'
                                         when 'paid' then 'bg-blue-500 text-white'
                                         when 'awaiting_processing' then 'bg-yellow-500 text-black'
                                         when 'processing' then 'bg-orange-500 text-white'
                                         when 'awaiting_packaging' then 'bg-teal-500 text-white'
                                         when 'packaged' then 'bg-purple-500 text-white'
                                         when 'delivering' then 'bg-indigo-500 text-white'
                                         when 'completed' then 'bg-green-500 text-white'
                                         else 'bg-gray-300 text-black' # Default
                                         end
    end
    column :reference
    column :order_no
    column :franchise
    column :total do |resource|
      number_to_currency(resource.total, unit: '₦', separator: '.', delimiter: ',', precision: 2)
    end
    # column :discount_amount do |resource|
    #   number_to_currency(-1 * resource.discount_amount, unit: '₦', separator: '.', delimiter: ',', precision: 2)
    # end
    column :order_total do |resource|
      number_to_currency(resource.order_total, unit: '₦', separator: '.', delimiter: ',', precision: 2)
    end
    column :paid_at, sortable: true
    actions
  end

  # Add or remove rows to toggle their visibility in the show action
  show do
    attributes_table_for(resource) do
      row :id
      row :order_no
      row :user
      row :recipient_name
      row :status do |resource|
        status_tag resource.status, class: case resource.status
                                           when 'initiated' then 'bg-gray-400 text-white'
                                           when 'paid' then 'bg-blue-500 text-white'
                                           when 'awaiting_processing' then 'bg-yellow-500 text-black'
                                           when 'processing' then 'bg-orange-500 text-white'
                                           when 'awaiting_packaging' then 'bg-teal-500 text-white'
                                           when 'packaged' then 'bg-purple-500 text-white'
                                           when 'delivering' then 'bg-indigo-500 text-white'
                                           when 'completed' then 'bg-green-500 text-white'
                                           else 'bg-gray-300 text-black' # Default
                                           end
      end
      row :paid
      row :created_at
      row :updated_at
      row :reference
      row :recipient_phone do |resource|
        resource.recipient_phone.gsub(/(\d{3})(\d{3})(\d{3})(\d{4})/, '+\1 \2 \3 \4')
      end
      row :total do |resource|
        number_to_currency(resource.total, unit: '₦', separator: '.', delimiter: ',', precision: 2)
      end
      row :recipient_email
      row :processing_date
      row :franchise
      row :address do |resource|
        resource.order_address.as_string
      end
    end

    panel "Order Items" do
      table_for order.order_items do
        column :image do |resource|
          image_tag resource.product.image.url(:thumb)
        end
        column :product
        column :quantity
        column :subtotal do |resource|
          number_to_currency(resource.subtotal, unit: '₦', separator: '.', delimiter: ',', precision: 2)
        end
      end
    end

    payment_data = [
      ["Total", number_to_currency(order.total, unit: '₦', separator: '.', delimiter: ',', precision: 2)],
      ["Delivery Charge", number_to_currency(order.delivery_charge, unit: '₦', separator: '.', delimiter: ',', precision: 2)],
      ["Discount", "- #{number_to_currency(order.payment.discount, unit: '₦', separator: '.', delimiter: ',', precision: 2)}"],
      ["Grand Total", number_to_currency(order.order_total, unit: '₦', separator: '.', delimiter: ',', precision: 2)],
      ["Paid At", order.payment.paid_at],
      ["Payment Gateway", order.payment.gateway]
    ]

    panel "Payment" do
      table_for payment_data do
        thead(class: "hidden") # Hides the header row
        tbody(class: "border-['none']") do
          payment_data.each do |row|
            tr do
              td { row[0] }
              td(b { row[1] })
            end
          end
        end
      end
    end
  end

  # sidebar :details, only: :show do
  #   attributes_table_for order.order_address do
  #     row :house_number
  #     row :street
  #     row :city
  #     row :state
  #     row :country
  #   end
  # end

  # Add or remove fields to toggle their visibility in the form
  form do |f|
    f.semantic_errors(*f.object.errors.attribute_names)
    f.inputs do
      f.input :status, as: :select, collection: %w[initiated paid awaiting_processing processing awaiting_packaging packaged delivering completed], include_blank: false
      f.input :completed
      f.input :paid
      f.input :recipient_name
      f.input :recipient_phone
      f.input :total, input_html: { readonly: true, disabled: true }
      f.input :recipient_email
      f.input :franchise
    end
    f.actions
  end

  csv do
    column :id
    column :recipient_name
    column :status
    column :reference
    column :order_no
    column :franchise do |resource|
      resource.franchise&.title
    end
    column :total, sum: true
    column :delivery_charge, sum: true
    column :discount_amount, sum: true
    column :order_total, sum: true
    column "Gateway" do |resource|
      resource.payment.gateway
    end
    column :paid_at do |resource|
      resource.payment.paid_at
    end
    column "Affliate Order" do |resource|
      resource.influencer_id ? "Yes" : "No"
    end

    order_ids = collection.pluck(:id)

    puts "ORDERS IN THIS SCOPE: #{order_ids.count}"

    products = OrderItem.joins(:product)
                        .where(order_id: order_ids)
                        .group('order_items.product_id', 'products.title')
                        .select('order_items.product_id, products.title AS product_name, SUM(order_items.quantity) AS total_quantity')
                        .order('total_quantity DESC')

    row [""]
    row [""]
    row { ["Products Bought in this period"] }
    products.each do |product|
      row { [product.product_name, product.total_quantity] }
    end
  end
end
