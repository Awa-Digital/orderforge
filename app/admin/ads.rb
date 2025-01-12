ActiveAdmin.register Ad do
  # Specify parameters which should be permitted for assignment
  permit_params :image, :title, :expiration_date, :product_id, :url

  # or consider:
  #
  # permit_params do
  #   permitted = [:image, :title, :expiration_date, :product_id, :url]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end

  # For security, limit the actions that should be available
  actions :all, except: []

  # Add or remove filters to toggle their visibility
  filter :id
  filter :image
  filter :title
  filter :expiration_date
  filter :created_at
  filter :updated_at
  filter :product
  filter :url

  # Add or remove columns to toggle their visibility in the index action
  index do
    selectable_column
    id_column
    column :image
    column :title
    column :expiration_date
    column :created_at
    column :updated_at
    column :product
    column :url
    actions
  end

  # Add or remove rows to toggle their visibility in the show action
  show do
    attributes_table_for(resource) do
      row :id
      row :image
      row :title
      row :expiration_date
      row :created_at
      row :updated_at
      row :product
      row :url
    end
  end

  # Add or remove fields to toggle their visibility in the form
  form do |f|
    f.semantic_errors(*f.object.errors.attribute_names)
    f.inputs do
      f.input :image
      f.input :title
      f.input :expiration_date
      f.input :product
      f.input :url
    end
    f.actions
  end
end
