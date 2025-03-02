ActiveAdmin.register_page "Dashboard" do
  menu priority: 1, label: proc {
    if current_admin_user.super_user?
      I18n.t("active_admin.dashboard")
    else
      "#{current_admin_user.franchise.title} Dashboard"
    end
  }

  content title: proc {
    if current_admin_user.super_user?
      I18n.t("active_admin.dashboard")
    else
      "#{current_admin_user.franchise.title} Dashboard"
    end
  } do
    # Metrics panels using divs for layout
    div class: "flex justify-between mb-8 gap-[2px]" do
      div class: "w-full p-4 bg-slate-50 dark:bg-slate-800 rounded-lg" do
        h3 "Today's Orders", class: "text-slate-600 dark:text-slate-300"
        h1(
          if current_admin_user.super_user?
            Order.today.count
          else
            Order.today.where(franchise_id: current_admin_user.franchise_id).count
          end,
          class: "text-[18px] md:text-[24px] font-bold text-slate-900 dark:text-white"
        )
      end

      div class: "w-full p-4 bg-slate-50 dark:bg-slate-800 rounded-lg" do
        h3 "Registered Users", class: "text-slate-600 dark:text-slate-300"
        h2 number_to_currency(
          if current_admin_user.super_user?
            User.count
          else
            User.where("associated_franchises @> ARRAY[?]::integer[]", current_admin_user.franchise_id).count
          end,
          unit: '',
          separator: '.',
          delimiter: ',',
          precision: 0
        ), class: "text-[18px] md:text-[24px] font-bold text-slate-900 dark:text-white"
      end

      div class: "w-full p-4 bg-slate-50 dark:bg-slate-800 rounded-lg" do
        h3 "Today's Revenue", class: "text-slate-600 dark:text-slate-300"
        h2 number_to_currency(
          if current_admin_user.super_user?
            Payment.paid_at_today.reduce(0) { |sum, i| sum + i.total }
          else
            Payment.paid_at_today
                  .joins(:order)
                  .where(orders: { franchise_id: current_admin_user.franchise_id })
                  .reduce(0) { |sum, i| sum + i.total }
          end,
          unit: '₦',
          separator: '.',
          delimiter: ',',
          precision: 2
        ), class: "text-[18px] md:text-[24px] font-bold text-slate-900 dark:text-white"
      end
    end

    # Recent orders table in a div container
    div class: "bg-none rounded-lg shadow-sm p-6 flex flex-col gap-[14px]" do
      h3 "Today's Recent Orders", class: "text-[24px] font-medium text-slate-900 dark:text-white"
      table_for(
        if current_admin_user.super_user?
          Order.today.limit(10)
        else
          Order.today.where(franchise_id: current_admin_user.franchise_id).limit(10)
        end,
        class: "border-[1px] border-slate-200 dark:border-slate-700 rounded w-full"
      ) do
        column :id, class: "text-slate-900 dark:text-white"
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
        column :reference, class: "text-slate-900 dark:text-white"
        column :order_no do |resource|
          span "##{resource.order_no}", class: "text-slate-900 dark:text-white"
        end
        column :franchise, class: "text-slate-900 dark:text-white" if current_admin_user.super_user?
        column :total do |resource|
          span number_to_currency(resource.total, unit: '₦', separator: '.', delimiter: ',', precision: 2),
               class: "text-slate-900 dark:text-white"
        end
        column :updated_at, class: "text-slate-900 dark:text-white"
        column "Actions" do |resource|
          div class: "flex gap-2" do
            link_to "View", admin_orders_path(resource),
                    class: "px-2 py-1 text-sm rounded bg-blue-500 dark:bg-blue-600  hover:bg-blue-600 dark:hover:bg-blue-700"
            link_to "Edit", edit_admin_order_path(resource),
                    class: "px-2 py-1 text-sm rounded bg-green-500 dark:bg-green-600 text-white hover:bg-green-600 dark:hover:bg-green-700"
            link_to "Delete", admin_orders_path(resource),
                    method: :delete,
                    data: { confirm: "Are you sure?" },
                    class: "px-2 py-1 text-sm rounded bg-red-500 dark:bg-red-600 text-white hover:bg-red-600 dark:hover:bg-red-700"
          end
        end
      end
    end
  end
end
