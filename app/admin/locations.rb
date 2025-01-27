ActiveAdmin.register Location do
  # Specify parameters which should be permitted for assignment
  permit_params :name, :status

  menu parent: "Available Locations", label: "Countries"

  # or consider:
  #
  # permit_params do
  #   permitted = [:name, :status]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end

  # For security, limit the actions that should be available
  actions :all, except: []

  # Add or remove filters to toggle their visibility
  filter :id
  filter :name
  filter :created_at
  filter :updated_at
  filter :status

  # Add or remove columns to toggle their visibility in the index action
  index do
    selectable_column
    id_column
    column :name
    column :status
    actions
  end

  # Add or remove rows to toggle their visibility in the show action
  show do
    attributes_table_for(resource) do
      row :id
      row :name
      row :created_at
      row :updated_at
      row :status
    end
  end

  # Add or remove fields to toggle their visibility in the form
  form do |f|
    f.semantic_errors(*f.object.errors.attribute_names)
    f.inputs do
      f.input :name
      f.input :status
    end
    f.actions
  end
end
