ActiveAdmin.register OrderItem do
  # Specify parameters which should be permitted for assignment
  permit_params :product_id, :quantity, :order_id, :subtotal

  # or consider:
  #
  # permit_params do
  #   permitted = [:product_id, :quantity, :order_id, :subtotal]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end

  # For security, limit the actions that should be available
  actions :all, except: []

  # Add or remove filters to toggle their visibility
  filter :id
  filter :product
  filter :quantity
  filter :order
  filter :created_at
  filter :updated_at
  filter :subtotal

  # Add or remove columns to toggle their visibility in the index action
  index do
    selectable_column
    id_column
    column :product
    column :quantity
    column :order
    column :created_at
    column :updated_at
    column :subtotal
    actions
  end

  # Add or remove rows to toggle their visibility in the show action
  show do
    attributes_table_for(resource) do
      row :id
      row :product
      row :quantity
      row :order
      row :created_at
      row :updated_at
      row :subtotal
    end
  end

  # Add or remove fields to toggle their visibility in the form
  form do |f|
    f.semantic_errors(*f.object.errors.attribute_names)
    f.inputs do
      f.input :product
      f.input :quantity
      f.input :order
      f.input :subtotal
    end
    f.actions
  end
end
