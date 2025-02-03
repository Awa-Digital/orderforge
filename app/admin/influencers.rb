ActiveAdmin.register Influencer do
  permit_params :name,
                :instagram_handle,
                :twitter_handle,
                :email,
                :password,
                :password_confirmation,
                :status

  actions :all, except: []

  sidebar 'Influencer Management', only: %i[show edit] do
    ul class: 'flex flex-col gap-4' do
      li link_to '🛒 Orders', admin_influencer_orders_path(resource), class: 'action-item-button'
      li link_to "👀 Page Views (#{resource.generated_views})", admin_influencer_affiliate_views_path(resource), class: 'action-item-button'
    end
  end

  filter :id
  filter :name
  filter :instagram_handle
  filter :twitter_handle
  filter :email

  index do
    selectable_column
    id_column
    column :name
    # column :instagram_handle
    # column :twitter_handle
    column :email
    column :updated_at
    column :status
    column :affiliate_link do |resource|
      link_to "Open Link", "https://jazzysburger.com?ref=#{resource.slug}"
    end
    actions
  end

  show do
    attributes_table_for(resource) do
      row :id
      row :name
      row :instagram_handle
      row :twitter_handle
      row :email
      row :created_at
      row :updated_at
      row :status
      row :phone_number
      row :tiktok_handle
      row :facebook_page_handle
      row :followers_count
      row :affiliate_link do |resource|
        link_to "Open Link", "https://jazzysburger.com?ref=#{resource.slug}"
      end
    end
  end

  # Add or remove fields to toggle their visibility in the form
  form do |f|
    f.semantic_errors(*f.object.errors.attribute_names)
    f.inputs do
      f.input :name
      f.input :instagram_handle
      f.input :twitter_handle
      f.input :email
      f.input :password
      f.input :password_confirmation
      f.input :status, as: :select, collection: %w[active deactivated], include_blank: false
    end
    f.actions
  end
end
