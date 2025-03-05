ActiveAdmin.register Region do
  # Specify parameters which should be permitted for assignment
  permit_params :location_id, :name, :status

  menu parent: "Available Locations", label: "Operating States", if: proc { current_admin_user.super_user? }

  # or consider:
  #
  # permit_params do
  #   permitted = [:location_id, :name, :status]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end

  # For security, limit the actions that should be available
  actions :all, except: []

  # Add or remove filters to toggle their visibility
  filter :id
  filter :name
  filter :status

  # Add or remove columns to toggle their visibility in the index action
  index do
    selectable_column
    id_column
    column :name
    column :location
    column :status
    actions
  end

  # Add or remove rows to toggle their visibility in the show action
  show do
    attributes_table_for(resource) do
      row :id
      row :location
      row :created_at
      row :updated_at
      row :name
      row :status
    end

    panel "Delivery Areas" do
      table_for region.delivery_areas do
        column :name
        column :day_rate
        column :dusk_rate
        column :night_rate
        column :dawn_rate
        column :status
        column "Actions" do |resource|
          links = []
          links << link_to(
            "View",
            admin_region_delivery_area_path(
              region_id: resource.region.id,
              id: resource.id
            )
          )
          links << link_to(
            "Edit",
            edit_admin_region_delivery_area_path(
              region_id: resource.region.id,
              id: resource.id
            )
          )
          links << link_to(
            "Delete",
            admin_region_delivery_area_path(
              region_id: resource.region.id,
              id: resource.id
            ), method: :delete, data: { confirm: "Are you sure?" }
          )
          safe_join(links, " | ")
        end
      end
    end
  end

  # Add or remove fields to toggle their visibility in the form
  form do |f|
    f.semantic_errors(*f.object.errors.attribute_names)
    f.inputs do
      f.input :location
      f.input :name
      f.input :status
    end
    f.actions
  end
end
