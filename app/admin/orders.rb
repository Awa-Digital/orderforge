ActiveAdmin.register Order do
  # Specify parameters which should be permitted for assignment
  permit_params :address_id, :user_id, :status, :completed, :paid, :reference, :recipient_name, :recipient_phone, :total, :recipient_email, :processing_date, :priority, :sent_receipt_notification, :sent_processing_notification, :sent_delivering_notification, :sent_completed_notification, :sent_guest_receipt_notification, :order_no, :franchise_id

  # or consider:
  #
  # permit_params do
  #   permitted = [:address_id, :user_id, :status, :completed, :paid, :reference, :recipient_name, :recipient_phone, :total, :recipient_email, :processing_date, :priority, :sent_receipt_notification, :sent_processing_notification, :sent_delivering_notification, :sent_completed_notification, :sent_guest_receipt_notification, :order_no, :franchise_id]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end

  # For security, limit the actions that should be available
  actions :all, except: []

  # Add or remove filters to toggle their visibility
  filter :id
  filter :status
  filter :paid
  filter :updated_at
  filter :reference
  filter :franchise

  # Add or remove columns to toggle their visibility in the index action
  index do
    selectable_column
    id_column
    column :status
    column :reference
    column :order_no
    column :franchise
    column :total do |resource|
      number_to_currency(resource.total, unit: '₦', separator: '.', delimiter: ',', precision: 2)
    end
    column :updated_at
    actions
  end

  # Add or remove rows to toggle their visibility in the show action
  show do
    attributes_table_for(resource) do
      row :id
      row :user
      row :status
      row :paid
      row :created_at
      row :updated_at
      row :reference
      row :recipient_name
      row :recipient_phone do |resource|
        resource.recipient_phone.gsub(/(\d{3})(\d{3})(\d{3})(\d{4})/, '+\1 \2 \3 \4')
      end
      row :total do |resource|
        number_to_currency(resource.total, unit: '₦', separator: '.', delimiter: ',', precision: 2)
      end
      row :recipient_email
      row :processing_date
      row :order_no
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
      ["Discount", "- " + number_to_currency(order.payment.discount, unit: '₦', separator: '.', delimiter: ',', precision: 2)],
      ["Grand Total", number_to_currency(order.order_total, unit: '₦', separator: '.', delimiter: ',', precision: 2)],
      ["Paid At", order.payment.paid_at],
      ["Payment Gateway", order.payment.gateway],
    ]

    panel "Payment" do
      table_for payment_data do
        thead(class: "hidden") # Hides the header row
        tbody(class: "border-['none']") do
          payment_data.each do |row|
            tr do
              td { row[0] }
              td { row[1] }
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
      f.input :address
      f.input :user
      f.input :status
      f.input :completed
      f.input :paid
      f.input :reference
      f.input :recipient_name
      f.input :recipient_phone
      f.input :total
      f.input :recipient_email
      f.input :processing_date
      f.input :priority
      f.input :sent_receipt_notification
      f.input :sent_processing_notification
      f.input :sent_delivering_notification
      f.input :sent_completed_notification
      f.input :sent_guest_receipt_notification
      f.input :order_no
      f.input :franchise
    end
    f.actions
  end
end
