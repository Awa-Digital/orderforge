class UserMailer < ApplicationMailer
  before_action :noreply_email

  layout 'receipt_template'
  def reset
    @user = User.find(params[:id])
    @preheader = "#{@user.first_name} you have requested to reset your password"

    mail(to: @user.email, subject: 'Password Reset Request', delivery_method_options: @delivery_options)
  end

  def welcome
    @user = User.find(params[:id])
    @preheader = "Please verify your email address to get access to order receipts, offers and exclusive burger deals."

    mail(to: @user.email, subject: 'Welcome to Jazzy Burger', delivery_method_options: @delivery_options)
  end
end
