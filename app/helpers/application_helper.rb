module ApplicationHelper
  def full_title(page_title: nil)
    if page_title.blank?
      # config/initializers/constants.rb から参照
      Constants::BASE_TITLE
    else
      "#{page_title} - #{Constants::BASE_TITLE}"
    end
  end
end
