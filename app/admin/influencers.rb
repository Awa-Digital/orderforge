ActiveAdmin.register Influencer do
  menu label: "Affiliates"
  menu if: proc { current_admin_user.super_user? }

  permit_params :name,
                :instagram_handle,
                :twitter_handle,
                :email,
                :password,
                :password_confirmation,
                :verified,
                :verification_video_url,
                :verification_document,
                :status

  actions :all, except: []

  scope :verified, default: true
  scope "Pending Verification", :pending
  scope :all

  sidebar 'Influencer Management', only: %i[show edit] do
    ul class: 'flex flex-col gap-4' do
      li link_to '🛒 Orders', admin_influencer_orders_path(resource), class: 'action-item-button'
      li link_to "👀 Page Views (#{resource.generated_views})", admin_influencer_affiliate_views_path(resource), class: 'action-item-button'
    end
  end

  action_item :verify, only: :show do
    unless resource.verified
      link_to 'Approve Affiliate 🚀',
              verify_admin_influencer_path(resource),
              method: :put,
              class: 'action-item-button'
    end
  end

  # Define the custom member action
  member_action :verify, method: :put do
    resource.update!(verified: true)
    InfluencerMailer.with(id: resource.id).approval.deliver
    redirect_to admin_influencer_path(resource), notice: 'Affiliate approved successfully!'
  end

  batch_action :approve, confirm: 'Are you sure??' do |ids|
    failed = 0
    success = 0
    batch_action_collection.find(ids).each do |influencer|
      influencer.update!(verified: true)
      InfluencerMailer.with(id: resource.id).approval.deliver
      success += 1
    rescue StandardError
      failed += 1
    end

    redirect_to collection_path, alert: "#{success} Affiliates were approved, #{failed} Failed."
  end

  filter :id
  filter :name
  filter :instagram_handle
  filter :twitter_handle
  filter :email

  index do
    selectable_column
    id_column
    column :name
    column :email
    column :updated_at
    column :verified
    column :affiliate_type
    column :balance do |resource|
      number_to_currency(resource.balance, unit: '₦', separator: '.', delimiter: ',', precision: 2)
    end
    column "Views", :generated_views
    actions
  end

  show do
    attributes_table_for(resource) do
      row :id
      row :name
      row :instagram_handle
      row :twitter_handle
      row :email
      row :created_at
      row :updated_at
      row :status
      row :phone_number
      row :tiktok_handle
      row :facebook_page_handle
      row :followers_count
      row :verified
      row :verification_video_url do |resource|
        if resource.verification_video_url.present?
          link_to 'View Video', resource.verification_video_url, target: '_blank'
        else
          'No video uploaded'
        end
      end
      row :verification_video_link
      row :verification_type
      row :affiliate_type
      row :business_name
      row :verification_document do |resource|
        image_tag(resource.verification_document.url) if resource.verification_document.present?
      end
      row :affiliate_link do |resource|
        link_to "Open Link", "https://jazzysburger.com?ref=#{resource.slug}"
      end
    end

    panel "Transactions" do
      table_for resource.transactions do
        column :reference
        column :transaction_type do |resource|
          status_tag resource.transaction_type, class: resource.transaction_type == 'credit' ? 'bg-green-500 text-white' : 'bg-red-500 text-white'
        end
        column :order_amount do |resource|
          order = Order.find_by(reference: resource.reference.split('-')[0])
          number_to_currency(order.total, unit: '₦', separator: '.', delimiter: ',', precision: 2) if order.present?
        end
        column :amount do |resource|
          number_to_currency(resource.amount, unit: '₦', separator: '.', delimiter: ',', precision: 2)
        end
        column :created_at
      end
    end
  end

  # Add or remove fields to toggle their visibility in the form
  form do |f|
    f.semantic_errors(*f.object.errors.attribute_names)
    f.inputs do
      f.input :name
      f.input :affiliate_type, as: :select, collection: %w[influencer business], include_blank: false
      f.input :business_name
      f.input :instagram_handle
      f.input :twitter_handle
      f.input :email
      f.input :verified
      f.input :password
      f.input :password_confirmation
      f.input :status, as: :select, collection: %w[active deactivated], include_blank: false
    end
    f.actions
  end
end
