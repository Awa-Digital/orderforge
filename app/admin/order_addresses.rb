ActiveAdmin.register OrderAddress do
  # Specify parameters which should be permitted for assignment
  permit_params :order_id, :house_number, :street, :city, :state, :country, :delivery_area_id, :region_id, :location_id

  # or consider:
  #
  # permit_params do
  #   permitted = [:order_id, :house_number, :street, :city, :state, :country, :delivery_area_id, :region_id, :location_id]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end

  # For security, limit the actions that should be available
  actions :all, except: []
  belongs_to :order, singleton: true
  navigation_menu :order

  # Add or remove filters to toggle their visibility
  filter :id
  filter :order
  filter :house_number
  filter :street
  filter :city
  filter :state
  filter :country
  filter :created_at
  filter :updated_at
  filter :delivery_area
  filter :region
  filter :location

  # Add or remove columns to toggle their visibility in the index action
  index do
    selectable_column
    id_column
    column :order
    column :house_number
    column :street
    column :city
    column :state
    column :country
    column :created_at
    column :updated_at
    column :delivery_area
    column :region
    column :location
    actions
  end

  # Add or remove rows to toggle their visibility in the show action
  show do
    attributes_table_for(resource) do
      row :id
      row :order
      row :house_number
      row :street
      row :city
      row :state
      row :country
      row :created_at
      row :updated_at
      row :delivery_area
      row :region
      row :location
    end
  end

  # Add or remove fields to toggle their visibility in the form
  form do |f|
    f.semantic_errors(*f.object.errors.attribute_names)
    f.inputs do
      f.input :order
      f.input :house_number
      f.input :street
      f.input :city
      f.input :state
      f.input :country
      f.input :delivery_area
      f.input :region
      f.input :location
    end
    f.actions
  end
end
