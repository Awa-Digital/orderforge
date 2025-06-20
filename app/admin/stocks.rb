ActiveAdmin.register Stock do
  # Specify parameters which should be permitted for assignment
  permit_params :code, :name, :description, :state, :expires, :status

  # or consider:
  #
  # permit_params do
  #   permitted = [:code, :name, :description, :state, :expires, :status]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end

  # For security, limit the actions that should be available

  actions :all, except: [:destroy]

  # Add or remove filters to toggle their visibility
  filter :id
  filter :code
  filter :name
  filter :state
  filter :expires
  filter :status

  # Add or remove columns to toggle their visibility in the index action
  index do
    selectable_column
    id_column
    column :code
    column :name
    column :description
    column :state
    column :expires
    column :created_at
    column :updated_at
    column :status
    actions
  end

  # Add or remove rows to toggle their visibility in the show action
  show do
    attributes_table_for(resource) do
      row :id
      row :code
      row :name
      row :description
      row :state
      row :expires
      row :created_at
      row :updated_at
      row :status
    end

    panel "Inventory Items" do
      table_for resource.inventories do
        column :id
        column :code
        column :name
        column :description
        column :state
        column :expires
        column :status
        column :quantity do |inventory|
          inventory.stock_inventory_items.find_by(stock_id: resource.id).quantity
        end
      end
    end
  end

  # Add or remove fields to toggle their visibility in the form
  form do |f|
    f.semantic_errors(*f.object.errors.attribute_names)
    f.inputs do
      f.input :code
      f.input :name
      f.input :description
      f.input :state
      f.input :expires
      f.input :status
    end
    f.actions
  end
end
