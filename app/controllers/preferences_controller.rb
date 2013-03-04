class PreferencesController < ApplicationController
  before_filter :authenticate_user!

  def index

    @preference = current_user.preference

    if @preference.nil?
      @preference = Preference.new
      flash[:error] = t('preferences.msg_required')
    end
  end

  def save

    Preference.transaction do 

      @preference = current_user.preference

      if @preference.nil?
        @preference = Preference.new
      end

      @preference.update_attributes(params[:preference])

      if @preference.save
        current_user.preference = @preference
        redirect_to preferences_path(@preference), :notice => 'Su operación se ha ejecutado con éxito'
      else
        flash[:error] = 'Se han producido los siguientes errores:'
        render :index
      end
    end
  end

end
