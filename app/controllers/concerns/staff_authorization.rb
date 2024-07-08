module StaffAuthorization
  # before_action :authenticate_staff!
  # before_action :authorize_access, only: [:edit, :update, :destroy]
  def authorize_access
    # unless current_staff.has_role_in_department?('ProductsAdmin', @resource.department) || current_staff.has_role_in_department?('ProductsManager', @resource.department)
    #   redirect_to root_path, alert: 'You do not have access to this resource.'
    # end
  end
end
