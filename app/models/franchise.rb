class Franchise < ApplicationRecord
  include StateManagement
  has_many :franchise_product_prices
  has_one :franchise_address
  has_many :staffs

  include StateManagement

  validates :title, uniqueness: true

  accepts_nested_attributes_for :franchise_address

  def as_json(options = {})
    options[:methods] = %i[address]
    # options[:except] = %i[created_at updated_at]
    super
  end

  def address
    franchise_address
  end

  def franchise_owner_staffs
    franchise_owner_department = Department.find_by(name: 'Franchise Owner')
    return [] unless franchise_owner_department

    staffs.joins(:staff_departments)
          .where(staff_departments: { department_id: franchise_owner_department.id })
          .distinct
  end
end
