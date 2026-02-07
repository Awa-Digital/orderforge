ActiveAdmin.register Voucher do
  # Specify parameters which should be permitted for assignment

  menu label: "Discounts", if: proc { current_admin_user.super_user? }

  permit_params :title, :discount_code, :influencer_id, :discount_rate, :expiration_date, :status

  # or consider:
  #
  # permit_params do
  #   permitted = [:title, :discount_code, :influencer_id, :discount_rate, :expiration_date, :status]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end

  # For security, limit the actions that should be available
  actions :all, except: [:destroy]
  scope "Active Discounts", :all, default: true
  scope "Previous Discounts", :unscoped

  # Add or remove filters to toggle their visibility
  filter :id
  filter :title
  filter :discount_code
  filter :influencer
  filter :discount_rate
  filter :created_at
  filter :updated_at
  filter :expiration_date
  filter :status
  filter :orders_count

  # Add or remove columns to toggle their visibility in the index action
  index do
    selectable_column
    id_column
    # column :title
    column "Code", :discount_code
    column :influencer
    column "%", :discount_rate
    column "Orders", :orders_count
    # column :created_at
    # column :updated_at
    column "Expires", :expiration_date do |resource|
      resource.expiration_date.strftime("%d %b %Y") if resource.expiration_date.present?
      "N/A" if resource.expiration_date.blank?
    end
    column :status do |resource|
      status_tag resource.status.titleize
    end
    actions
  end

  # Add or remove rows to toggle their visibility in the show action
  show do
    attributes_table_for(resource) do
      row :id
      row :title
      row :discount_code
      row :influencer
      row :discount_rate
      row :orders_count
      row :created_at
      row :updated_at
      row :expiration_date
      row :status
    end
  end

  # Add or remove fields to toggle their visibility in the form
  form do |f|
    f.semantic_errors(*f.object.errors.attribute_names)
    f.inputs do
      f.input :title
      f.input :discount_code
      f.input :influencer
      f.input :discount_rate
      f.input :orders_count, input_html: { readonly: true, disabled: true }, hint: "Number of orders using this discount (auto-updated)"
      f.input :expiration_date
      f.input :status
    end
    f.actions
  end
end
