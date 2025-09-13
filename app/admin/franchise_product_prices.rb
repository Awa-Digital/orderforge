ActiveAdmin.register FranchiseProductPrice do
  # Specify parameters which should be permitted for assignment
  permit_params :id, :franchise_id, :product_id, :amount, :available

  # For security, limit the actions that should be available
  actions :all, except: [:destroy]
  belongs_to :product
  navigation_menu :product

  # Add or remove filters to toggle their visibility
  filter :id
  filter :franchise
  filter :product
  filter :amount
  filter :created_at
  filter :updated_at

  # Add or remove columns to toggle their visibility in the index action
  index do
    selectable_column
    id_column
    column :franchise
    column :product
    column :amount do |resource|
      number_to_currency(resource.amount, unit: '₦', separator: '.', delimiter: ',', precision: 2)
    end
    column :created_at
    column :updated_at
    actions
  end

  # Add or remove rows to toggle their visibility in the show action
  show do
    attributes_table_for(resource) do
      row :id
      row :franchise
      row :product
      row :amount
      row :created_at
      row :updated_at
      row :updated_by do |resource|
        AdminUser.find_by(id: resource.updater_id)&.email
      end
    end
  end

  # Add or remove fields to toggle their visibility in the form
  form do |f|
    f.semantic_errors(*f.object.errors.attribute_names)
    f.inputs do
      f.input :product
      f.input :amount
      f.input :available
    end
    f.actions
  end
end
