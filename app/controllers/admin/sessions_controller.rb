require "digest"
class Admin::SessionsController < ApplicationController
  layout 'login'

  def show
      redirect_to :action => 'new'
  end

  def new
  end

  def create
    if params[:login].blank? or params[:password].blank?
      flash.now[:error] = "You must provide login and password!"
      render :action => 'new'
    else
      if authenticate_with_passw(params[:login],params[:password])
        return successful_login
      else
        flash.now[:error] = "Wrong login or password"
        render :action => 'new'
      end
    end
=begin
    return successful_login if allow_login_bypass? && params[:bypass_login]

    if params[:openid_url].blank? && !request.env[Rack::OpenID::RESPONSE]
      flash.now[:error] = "You must provide an OpenID URL"
      render :action => 'new'
    else
      authenticate_with_open_id(params[:openid_url]) do |result, identity_url|
        if result.successful?
          if enki_config.author_open_ids.include?(URI.parse(identity_url))
            return successful_login
          else
            flash.now[:error] = "You are not authorized"
          end
        else
          flash.now[:error] = result.message
        end
        render :action => 'new'
      end
    end
=end
  end

  def destroy
    session[:logged_in] = false
    redirect_to('/')
  end

protected

  def successful_login
    session[:logged_in] = true
    redirect_to(admin_root_path)
  end
  def authenticate_with_passw(login,passw)
    encrypted_passw = Digest::MD5.hexdigest(passw)
    (login.casecmp(enki_config[:author][:login]) == 0) && encrypted_passw.eql?(enki_config[:author][:passw])
  end

  def allow_login_bypass?
    %w(development test).include?(Rails.env)
  end
  helper_method :allow_login_bypass?
end
