ActiveAdmin.register Product do
  permit_params :title, :description, :image, :category_id, :amount, :liked, :subcategory_id, :start_time, :end_time, :status, :combo

  actions :all, except: [:destroy]

  filter :id
  filter :title
  filter :description
  filter :category
  filter :amount, if: proc { current_admin_user.super_user? }
  filter :subcategory
  filter :start_time
  filter :end_time
  filter :status
  filter :combo

  index do
    selectable_column
    id_column
    column :image do |resource|
      image_tag(resource.image.url, class: "w-10 h-10 rounded-md") if resource.image.present?
    end
    column :title
    if current_admin_user.super_user?
      column "Default Amount", :amount do |resource|
        number_to_currency(resource.amount, unit: '₦', separator: '.', delimiter: ',', precision: 2)
      end
    else
      column "Price" do |resource|
        franchise_price = resource.franchise_product_prices.find_by(franchise_id: current_admin_user.franchise.id)
        if franchise_price&.amount.present?
          number_to_currency(franchise_price.amount, unit: '₦', separator: '.', delimiter: ',', precision: 2)
        else
          "Not set"
        end
      end
    end
    column :category
    column :subcategory
    column :combo
    column :status
    column :start_time
    column :end_time
    actions
  end

  member_action :toggle_availability, method: :put do
    franchise_price = resource.franchise_product_prices.find_by(id: params[:franchise_price_id])
    if franchise_price
      franchise_price.update(available: !franchise_price.available)
      render json: { available: franchise_price.available }
    else
      render json: { error: 'Franchise price not found' }, status: :not_found
    end
  end

  show do
    attributes_table_for(resource) do
      row :id
      row :image do |resource|
        image_tag(resource.image.url) if resource.image.present?
      end
      row :title
      row :description
      row :category
      if current_admin_user.super_user?
        row :amount do |resource|
          number_to_currency(resource.amount, unit: '₦', separator: '.', delimiter: ',', precision: 2)
        end
      else
        row "Price" do |resource|
          franchise_price = resource.franchise_product_prices.find_by(franchise_id: current_admin_user.franchise.id)
          if franchise_price&.amount.present?
            number_to_currency(franchise_price.amount, unit: '₦', separator: '.', delimiter: ',', precision: 2)
          else
            "Not set"
          end
        end
      end
      row :created_at
      row :updated_at
      row :subcategory
      row :start_time
      row :end_time
      row :status
    end

    if current_admin_user.super_user?
      panel "Prices" do
        table_for product.franchise_product_prices do
          column :id
          column :franchise
          column :amount do |resource|
            number_to_currency(resource.amount, unit: '₦', separator: '.', delimiter: ',', precision: 2)
          end
          # column :updated_at
          column :available, class: "text-center" do |resource|
            link_to toggle_availability_admin_product_path(resource: resource.product, franchise_price_id: resource.id),
                    method: :put, data: { confirm: "Are you sure?" } do
              div class: "mx-auto cursor-pointer availability-toggle w-[24px] h-[24px] rounded-md flex items-center justify-center #{resource.available ? 'bg-green-500 text-white' : 'border-slate-500 border'}",
                  data: {
                    franchise_price_id: resource.id,
                    url: toggle_availability_admin_product_path(
                      resource: resource.product,
                      franchise_price_id: resource.id
                    )
                  } do
                div class: "availability-toggle-icon" do
                  if resource.available
                    svg xmlns: "http://www.w3.org/2000/svg",
                        width: "20",
                        height: "20",
                        viewBox: "0 0 24 24",
                        fill: "none",
                        stroke: "currentColor",
                        'stroke-width': "2",
                        'stroke-linecap': "round",
                        'stroke-linejoin': "round" do
                      tag(:path, d: "M20 6 9 17l-5-5")
                    end
                  else
                    svg xmlns: "http://www.w3.org/2000/svg",
                        width: "20",
                        height: "20",
                        class: "lucide lucide-x",
                        viewBox: "0 0 24 24",
                        fill: "none",
                        stroke: "currentColor",
                        'stroke-width': "2",
                        'stroke-linecap': "round",
                        'stroke-linejoin': "round" do
                      tag(:path, d: "M18 6 6 18")
                      tag(:path, d: "M6 6l12 12")
                    end
                  end
                end
              end
            end
          end

          column "Actions" do |resource|
            links = []
            links << link_to(
              "View",
              admin_product_franchise_product_price_path(
                product_id: resource.product,
                id: resource.id
              )
            )
            links << link_to(
              "Edit",
              edit_admin_product_franchise_product_price_path(
                product_id: resource.product,
                id: resource.id
              )
            )
            links << link_to(
              "Delete",
              admin_product_franchise_product_price_path(
                product_id: resource.product,
                id: resource.id
              ), method: :delete, data: { confirm: "Are you sure?" }
            )
            safe_join(links, " | ")
          end
        end
      end
    end

    if product.ingredients.any?
      panel "Ingredients" do
        table_for product.ingredients do
          column :id
          column :name
          column :icon
        end
      end
    end

    panel "Inventories" do
      div class: "panel-body" do
        if product.inventories.any?
          table_for product.inventories do
            column :code
            column :name
            column :description
            column :expires
            column :state
            column :status
            column :quantity do |resource|
              resource.product_inventory_items.find_by(product_id: product.id).quantity
            end
          end
        else
          p "No inventories added to this product"
        end
      end

      div class: "panel-footer p-4" do
        link_to "+ Add Inventory", new_admin_product_inventory_item_path(product_id: product.id), class: "action-item-button"
      end
    end

    panel "Stocks" do
      div class: "panel-body" do
        if product.stocks.any?
          table_for product.stocks do
            column :code
            column :name
            column :description
            column :expires
            column :state
            column :status
            column :quantity do |resource|
              resource.product_stock_items.find_by(product_id: product.id).quantity
            end
          end
        else
          p "No stocks added to this product"
        end
      end

      div class: "panel-footer p-4" do
        link_to "+ Add Stock", new_admin_product_stock_item_path(product_id: product.id), class: "action-item-button"
      end
    end

    if product.combo_products.any?
      panel "Sub Products" do
        table_for product.combo_products do
          column :id
          column :product
          column :quantity
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
      f.input :amount if current_admin_user.super_user?
      f.input :liked
      f.input :subcategory
      f.input :start_time
      f.input :end_time
      f.input :combo
      f.input :status
    end
    f.actions
  end
end
