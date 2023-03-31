# frozen_string_literal: true

# Order Receipts
class Receipt
  def initialize(order)
    @logo = 'https://awa-apps.fra1.cdn.digitaloceanspaces.com/JJB/public-space/logo-for-email.png'
    @pdf = Prawn::Document.new(page_size: 'A6')
    @order = order
    @pdf.font 'app/assets/fonts/Inter-Regular.ttf'
  end

  def generate_file
    @pdf.image open(@logo), width: 50, position: :center
    header('Order Receipt')
    recipient
    @pdf.font_size(6) do
      order_items
    end
    sub_total_and_charges
    thanks
    @pdf.render
  end

  def header(header_text)
    @pdf.move_down(20)
    @pdf.font_size(14) do
      @pdf.text header_text, align: :center, font: 'app/assets/fonts/Inter-Bold.ttf'
    end
  end

  def recipient
    @pdf.move_down(10)
    @pdf.font_size(6) do
      @pdf.text 'Billed to:', font: 'app/assets/fonts/Inter-SemiBold.ttf'
      @pdf.text "Name: #{@order.recipient_name}"
      @pdf.text "Phone: #{@order.recipient_phone}"
      @pdf.text "Email: #{@order.recipient_email}"
    end
  end

  def order_items
    @pdf.move_down(10)
    @pdf.table(table_data, cell_style: { border_width: 0 }, width: @pdf.bounds.width) do |table|
      table.row(0).font = 'app/assets/fonts/Inter-Bold.ttf'
      table.row_colors = %w[DDDDDD FFFFFF]
      table.header = true
      table.column(1..3).align = :right
    end
  end

  def table_data
    [items_header, *items]
  end

  def items_header
    %w[Product Amount Qty Subtotal]
  end

  def items
    @order.order_items.map do |item|
      [
        item.product.title,
        ActionController::Base.helpers.number_to_currency(item.product.amount, unit: '₦'),
        item.quantity,
        ActionController::Base.helpers.number_to_currency(item.subtotal, unit: '₦')
      ]
    end
  end

  def sub_total_and_charges
    @pdf.move_down(10)
    @pdf.font_size(6) do
      subtotal
      @pdf.move_down(4)
      vat
      @pdf.move_down(4)
      delivery_charge
      @pdf.move_down(4)
      total
    end
  end

  def subtotal
    @pdf.text 'Subtotal:', size: 6, align: :right
    @pdf.text ActionController::Base.helpers.number_to_currency(@order.total, unit: '₦'), align: :right
  end

  def vat
    @pdf.text 'VAT(7.5%) Charges:', size: 4, align: :right
    @pdf.text ActionController::Base.helpers.number_to_currency(@order.vat_charge, unit: '₦'), align: :right
  end

  def delivery_charge
    @pdf.text 'Delivery Fee:', size: 4, align: :right
    @pdf.text ActionController::Base.helpers.number_to_currency(@order.delivery_charge, unit: '₦'), align: :right
  end

  def total
    @pdf.move_down(4)
    @pdf.text 'Total:', size: 4, align: :right
    @pdf.text ActionController::Base.helpers.number_to_currency(@order.order_total, unit: '₦'), align: :right, size: 10
  end

  def thanks
    @pdf.move_down(10)
    @pdf.text 'Thank you for your patronage!', size: 6, align: :center
    @pdf.move_down(4)
    @pdf.text 'For complains and feedback', size: 6, align: :center
    @pdf.text '+234 907 466 6655', size: 6, align: :center
    @pdf.text 'jazzysburger.com', size: 6, align: :center
  end
end
