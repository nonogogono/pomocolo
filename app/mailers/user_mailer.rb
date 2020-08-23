class UserMailer < Devise::Mailer
  def confirmation_on_create_instructions(record, token, opts = {})
    @token = token
    devise_mail(record, :confirmation_on_create_instructions, opts)
  end
end
