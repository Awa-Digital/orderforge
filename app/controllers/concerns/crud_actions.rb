# frozen_string_literal: true

# app/controllers/concerns/crud_actions.rb
module CrudActions
  extend ActiveSupport::Concern

  included do
    before_action :set_resource, only: %i[show update destroy]
  end

  def index
    success(data: resource_class)
  end

  def show
    success(data: @resource)
  end

  def create
    @resource = resource_class.new(resource_params)
    @resource.account_id = @current_user.id if @resource.class.column_names.include?('account_id')

    if @resource.save
      success(data: @resource)
    else
      unprocessable(errors: @resource.errors.messages)
    end
  end

  def update
    if @resource.update(resource_params)
      success(data: @resource)
    else
      unprocessable(errors: @resource.errors.messages)
    end
  end

  def destroy
    if @resource.class.column_names.include?('archived')
      @resource.update(archived: true)
    else
      @resource.destroy
    end
    success(message: 'Resource removed successfully')
  end

  private

  def resource_params
    permitted_params
  end

  def set_resource
    @resource = resource_class.find_by(id: params[:id])

    notfound(message: 'Resource not found') unless @resource
  end
end
