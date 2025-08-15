# discourse-sms-login/plugin.rb
# name: discourse-sms-login
# about: SMS login and password reset for Discourse
# version: 0.1
# authors: Gleebuild
# url: https://github.com/gleebuild/discourse-sms-login.git

enabled_site_setting :sms_login_enabled
register_asset 'stylesheets/sms-login.scss'

after_initialize do
  require_relative 'lib/log_helper'
  require_relative 'app/models/user_sms'
  require_relative 'lib/sms_verification'
  require_relative 'controllers/sms_controller'
  
  add_to_serializer(:site, :sms_login_enabled) { SiteSetting.sms_login_enabled }
  
  Discourse::Application.routes.append do
    post '/sms/send_code' => 'sms#send_code'
    post '/sms/verify_code' => 'sms#verify_code'
    post '/sms/register_or_login' => 'sms#register_or_login'
    post '/sms/reset_password' => 'sms#reset_password'
  end

  # 请求日志钩子
  ActionDispatch::Callbacks.before do
    LogHelper.log_to_host("Request: #{request.path}") if request.path.include?("sms")
  end
end