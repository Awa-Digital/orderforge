ActiveAdmin.register Address do
  # Specify parameters which should be permitted for assignment
  permit_params :user_id, :street, :state, :country, :house_number, :delivery_area_id

  # or consider:
  #
  # permit_params do
  #   permitted = [:user_id, :street, :state, :country, :house_number, :delivery_area_id]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end

  # For security, limit the actions that should be available
  actions :all, except: [:destroy]
  menu false

  # Add or remove filters to toggle their visibility
  filter :id
  filter :user
  filter :street
  filter :state
  filter :country
  filter :created_at
  filter :updated_at
  filter :house_number
  filter :delivery_area

  # Add or remove columns to toggle their visibility in the index action
  index do
    selectable_column
    id_column
    column :user
    column :house_number
    column :street
    column :delivery_area
    column :state
    column :country
    # column :created_at
    # column :updated_at
    actions
  end

  # Add or remove rows to toggle their visibility in the show action
  show do
    attributes_table_for(resource) do
      row :id
      row :user
      row :street
      row :state
      row :country
      row :created_at
      row :updated_at
      row :house_number
      row :delivery_area
    end
  end

  # Add or remove fields to toggle their visibility in the form
  form do |f|
    f.semantic_errors(*f.object.errors.attribute_names)
    f.inputs do
      f.input :user
      f.input :street
      f.input :state
      f.input :country
      f.input :house_number
      f.input :delivery_area
    end
    f.actions
  end
end
