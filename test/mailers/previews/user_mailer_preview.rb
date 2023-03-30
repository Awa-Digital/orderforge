# Preview all emails at http://localhost:3000/rails/mailers/user_mailer
class UserMailerPreview < ActionMailer::Preview
  def reset
    # Set up a temporary order for the preview
    user = User.first

    UserMailer.with(id: user.id).reset
  end

  def welcome
    # Set up a temporary order for the preview
    user = User.first

    UserMailer.with(id: user.id).welcome
  end
end
