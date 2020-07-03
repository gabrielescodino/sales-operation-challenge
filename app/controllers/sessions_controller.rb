# frozen_string_literal: true
class SessionsController < ApplicationController
  def new
    redirect_to after_login_path if user_signed_in?
  end

  def create
    auth = request.env['omniauth.auth']
    user = User.find_or_create_with_omniauth(auth)

    if user.persisted?
      session[:user_id] = user.id
      redirect_to after_login_path
    else
      failure
    end
  end

  def failure
    redirect_to root_path, alert: 'System was not able to authenticate.'
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_path, notice: 'You have left us. Fell free to come back.'
  end

  private

  def after_login_path
    sales_reports_path
  end
end
