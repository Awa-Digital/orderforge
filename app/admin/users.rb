ActiveAdmin.register User do
  # Specify parameters which should be permitted for assignment
  permit_params :first_name, :last_name, :email, :phone_number, :password_digest, :phone_otp, :active, :avatar, :spend_score, :slug, :status

  # or consider:
  #
  # permit_params do
  #   permitted = [:first_name, :last_name, :email, :phone_number, :password_digest, :phone_otp, :active, :avatar, :spend_score, :slug, :status]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end

  # For security, limit the actions that should be available
  actions :all, except: []

  # Add or remove filters to toggle their visibility
  filter :id
  filter :first_name
  filter :last_name
  filter :email
  filter :phone_number
  filter :created_at
  filter :updated_at
  filter :active
  filter :spend_score
  filter :status

  # Add or remove columns to toggle their visibility in the index action
  index do
    selectable_column
    id_column
    column :avatar do |resource|
      image_tag(resource.avatar.url) if resource.avatar.present?
    end
    column :first_name
    column :last_name
    column :email
    column :phone_number do |resource|
      resource.phone_number.gsub(/(\d{3})(\d{3})(\d{3})(\d{4})/, '+\1 \2 \3 \4')
    end
    column :spend_score do |resource|
      number_to_currency(resource.spend_score, unit: '₦', separator: '.', delimiter: ',', precision: 2)
    end
    column :status
    actions
  end

  # Add or remove rows to toggle their visibility in the show action
  show do
    attributes_table_for(resource) do
      row :id
      row :first_name
      row :last_name
      row :email
      row :phone_number
      row :password_digest
      row :created_at
      row :updated_at
      row :phone_otp
      row :active
      row :avatar
      row :spend_score
      row :slug
      row :status
    end
  end

  # Add or remove fields to toggle their visibility in the form
  form do |f|
    f.semantic_errors(*f.object.errors.attribute_names)
    f.inputs do
      f.input :first_name
      f.input :last_name
      f.input :email
      f.input :phone_number
      f.input :password_digest
      f.input :phone_otp
      f.input :active
      f.input :avatar
      f.input :spend_score
      f.input :slug
      f.input :status
    end
    f.actions
  end
end
