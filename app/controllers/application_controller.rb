class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?

  def after_sign_in_path_for(resource)
    user_path(resource)
  end

  def after_sign_out_path_for(resource)
    root_path
  end

  def check_guest
    email = resource&.email || params[:user][:email].downcase
    if email == 'guest@example.com'
      redirect_to root_path, alert: 'ゲストユーザーの変更・削除はできません'
    end
  end

  def home_tab_contents
    @feed_items = current_user.feed.recent.page(params[:page]).per(Constants::FEED_NUM)
    @search_user = User.ransack(params[:q])
    @users = @search_user.result(distinct: true).page(params[:page]).per(Constants::SEARCH_USER_NUM) if params[:q].present?
    @search_micropost = Micropost.ransack(params[:p], search_key: :p)
    @microposts = @search_micropost.result(distinct: true).recent.page(params[:page]).per(Constants::SEARCH_MICROPOST_NUM) if params[:p].present?
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
    devise_parameter_sanitizer.permit(:account_update, keys: [:name, :profile])
  end
end
