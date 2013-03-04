class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :set_locale

  layout :layout_authenticated_or_not


  def set_locale
    I18n.locale = 'es'
  end

  def validate_preferences
  	if current_user.preference.nil?
  		redirect_to preferences_path
  	end
  end

  def layout_authenticated_or_not
   return user_signed_in? ? 'is_authenticated' : 'not_authenticated'
  end

end
