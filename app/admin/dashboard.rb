ActiveAdmin.register_page "Dashboard" do
  menu priority: 1, label: proc { I18n.t("active_admin.dashboard") }

  content title: proc { I18n.t("active_admin.dashboard") } do
    # Metrics panels using divs for layout
    div class: "flex justify-between mb-8 gap-[2px]" do
      div class: "w-full p-4 bg-gray-50" do
        h3 "Today's Orders"
        h1(Order.today.count, class: "text-[18px] md:text-[24px] font-bold")
      end

      div class: "w-full p-4 bg-gray-50" do
        h3 "Registered Users"
        h2 number_to_currency(User.count,
                              unit: '',
                              separator: '.',
                              delimiter: ',',
                              precision: 0), class: "text-[18px] md:text-[24px] font-bold"
      end

      div class: "w-full p-4 bg-gray-50" do
        h3 "Today's Revenue"
        h2 number_to_currency(Payment.paid_at_today
                                .reduce(0) { |sum, i| sum + i.total },
                              unit: '₦',
                              separator: '.',
                              delimiter: ',',
                              precision: 2),
           class: "text-[18px] md:text-[24px] font-bold"
      end
    end

    # Recent orders table in a div container
    div class: "bg-white flex flex-col gap-[14px]" do
      h3 "Today's Recent Orders", class: "text-[24px] font-medium"
      table_for Order.today.limit(10), class: "border-[1px] border-border rounded" do
        column :id
        column :status do |resource|
          status_tag resource.status, class: case resource.status
                                             when 'initiated' then 'bg-gray-400 text-white'
                                             when 'paid' then 'bg-blue-500 text-white'
                                             when 'awaiting_processing' then 'bg-yellow-500 text-black'
                                             when 'processing' then 'bg-orange-500 text-white'
                                             when 'awaiting_packaging' then 'bg-teal-500 text-white'
                                             when 'packaged' then 'bg-purple-500 text-white'
                                             when 'delivering' then 'bg-indigo-500 text-white'
                                             when 'completed' then 'bg-green-500 text-white'
                                             else 'bg-gray-300 text-black' # Default
                                             end
        end
        column :reference
        column :order_no do |resource|
          "##{resource.order_no}"
        end
        column :franchise
        column :total do |resource|
          number_to_currency(resource.total, unit: '₦', separator: '.', delimiter: ',', precision: 2)
        end
        column :updated_at
        column "Actions" do |resource|
          links = []
          links << link_to(
            "View",
            admin_orders_path(resource)
          )
          links << link_to(
            "Edit",
            edit_admin_order_path(resource)
          )
          links << link_to(
            "Delete",
            admin_orders_path(resource), method: :delete, data: { confirm: "Are you sure?" }
          )
          safe_join(links, " | ")
        end
      end
    end
  end
end
