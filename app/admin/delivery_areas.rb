ActiveAdmin.register DeliveryArea do
  # Specify parameters which should be permitted for assignment
  permit_params :name, :day_rate, :dusk_rate, :night_rate, :dawn_rate, :region_id, :status

  # or consider:
  #
  # permit_params do
  #   permitted = [:name, :day_rate, :dusk_rate, :night_rate, :dawn_rate, :region_id, :status]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end

  # For security, limit the actions that should be available
  actions :all, except: []
  belongs_to :region
  navigation_menu :region

  # Add or remove filters to toggle their visibility
  filter :id
  filter :name
  filter :region
  filter :status

  # Add or remove columns to toggle their visibility in the index action
  index do
    selectable_column
    id_column
    column :name
    column :day_rate
    column :dusk_rate
    column :night_rate
    column :dawn_rate
    column :region
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
      row :day_rate
      row :dusk_rate
      row :night_rate
      row :dawn_rate
      row :region
      row :status
    end
  end

  # Add or remove fields to toggle their visibility in the form
  form do |f|
    f.semantic_errors(*f.object.errors.attribute_names)
    f.inputs do
      f.input :name
      f.input :day_rate
      f.input :dusk_rate
      f.input :night_rate
      f.input :dawn_rate
      f.input :region, input_html: { disabled: true, readonly: true }
      f.input :status
    end
    f.actions
  end
end
