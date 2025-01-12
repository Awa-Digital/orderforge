ActiveAdmin.register Payment do
  # Specify parameters which should be permitted for assignment
  permit_params :total, :payment_charges, :discount_id, :order_id, :paid, :user_id, :reference, :gateway_reference, :checkout_url, :gateway, :payment_id, :voucher_id, :paid_at

  # or consider:
  #
  # permit_params do
  #   permitted = [:total, :payment_charges, :discount_id, :order_id, :paid, :user_id, :reference, :gateway_reference, :checkout_url, :gateway, :payment_id, :voucher_id, :paid_at]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end

  # For security, limit the actions that should be available
  actions :all, except: []

  # Add or remove filters to toggle their visibility
  filter :id
  filter :total
  filter :payment_charges
  filter :discount
  filter :paid
  filter :created_at
  filter :updated_at
  filter :user
  filter :reference
  filter :gateway_reference
  filter :checkout_url
  filter :gateway
  filter :payment
  filter :voucher
  filter :paid_at

  # Add or remove columns to toggle their visibility in the index action
  index do
    selectable_column
    id_column
    column :total
    column :payment_charges
    column :discount
    column :order
    column :paid
    column :created_at
    column :updated_at
    column :user
    column :reference
    column :gateway_reference
    column :checkout_url
    column :gateway
    column :payment
    column :voucher
    column :paid_at
    actions
  end

  # Add or remove rows to toggle their visibility in the show action
  show do
    attributes_table_for(resource) do
      row :id
      row :total
      row :payment_charges
      row :discount
      row :order
      row :paid
      row :created_at
      row :updated_at
      row :user
      row :reference
      row :gateway_reference
      row :checkout_url
      row :gateway
      row :payment
      row :voucher
      row :paid_at
    end
  end

  # Add or remove fields to toggle their visibility in the form
  form do |f|
    f.semantic_errors(*f.object.errors.attribute_names)
    f.inputs do
      f.input :total
      f.input :payment_charges
      f.input :discount
      f.input :order
      f.input :paid
      f.input :user
      f.input :reference
      f.input :gateway_reference
      f.input :checkout_url
      f.input :gateway
      f.input :payment
      f.input :voucher
      f.input :paid_at
    end
    f.actions
  end
end
