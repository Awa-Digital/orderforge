ActiveAdmin.register Region do
  # Specify parameters which should be permitted for assignment
  permit_params :location_id, :name, :status

  menu parent: "Available Locations", label: "Available Cities"

  # or consider:
  #
  # permit_params do
  #   permitted = [:location_id, :name, :status]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end

  # For security, limit the actions that should be available
  actions :all, except: []

  # Add or remove filters to toggle their visibility
  filter :id
  filter :location
  filter :created_at
  filter :updated_at
  filter :name
  filter :status

  # Add or remove columns to toggle their visibility in the index action
  index do
    selectable_column
    id_column
    column :name
    column :location
    column :updated_at
    column :status
    actions
  end

  # Add or remove rows to toggle their visibility in the show action
  show do
    attributes_table_for(resource) do
      row :id
      row :location
      row :created_at
      row :updated_at
      row :name
      row :status
    end
  end

  # Add or remove fields to toggle their visibility in the form
  form do |f|
    f.semantic_errors(*f.object.errors.attribute_names)
    f.inputs do
      f.input :location
      f.input :name
      f.input :status
    end
    f.actions
  end
end
