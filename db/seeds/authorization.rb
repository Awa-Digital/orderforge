# Role.destroy_all
# DepartmentRole.destroy_all
# Department.destroy_all

def apply_super_admin_permissions(department)
  roles = Role.where(name: 'manage')
  roles.each do |role|
    DepartmentRole.find_or_create_by!(department: department, role: role)
  end
end

def apply_view_only_permissions(department)
  roles = Role.where(name: 'read')
  roles.each do |role|
    DepartmentRole.find_or_create_by!(department: department, role: role)
  end
end

permissions = %i[manage read create update destroy]

# Create Roles
ApplicationRecord.descendants.map(&:name).each do |name|
  permissions.each do |action|
    Role.find_or_create_by!(
      name: action,
      model: name,
      status: "active"
    )
  end
end

# Create Departments
super_admin_department = Department.find_or_create_by!(name: 'Super Admin') # can manage all so apply all manage permissions
apply_super_admin_permissions(super_admin_department)

Franchise.all.each do |franchise|
  franchise_admin_department = Department.find_or_create_by!(name: 'Franchise Admin', franchise_id: franchise.id) # can manage all so apply all manage permissions but also franchise ID
  apply_super_admin_permissions(franchise_admin_department)

  franchise_viewer = Department.find_or_create_by!(name: 'Franchise Viewer', franchise_id: franchise.id) # can read all so apply all manage permissions but also franchise ID
  apply_view_only_permissions(franchise_viewer)
end
