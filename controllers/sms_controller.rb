# discourse-sms-login/controllers/sms_controller.rb
class SmsController < ApplicationController
  include LogHelper
  skip_before_action :check_xhr, only: [:send_code, :verify_code, :register_or_login, :reset_password]
  
  def send_code
    phone = params[:phone]
    return render_json_error("Invalid phone number") unless valid_phone?(phone)
    
    # 检查发送频率
    attempt_key = "sms_attempt:#{phone}"
    attempts = $redis.get(attempt_key).to_i
    if attempts >= SiteSetting.max_resend_attempts
      return render_json_error("Too many attempts, please try later")
    end
    
    code = rand(10**(SiteSetting.verification_code_length-1)..10**SiteSetting.verification_code_length-1).to_s
    $redis.setex("sms_code:#{phone}", SiteSetting.verification_code_ttl, code)
    $redis.incr(attempt_key)
    $redis.expire(attempt_key, 3600) # 1小时限制
    
    # 调用腾讯云短信API
    SmsVerification.send_sms(phone, code)
    
    log_to_host("SMS sent to #{phone}")
    render json: success_json
  rescue => e
    log_to_host("SMS send failed: #{e.message}", level: "ERROR")
    render_json_error(e.message)
  end
  
  def verify_code
    phone = params[:phone]
    code = params[:code]
    
    stored_code = $redis.get("sms_code:#{phone}")
    if stored_code == code
      $redis.setex("sms_verified:#{phone}", 600, "1")
      log_to_host("Code verified for #{phone}")
      render json: success_json
    else
      log_to_host("Code verification failed for #{phone}")
      render json: failed_json.merge(error: "验证码错误")
    end
  end
  
  def register_or_login
    phone = params[:phone]
    return render_json_error("Phone not verified") unless $redis.get("sms_verified:#{phone}")
    
    user = User.find_by(phone: phone)
    if user
      # 登录逻辑
      log_on_user(user)
      log_to_host("User logged in via SMS: #{user.username}")
      render json: success_json
    else
      # 注册逻辑
      email = "#{phone}@sms.discourse"
      username = UserNameSuggester.suggest(phone)
      user = User.new(
        email: email,
        phone: phone,
        username: username,
        password: SecureRandom.hex(16)
      )
      
      if user.save
        log_on_user(user)
        log_to_host("New user registered: #{username}")
        render json: success_json
      else
        log_to_host("Registration failed: #{user.errors.full_messages.join(", ")}", level: "ERROR")
        render json: failed_json.merge(error: user.errors.full_messages.join(", "))
      end
    end
  rescue => e
    log_to_host("Login/Register error: #{e.message}", level: "ERROR")
    render_json_error(e.message)
  end
  
  def reset_password
    # 密码重置逻辑
    # (实现类似register_or_login的完整流程)
  end
  
  private
  
  def valid_phone?(phone)
    phone =~ /\A\d{11}\z/
  end
end