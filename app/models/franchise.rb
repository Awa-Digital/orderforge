class Franchise < ApplicationRecord
  include StateManagement
  has_many :franchise_product_prices
  has_one :franchise_address
  has_many :staffs

  validates :title, uniqueness: true

  accepts_nested_attributes_for :franchise_address

  def as_json(options = {})
    options[:methods] = %i[address public_name]
    options[:except] = %i[created_at updated_at]
    super
  end

  def address
    franchise_address
  end

  def public_name
    franchise_address.region.name
  end

  def franchise_owner_staffs
    franchise_owner_department = Department.find_by(name: 'Franchise Owner')
    return [] unless franchise_owner_department

    staffs.joins(:staff_departments)
          .where(staff_departments: { department_id: franchise_owner_department.id })
          .distinct
  end

  def today_orders
    Order.today.where(franchise_id: id).count
  end

  def today_revenue
    Order.today.where(franchise_id: id).sum(:total)
  end

  def today_products
    items = []
    Order.today.where(paid: true).where(franchise_id: id).map do |order|
      order.order_items.each do |item|
        product_exists = items.find { |p| p[:product_id] == item.product_id }
        if product_exists
          product_exists[:quantity] += item.quantity
        else
          items << {
            product_id: item.product_id,
            product_name: item.product.title,
            quantity: item.quantity
          }
        end
      end
    end
    items.sort_by { |item| item[:quantity] }.reverse
  end
end
