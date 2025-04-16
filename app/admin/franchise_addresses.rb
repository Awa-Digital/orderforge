ActiveAdmin.register FranchiseAddress do
  # Specify parameters which should be permitted for assignment
  permit_params :franchise_id, :region_id, :location_id, :street, :longitude, :latitude

  # or consider:
  #
  # permit_params do
  #   permitted = [:franchise_id, :region_id, :location_id, :street, :longitude, :latitude]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end

  # For security, limit the actions that should be available
  actions :all, except: [:destroy]

  # Add or remove filters to toggle their visibility
  filter :id
  filter :franchise
  filter :region
  filter :location
  filter :street
  filter :longitude
  filter :latitude
  filter :created_at
  filter :updated_at

  # Add or remove columns to toggle their visibility in the index action
  index do
    selectable_column
    id_column
    column :franchise
    column :region
    column :location
    column :street
    column :longitude
    column :latitude
    column :created_at
    column :updated_at
    actions
  end

  # Add or remove rows to toggle their visibility in the show action
  show do
    attributes_table_for(resource) do
      row :id
      row :franchise
      row :region
      row :location
      row :street
      row :longitude
      row :latitude
      row :created_at
      row :updated_at
    end
  end

  # Add or remove fields to toggle their visibility in the form
  form do |f|
    f.semantic_errors(*f.object.errors.attribute_names)
    f.inputs do
      f.input :franchise
      f.input :region
      # f.input :location
      f.input :street
      f.input :longitude
      f.input :latitude
    end
    f.actions
  end
end
