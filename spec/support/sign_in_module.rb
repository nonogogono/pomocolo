# system spec でログイン
module SignInModule
  def sign_in_as(user)
    visit new_user_session_path
    fill_in "Name", with: user.name
    fill_in "Email", with: user.email
    fill_in "Password", with: user.password
    click_button "Log in"
  end
end
