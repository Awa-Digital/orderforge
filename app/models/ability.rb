# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(admin_user)
    return unless admin_user.present?

    can :read, :all

    if admin_user.franchise.present?
      franchise_super_admin_abilities(admin_user)
    else
      admin_user_abilities(admin_user)
    end

    # can :read, ActiveAdmin::Page, name: "AdminUsers"
  end

  # def franchise_super_admin_abilities(admin_user)
  #   can :manage, Order, franchise_id: admin_user.franchise_id
  #   can :manage, DeliveryArea, franchises: { id: admin_user.franchise_id }
  #   can :manage, Region, franchises: { id: admin_user.franchise_id }
  #   can :manage, Franchise, id: admin_user.franchise_id
  #   can :manage, FranchiseAddress, franchise_id: admin_user.franchise_id
  #   can :manage, FranchiseInventoryQuantity, franchise_id: admin_user.franchise_id
  #   can :manage, FranchiseProductPrice, franchise_id: admin_user.franchise_id
  #   can :manage, FranchiseStockQuantity, franchise_id: admin_user.franchise_id
  #   can :manage, OrderAddress, delivery_area: { franchises: { id: admin_user.franchise_id } }
  # end

  def franchise_super_admin_abilities(admin_user)
    admin_user.department.abilities.each do |ability_hash|
      ability_hash.each do |model_name, action|
        model_klass = model_name.constantize

        # Apply scoping where the model has franchise_id
        if model_klass.column_names.include?("franchise_id")
          can action.to_sym, model_klass, franchise_id: admin_user.franchise_id

        # Example special case: nested association
        elsif model_name == "OrderAddress"
          can action.to_sym, model_klass, delivery_area: { franchises: { id: admin_user.franchise_id } }

        elsif %w[DeliveryArea Region].include?(model_name)
          can action.to_sym, model_klass, franchises: { id: admin_user.franchise_id }

        else
          # Fallback: grant unscoped access (or skip if you prefer strict)
          can action.to_sym, model_klass
        end
      rescue NameError
        Rails.logger.warn "Unknown model: #{model_name}"
      end
    end
  end

  def admin_user_abilities(admin_user)
    # Super Admins get full control over popup notifications
    can :manage, PopupNotification if admin_user.super_user?

    admin_user.department.abilities.each do |ability_hash|
      ability_hash.each do |model_name, action|
        model_klass = model_name.constantize
        can action.to_sym, model_klass
      rescue NameError
        Rails.logger.warn "Unknown model: #{model_name}"
      end
    end
  end
end
