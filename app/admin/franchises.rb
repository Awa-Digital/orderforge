ActiveAdmin.register Franchise do
  # Specify parameters which should be permitted for assignment
  permit_params :title, :description, :status, :email

  # or consider:
  #
  # permit_params do
  #   permitted = [:title, :description, :status, :email]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end
  #
  menu if: proc { current_admin_user.super_user? }

  # For security, limit the actions that should be available
  actions :all, except: []

  # Add or remove filters to toggle their visibility
  filter :id
  filter :title
  filter :description
  filter :created_at
  filter :updated_at
  filter :status
  filter :email

  # Add or remove columns to toggle their visibility in the index action
  index do
    selectable_column
    id_column
    column :title
    column :description
    column :created_at
    column :updated_at
    column :status
    column :email
    actions
  end

  # Add or remove rows to toggle their visibility in the show action
  show do
    div class: "grid grid-cols-12 gap-6" do
      # Metrics panels using divs for layout
      div class: "col-span-12 grid grid-cols-12 justify-between mb-8 gap-6" do
        div class: "col-span-12" do
          h3 "Today's Summary", class: "text-black font-bold text-xl"
        end

        div class: "col-span-6 md:col-span-3 w-full p-4 bg-slate-50 dark:bg-slate-800 rounded-lg" do
          h3 "Orders", class: "text-slate-600 dark:text-slate-300"
          h1(
            Order.today.where(franchise_id: resource.id).count,
            class: "text-[18px] md:text-[24px] font-bold text-slate-900 dark:text-white"
          )
        end

        div class: "col-span-6 md:col-span-3 w-full p-4 bg-slate-50 dark:bg-slate-800 rounded-lg" do
          h3 "Spending Users", class: "text-slate-600 dark:text-slate-300"
          h2 number_to_currency(
            User.where("associated_franchises @> ARRAY[?]::integer[]", resource.id).count,
            unit: '',
            separator: '.',
            delimiter: ',',
            precision: 0
          ), class: "text-[18px] md:text-[24px] font-bold text-slate-900 dark:text-white"
        end

        div class: "col-span-6 md:col-span-3 w-full p-4 bg-slate-50 dark:bg-slate-800 rounded-lg" do
          h3 "Revenue", class: "text-slate-600 dark:text-slate-300"
          h2 number_to_currency(
            Payment.paid_at_today
                    .joins(:order)
                    .where(orders: { franchise_id: resource.id })
                    .reduce(0) { |sum, i| sum + i.total },
            unit: '₦',
            separator: '.',
            delimiter: ',',
            precision: 2
          ), class: "text-[18px] md:text-[24px] font-bold text-slate-900 dark:text-white"
        end

        div class: "col-span-6 md:col-span-3 w-full p-4 bg-slate-50 dark:bg-slate-800 rounded-lg" do
          h3 "Delivery Revenue", class: "text-slate-600 dark:text-slate-300"
          h2 number_to_currency(
            Order.todays_franchise_delivery_revenue(resource.id),
            unit: '₦',
            separator: '.',
            delimiter: ',',
            precision: 2
          ), class: "text-[18px] md:text-[24px] font-bold text-slate-900 dark:text-white"
        end
      end

      # Top Products
      div class: "col-span-12" do
        h3 "Products Bought Today", class: "text-[24px] font-medium text-slate-900 dark:text-white mb-4"
        table_for(
          Product.franchise_today_products(resource.id),
          class: "border-[1px] border-slate-200 dark:border-slate-700 rounded w-full"
        ) do
          column :product_name, class: "text-slate-900 dark:text-white" do |resource|
            link_to resource[:product_name], admin_product_path(resource[:product_id]), class: "text-blue-500 dark:text-blue-400 hover:underline"
          end
          column "Qty", :quantity, class: "text-slate-900 dark:text-white text-center"
        end
      end
      div class: "col-span-12 flex flex-col gap-4" do
        h3 "Franchise Details", class: "text-[24px] font-medium text-slate-900 dark:text-white mb-4"
        attributes_table_for(resource) do
          row :id
          row :title
          row :description
          row :created_at
          row :updated_at
          row :status
          row :email
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
      f.input :status
      f.input :email
    end
    f.actions
  end
end
