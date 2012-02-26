class ApplicationController < ActionController::Base
  protect_from_forgery
  after_filter :set_content_type

  protected

  def set_content_type
    headers['Content-Type'] ||= 'text/html; charset=utf-8'
  end

  def enki_config
    @@enki_config = Rails.application.config.enki_config_file
  end
  helper_method :enki_config
end
