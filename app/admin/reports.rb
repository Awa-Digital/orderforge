ActiveAdmin.register Report do
  # Specify parameters which should be permitted for assignment
  permit_params :admin_user_id, :file_name, :csv_url, :filters, :creator_id, :updater_id

  # or consider:
  #
  # permit_params do
  #   permitted = [:admin_user_id, :file_name, :csv_url, :filters, :creator_id, :updater_id]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end

  # For security, limit the actions that should be available
  actions :all, except: []

  # Add or remove filters to toggle their visibility
  filter :id
  filter :admin_user
  filter :file_name
  filter :csv_url
  # filter :filters
  filter :created_at
  # filter :updated_at
  # filter :creator
  # filter :updater

  # Add or remove columns to toggle their visibility in the index action
  index do
    selectable_column
    id_column
    column :admin_user do |resource|
      link_to resource.admin_user.first_name, admin_admin_user_path(resource.admin_user)
    end
    column :file_name
    # column :filters
    column :created_at
    # column :updated_at
    # column :creator
    # column :updater
    column "Download", :csv_url do |resource|
      link_to "Download", resource.csv_url, target: :_blank
    end
    actions
  end

  # Add or remove rows to toggle their visibility in the show action
  show do
    attributes_table_for(resource) do
      row :id
      row :admin_user
      row :file_name
      row :csv_url do |resource|
        link_to "Download", resource.csv_url, target: :_blank
      end
      row :filters do |resource|
        div class: "flex flex-col gap-2" do
          resource.filters.map do |key, value|
            next if value == ""

            div class: "flex items-center gap-2" do
              label_tag class: "text-sm capitalize" do
                "#{key.split('_').map do |word|
                  word.sub('gteq', 'after').sub('lteq', 'before').capitalize
                end.join(' ')}: #{value}"
              end
            end
          end
        end
      end
      row :created_at
      row :updated_at
      # row :creator
      # row :updater
    end
  end

  # Add or remove fields to toggle their visibility in the form
  form do |f|
    f.semantic_errors(*f.object.errors.attribute_names)
    f.inputs do
      f.input :admin_user
      f.input :file_name
      f.input :csv_url
      f.input :filters
      f.input :creator
      f.input :updater
    end
    f.actions
  end
end
