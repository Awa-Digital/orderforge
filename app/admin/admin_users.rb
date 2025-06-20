ActiveAdmin.register AdminUser do
  menu if: proc { current_admin_user.super_user? }
  permit_params :email, :password, :password_confirmation, :phone, :first_name, :last_name, :franchise_id, :super_user, :department_id

  controller do
    def update
      if params[:admin_user][:password].blank?
        params[:admin_user].delete("password")
        params[:admin_user].delete("password_confirmation")
      end
      super
    end
  end

  index do
    selectable_column
    id_column
    column :email
    column :franchise
    column :type do |admin_user|
      if admin_user.department.franchise.present?
        "#{admin_user.department.franchise.title} - #{admin_user.department.name}"
      else
        admin_user.department.name
      end
    end
    column :current_sign_in_at
    # column :sign_in_count
    column :created_at
    actions
  end

  filter :email
  filter :franchise
  filter :current_sign_in_at
  filter :sign_in_count
  filter :created_at

  form do |f|
    f.inputs do
      f.input :email
      f.input :phone
      f.input :first_name
      f.input :last_name
      panel 'Authorization' do
        f.input :department_id, as: :select, collection: Department.all.map { |department|
          [department.franchise.present? ? "#{department.franchise.title} - #{department.name}" : department.name, department.id]
        }, include_blank: false, label: "Admin Type", selected: f.object.department_id
      end

      if f.object.new_record?
        f.input :password, required: true
        f.input :password_confirmation, required: true
      else
        f.input :password, required: false, hint: "Leave blank if you don't want to change it"
        f.input :password_confirmation, required: false, hint: "Leave blank if you don't want to change it"
      end
    end
    f.actions
  end
end
