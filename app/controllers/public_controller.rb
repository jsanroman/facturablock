class PublicController < ApplicationController

  def index
    if user_signed_in?
      redirect_to invoices_path
    end
  end

end
