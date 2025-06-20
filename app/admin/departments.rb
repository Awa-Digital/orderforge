ActiveAdmin.register Department do
  # Specify parameters which should be permitted for assignment
  permit_params :name, :status, :franchise_id

  # or consider:
  #
  # permit_params do
  #   permitted = [:name, :status, :franchise_id]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end

  # For security, limit the actions that should be available
  actions :all, except: []

  # Add or remove filters to toggle their visibility
  filter :id
  filter :name
  filter :created_at
  filter :updated_at
  filter :status
  filter :franchise

  # Add or remove columns to toggle their visibility in the index action
  index do
    selectable_column
    id_column
    column :name do |department|
      department.franchise.present? ? "#{department.franchise.title} - #{department.name}" : department.name
    end
    column :created_at
    column :updated_at
    column :status
    column :franchise
    actions
  end

  # Add or remove rows to toggle their visibility in the show action
  show do
    attributes_table_for(resource) do
      row :id
      row :name
      row :created_at
      row :updated_at
      row :status
      row :franchise
    end

    panel "Abilities" do
      div class: "overflow-x-auto" do
        resource.roles.each do |role|
          div class: "flex items-center gap-2" do
            check_box_tag "roles", role.id, resource.roles.include?(role), class: "disabled:opacity-50 disabled:cursor-not-allowed", disabled: true, checked: true
            label_tag class: "text-sm capitalize" do
              "#{role.name}: #{role.model.titleize}"
            end
          end
        end
      end
    end
  end

  # Add or remove fields to toggle their visibility in the form
  form do |f|
    f.semantic_errors(*f.object.errors.attribute_names)
    f.inputs do
      f.input :name
      f.input :status
      f.input :franchise
    end
    f.actions
  end
end
