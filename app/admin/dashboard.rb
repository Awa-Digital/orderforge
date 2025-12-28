ActiveAdmin.register_page "Dashboard" do
  menu priority: 1, label: proc {
    if current_admin_user.super_user?
      I18n.t("active_admin.dashboard")
    else
      "#{current_admin_user.franchise&.title} Dashboard"
    end
  }

  content title: proc {
    if current_admin_user.super_user?
      "Super Admin Dashboard"
    else
      "#{current_admin_user.franchise&.title} Dashboard"
    end
  } do
    # Metrics panels using divs for layout
    div class: "grid grid-cols-12 justify-between mb-8 gap-6" do
      div class: "col-span-12" do
        h3 "Today's Summary", class: "text-black dark:text-white font-bold text-xl"
      end

      div class: "col-span-6 md:col-span-3 w-full p-4 bg-slate-50 dark:bg-slate-800 rounded-lg" do
        h3 "Orders", class: "text-slate-600 dark:text-slate-300"
        h1(
          if current_admin_user.super_user?
            Order.today.count
          else
            Order.today.where(franchise_id: current_admin_user.franchise.id).count
          end,
          class: "text-[18px] md:text-[24px] font-bold text-slate-900 dark:text-white"
        )
      end

      div class: "col-span-6 md:col-span-3 w-full p-4 bg-slate-50 dark:bg-slate-800 rounded-lg" do
        h3 "Registered Users", class: "text-slate-600 dark:text-slate-300"
        h2 number_to_currency(
          if current_admin_user.super_user?
            User.count
          else
            User.where("associated_franchises @> ARRAY[?]::integer[]", current_admin_user.franchise.id).count
          end,
          unit: '',
          separator: '.',
          delimiter: ',',
          precision: 0
        ), class: "text-[18px] md:text-[24px] font-bold text-slate-900 dark:text-white"
      end

      div class: "col-span-6 md:col-span-3 w-full p-4 bg-slate-50 dark:bg-slate-800 rounded-lg" do
        h3 "Revenue", class: "text-slate-600 dark:text-slate-300"
        h2 number_to_currency(
          if current_admin_user.super_user?
            Order.todays_revenue
          else
            Order.todays_franchise_revenue(current_admin_user.franchise.id)
          end,
          unit: '₦',
          separator: '.',
          delimiter: ',',
          precision: 2
        ), class: "text-[18px] md:text-[24px] font-bold text-slate-900 dark:text-white"
      end

      div class: "col-span-6 md:col-span-3 w-full p-4 bg-slate-50 dark:bg-slate-800 rounded-lg" do
        h3 "Delivery Revenue", class: "text-slate-600 dark:text-slate-300"
        h2 number_to_currency(
          if current_admin_user.super_user?
            Order.todays_delivery_revenue
          else
            Order.todays_franchise_delivery_revenue(current_admin_user.franchise.id)
          end,
          unit: '₦',
          separator: '.',
          delimiter: ',',
          precision: 2
        ), class: "text-[18px] md:text-[24px] font-bold text-slate-900 dark:text-white"
      end
    end

    # Recent orders table in a div container
    div class: "grid grid-cols-12 gap-6" do
      if current_admin_user.super_user?
        # Revenue Stream
        div class: "col-span-12 md:col-span-6" do
          h3 "Revenue Stream", class: "text-[24px] font-medium text-slate-900 dark:text-white mb-4"
          table_for(
            Franchise.all,
            id: "franchises-table",
            class: "border-[1px] border-slate-200 dark:border-slate-700 rounded w-full",
            row_html: ->(resource) { { class: "cursor-pointer hover:bg-slate-100 dark:hover:bg-slate-800", data: { url: admin_franchise_path(resource) } } }
          ) do
            column :title do |resource|
              status_tag resource.title, class: "bg-blue-500 dark:bg-blue-600 text-white"
            end
            column :today_orders do |resource|
              span resource.today_orders, class: "text-slate-900 dark:text-white"
            end
            column :today_revenue do |resource|
              span number_to_currency(resource.today_revenue, unit: '₦', separator: '.', delimiter: ',', precision: 2),
                   class: "text-slate-900 dark:text-white"
            end
          end
        end
      end

      # Top Products
      div class: "col-span-12  #{'md:col-span-6' if current_admin_user.super_user?}" do
        h3 "Today's Top Products", class: "text-[24px] font-medium text-slate-900 dark:text-white mb-4"
        table_for(
          if current_admin_user.super_user?
            Product.today_products[0..Franchise.count - 1]
          else
            Product.franchise_today_products(current_admin_user.franchise.id)[0..Franchise.count - 1]
          end,
          class: "border-[1px] border-slate-200 dark:border-slate-700 rounded w-full"
        ) do
          column :product_name, class: "text-slate-900 dark:text-white" do |resource|
            link_to resource[:product_name], admin_product_path(resource[:product_id]), class: "text-blue-500 dark:text-blue-400 hover:underline"
          end
          column "Qty", :quantity, class: "text-slate-900 dark:text-white text-center"
        end
      end

      div class: "col-span-12" do
        h3 "Recent Orders", class: "text-[24px] font-medium text-slate-900 dark:text-white mb-4"
        table_for(
          if current_admin_user.super_user?
            Order.today.limit(10)
          else
            Order.today.where(franchise_id: current_admin_user.franchise.id).limit(10)
          end,
          class: "border-[1px] border-slate-200 dark:border-slate-700 rounded w-full"
        ) do
          column :id, class: "text-slate-900 dark:text-white"
          column :reference, class: "text-slate-900 dark:text-white"
          column :status do |resource|
            status_tag resource.status, class: case resource.status
                                               when 'initiated' then 'bg-gray-400 dark:bg-gray-600 text-white'
                                               when 'paid' then 'bg-blue-500 dark:bg-blue-600 text-white'
                                               when 'awaiting_processing' then 'bg-yellow-500 dark:bg-yellow-600 text-black dark:text-white'
                                               when 'processing' then 'bg-orange-500 dark:bg-orange-600 text-white'
                                               when 'awaiting_packaging' then 'bg-teal-500 dark:bg-teal-600 text-white'
                                               when 'packaged' then 'bg-purple-500 dark:bg-purple-600 text-white'
                                               when 'delivering' then 'bg-indigo-500 dark:bg-indigo-600 text-white'
                                               when 'completed' then 'bg-green-500 dark:bg-green-600 text-white'
                                               else 'bg-gray-300 dark:bg-gray-600 text-black dark:text-white'
                                               end
          end
          column :order_no do |resource|
            span "##{resource.order_no}", class: "text-slate-900 dark:text-white"
          end
          if current_admin_user.super_user?
            column :franchise do |resource|
              puts "THIS IS THE RESOURCE MISSING FRANCHISE #{resource.id}" if resource.franchise.nil?
              status_tag resource.franchise&.title, class: "bg-blue-500 dark:bg-blue-600 text-white"
            end
          end
          column :total do |resource|
            span number_to_currency(resource.order_total, unit: '₦', separator: '.', delimiter: ',', precision: 2),
                 class: "text-slate-900 dark:text-white"
          end
          # # column :updated_at, class: "text-slate-900 dark:text-white"
          # column "Actions" do |resource|
          #   div class: "flex gap-2" do
          #     link_to "View", admin_orders_path(resource),
          #             class: "px-2 py-1 text-sm rounded bg-blue-500 dark:bg-blue-600  hover:bg-blue-600 dark:hover:bg-blue-700"
          #     link_to "Edit", edit_admin_order_path(resource),
          #             class: "px-2 py-1 text-sm rounded bg-green-500 dark:bg-green-600 text-white hover:bg-green-600 dark:hover:bg-green-700"
          #     link_to "Delete", admin_orders_path(resource),
          #             method: :delete,
          #             data: { confirm: "Are you sure?" },
          #             class: "px-2 py-1 text-sm rounded bg-red-500 dark:bg-red-600 text-white hover:bg-red-600 dark:hover:bg-red-700"
          #   end
          # end
        end
      end
    end
  end
end
