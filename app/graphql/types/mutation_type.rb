# frozen_string_literal: true

module Types
  class MutationType < Types::BaseObject
    field :destroy_franchise, mutation: Mutations::DestroyFranchise
    field :destroy_franchise_product_price, mutation: Mutations::DestroyFranchiseProductPrice
    field :update_franchise, mutation: Mutations::UpdateFranchise
    field :update_franchise_product_price, mutation: Mutations::UpdateFranchiseProductPrice
    field :create_franchise_product_price, mutation: Mutations::CreateFranchiseProductPrice
    field :create_franchise, mutation: Mutations::CreateFranchise
    # field :destroy_account_verification, mutation: Mutations::DestroyAccountVerification
    # field :update_account_verification, mutation: Mutations::UpdateAccountVerification
    # field :create_account_verification, mutation: Mutations::CreateAccountVerification
    field :destroy_ad, mutation: Mutations::DestroyAd
    field :update_ad, mutation: Mutations::UpdateAd
    field :create_ad, mutation: Mutations::CreateAd
    field :destroy_address, mutation: Mutations::DestroyAddress
    field :update_address, mutation: Mutations::UpdateAddress
    field :create_address, mutation: Mutations::CreateAddress
    # field :destroy_auth, mutation: Mutations::DestroyAuth
    # field :update_auth, mutation: Mutations::UpdateAuth
    # field :create_auth, mutation: Mutations::CreateAuth
    field :destroy_category, mutation: Mutations::DestroyCategory
    field :update_category, mutation: Mutations::UpdateCategory
    field :create_category, mutation: Mutations::CreateCategory
    field :destroy_delivery_area, mutation: Mutations::DestroyDeliveryArea
    field :update_delivery_area, mutation: Mutations::UpdateDeliveryArea
    field :create_delivery_area, mutation: Mutations::CreateDeliveryArea
    field :destroy_influencer, mutation: Mutations::DestroyInfluencer
    field :update_influencer, mutation: Mutations::UpdateInfluencer
    field :create_influencer, mutation: Mutations::CreateInfluencer
    field :destroy_ingredient, mutation: Mutations::DestroyIngredient
    field :update_ingredient, mutation: Mutations::UpdateIngredient
    field :create_ingredient, mutation: Mutations::CreateIngredient
    field :destroy_location, mutation: Mutations::DestroyLocation
    field :update_location, mutation: Mutations::UpdateLocation
    field :create_location, mutation: Mutations::CreateLocation
    field :destroy_order, mutation: Mutations::DestroyOrder
    field :update_order, mutation: Mutations::UpdateOrder
    field :create_order, mutation: Mutations::CreateOrder
    field :destroy_order_address, mutation: Mutations::DestroyOrderAddress
    field :update_order_address, mutation: Mutations::UpdateOrderAddress
    field :create_order_address, mutation: Mutations::CreateOrderAddress
    field :destroy_payment, mutation: Mutations::DestroyPayment
    field :update_payment, mutation: Mutations::UpdatePayment
    field :create_payment, mutation: Mutations::CreatePayment
    field :destroy_product, mutation: Mutations::DestroyProduct
    field :update_product, mutation: Mutations::UpdateProduct
    field :create_product, mutation: Mutations::CreateProduct
    field :destroy_product_ingredient, mutation: Mutations::DestroyProductIngredient
    field :update_product_ingredient, mutation: Mutations::UpdateProductIngredient
    field :create_product_ingredient, mutation: Mutations::CreateProductIngredient
    field :destroy_rating, mutation: Mutations::DestroyRating
    field :update_rating, mutation: Mutations::UpdateRating
    field :create_rating, mutation: Mutations::CreateRating
    field :destroy_region, mutation: Mutations::DestroyRegion
    field :update_region, mutation: Mutations::UpdateRegion
    field :create_region, mutation: Mutations::CreateRegion
    field :destroy_subcategory, mutation: Mutations::DestroySubcategory
    field :update_subcategory, mutation: Mutations::UpdateSubcategory
    field :create_subcategory, mutation: Mutations::CreateSubcategory
    field :destroy_user, mutation: Mutations::DestroyUser
    field :update_user, mutation: Mutations::UpdateUser
    field :create_user, mutation: Mutations::CreateUser
    field :destroy_voucher, mutation: Mutations::DestroyVoucher
    field :update_voucher, mutation: Mutations::UpdateVoucher
    field :create_voucher, mutation: Mutations::CreateVoucher
    field :destroy_admin_user, mutation: Mutations::DestroyAdminUser
    field :update_admin_user, mutation: Mutations::UpdateAdminUser
    field :create_admin_user, mutation: Mutations::CreateAdminUser
  end
end
