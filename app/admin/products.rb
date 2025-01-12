ActiveAdmin.register Product do
  # Specify parameters which should be permitted for assignment
  permit_params :title, :description, :image, :category_id, :amount, :liked, :subcategory_id, :start_time, :end_time, :status

  # or consider:
  #
  # permit_params do
  #   permitted = [:title, :description, :image, :category_id, :amount, :liked, :subcategory_id, :start_time, :end_time, :status]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end

  # For security, limit the actions that should be available
  actions :all, except: []

  # Add or remove filters to toggle their visibility
  filter :id
  filter :title
  filter :description
  filter :category
  filter :amount
  filter :subcategory
  filter :start_time
  filter :end_time
  filter :status

  # Add or remove columns to toggle their visibility in the index action
  index do
    selectable_column
    id_column
    column :title
    column :image do |resource|
      image_tag(resource.image.url) if resource.image.present?
    end
    column :amount do |resource|
      number_to_currency(resource.amount, unit: '₦', separator: '.', delimiter: ',', precision: 2)
    end
    column :category
    column :subcategory
    column :start_time
    column :end_time
    column :status
    actions
  end

  # Add or remove rows to toggle their visibility in the show action
  show do
    attributes_table_for(resource) do
      row :id
      row :title
      row :description
      # row :image
      row :image do |resource|
        image_tag(resource.image.url) if resource.image.present?
      end
      row :category
      row :amount
      row :created_at
      row :updated_at
      row :subcategory
      row :start_time
      row :end_time
      row :status
    end


    panel "Prices" do
      table_for product.franchise_product_prices do
        column :id
        column :franchise
        column :product
        column :amount do |resource|
          number_to_currency(resource.amount, unit: '₦', separator: '.', delimiter: ',', precision: 2)
        end
        column :created_at
        column :updated_at
        column "Actions" do |resource|
          links = []
          links << link_to("View", admin_franchise_product_price_path(resource))
          links << link_to("Edit", edit_admin_franchise_product_price_path(resource))
          links << link_to("Delete", admin_franchise_product_price_path(resource), method: :delete, data: { confirm: "Are you sure?" })
          safe_join(links, " | ")
        end
      end
    end
  end

  # Add or remove fields to toggle their visibility in the form
  form do |f|
    f.semantic_errors(*f.object.errors.attribute_names)
    f.inputs do
      f.input :title
      f.input :description
      f.input :image
      f.input :category
      f.input :amount
      f.input :liked
      f.input :subcategory
      f.input :start_time
      f.input :end_time
      f.input :status
    end
    f.actions
  end
end
