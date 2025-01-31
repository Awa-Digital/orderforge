ActiveAdmin.register AffiliateView do
  # Specify parameters which should be permitted for assignment
  permit_params :ip, :user_agent, :influencer_id

  # or consider:
  #
  # permit_params do
  #   permitted = [:ip, :user_agent, :influencer_id]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end

  # For security, limit the actions that should be available
  actions :all, except: []

  belongs_to :influencer

  # Add or remove filters to toggle their visibility
  filter :id
  filter :ip
  filter :user_agent
  filter :influencer
  filter :created_at
  filter :updated_at

  # Add or remove columns to toggle their visibility in the index action
  index do
    selectable_column
    id_column
    column :ip
    column :user_agent
    column :influencer
    column :created_at
    column :updated_at
    actions
  end

  # Add or remove rows to toggle their visibility in the show action
  show do
    attributes_table_for(resource) do
      row :id
      row :ip
      row :user_agent
      row :influencer
      row :created_at
      row :updated_at
    end
  end

  # Add or remove fields to toggle their visibility in the form
  form do |f|
    f.semantic_errors(*f.object.errors.attribute_names)
    f.inputs do
      f.input :ip
      f.input :user_agent
      f.input :influencer
    end
    f.actions
  end
end
