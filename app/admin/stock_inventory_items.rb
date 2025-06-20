ActiveAdmin.register StockInventoryItem do
  # Specify parameters which should be permitted for assignment
  permit_params :stock_id, :inventory_id, :quantity
  menu false

  # or consider:
  #
  # permit_params do
  #   permitted = [:stock_id, :inventory_id, :quantity]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end

  # For security, limit the actions that should be available
  actions :all, except: []

  # Add or remove filters to toggle their visibility
  filter :id
  filter :stock
  filter :inventory
  filter :quantity
  filter :created_at
  filter :updated_at

  # Add or remove columns to toggle their visibility in the index action
  index do
    selectable_column
    id_column
    column :stock
    column :inventory
    column :quantity
    column :created_at
    column :updated_at
    actions
  end

  # Add or remove rows to toggle their visibility in the show action
  show do
    attributes_table_for(resource) do
      row :id
      row :stock
      row :inventory
      row :quantity
      row :created_at
      row :updated_at
    end
  end

  # Add or remove fields to toggle their visibility in the form
  form do |f|
    f.semantic_errors(*f.object.errors.attribute_names)
    f.inputs do
      f.input :stock
      f.input :inventory
      f.input :quantity
    end
    f.actions
  end
end
