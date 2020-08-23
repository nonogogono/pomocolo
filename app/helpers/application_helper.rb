module ApplicationHelper
  def full_title(page_title: nil)
    if page_title.blank?
      # config/initializers/constants.rb から参照
      Constants::APP_NAME
    else
      "#{page_title} - #{Constants::APP_NAME}"
    end
  end
end
