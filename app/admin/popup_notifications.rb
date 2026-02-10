ActiveAdmin.register PopupNotification do
  menu if: proc { current_admin_user.super_user? }

  # permitted params
  permit_params :image, :url, :description

  # actions available
  actions :all

  # filters
  filter :id
  filter :url
  filter :created_at

  # index table
  index do
    selectable_column
    id_column
    column :image do |popup_notification|
      image_tag popup_notification.image.url, width: 100
    end
    column :url
    column :description
    column :created_at
    actions
  end

  # show page
  show do
    attributes_table_for(resource) do
      row :id
      row :image do |popup_notification|
        image_tag popup_notification.image.url, width: 100
      end
      row :url
      row :description
      row :created_at
      row :updated_at
    end
  end

  # form
  form do |f|
    f.semantic_errors(*f.object.errors.attribute_names)
    f.inputs do
      f.input :image
      f.input :url
      f.input :description
    end
    f.actions
  end
end
