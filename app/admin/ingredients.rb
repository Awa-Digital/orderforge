ActiveAdmin.register Ingredient do
  # Specify parameters which should be permitted for assignment
  permit_params :name, :icon

  # or consider:
  #
  # permit_params do
  #   permitted = [:name, :icon]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end

  # For security, limit the actions that should be available
  actions :all, except: [:destroy]

  # Add or remove filters to toggle their visibility
  filter :id
  filter :name

  # Add or remove columns to toggle their visibility in the index action
  index do
    selectable_column
    id_column
    column :name
    column :icon do |resource|
      image_tag(resource.icon.url) if resource.icon.present?
    end
    column :created_at
    column :updated_at
    actions
  end

  # Add or remove rows to toggle their visibility in the show action
  show do
    attributes_table_for(resource) do
      row :id
      row :name
      row :icon
      row :created_at
      row :updated_at
    end
  end

  # Add or remove fields to toggle their visibility in the form
  form do |f|
    f.semantic_errors(*f.object.errors.attribute_names)
    f.inputs do
      f.input :name
      f.input :icon
    end
    f.actions
  end
end
