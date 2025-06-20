ActiveAdmin.register Address do
  permit_params :user_id, :street, :state, :country, :house_number, :delivery_area_id

  actions :all, except: [:destroy]
  menu false

  filter :id
  filter :user
  filter :street
  filter :state
  filter :country
  filter :created_at
  filter :updated_at
  filter :house_number
  filter :delivery_area

  index do
    selectable_column
    id_column
    column :user
    column :house_number
    column :street
    column :delivery_area
    column :state
    column :country
    actions
  end

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
