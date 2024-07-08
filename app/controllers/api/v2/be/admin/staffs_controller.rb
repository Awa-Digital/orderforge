# frozen_string_literal: true

# for Backend Authorization
module Api
  module V2
    module Be
      module Admin
        class StaffsController < Api::V2::Be::Admin::BaseController
          before_action :set_franchise
          before_action :set_staff, except: [:new]

          def new
            @staff = @franchise.staffs.new(staff_params)
            if @staff.save
              success({ data: @staff })
            else
              unprocessable({ errors: @staff.errors })
            end
          end

          def update
            if @staff.update(staff_params)
              success({ data: @staff })
            else
              unprocessable({ errors: @staff.errors })
            end
          end

          def remove
            @staff.archive!
            success({ data: @staff })
          end

          def remove_from_department
            @department = @staff.staff_departments.find_by(department_id: params[:department_id])
            if @department
              @department.archive!
              success({ data: @staff })
            else
              notfound({ resource: "department" })
            end
          end

          private

          def staff_params
            params.require(:staff).permit(:first_name, :last_name, :phone, :email, :password, :password_confirmation, staff_departments_attributes: [:department_id])
          end

          def set_franchise
            @franchise = ::Franchise.find_by(id: params[:id])
            notfound({ resource: "franchise" }) if @franchise.nil?
          end

          def set_staff
            @staff = @franchise.staffs.find_by(id: params[:staff_id])
            notfound({ resource: "staff" }) if @staff.nil?
          end
        end
      end
    end
  end
end
