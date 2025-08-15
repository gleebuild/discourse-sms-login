# discourse-sms-login/lib/sms_verification.rb
require 'tencentcloud-sdk-common'
require 'tencentcloud-sdk-sms'

module SmsVerification
  include LogHelper
  
  def self.send_sms(phone, code)
    return if Rails.env.test?
    
    cred = TencentCloud::Common::Credential.new(
      SiteSetting.tencent_secret_id,
      SiteSetting.tencent_secret_key
    )
    
    client = TencentCloud::Sms::V20210111::Client.new(cred, "ap-guangzhou")
    
    req = TencentCloud::Sms::V20210111::SendSmsRequest.new
    req.phone_number_set = ["+86#{phone}"]
    req.sms_sdk_app_id = "1400000000" # 替换为实际AppID
    req.sign_name = SiteSetting.sms_sign_name
    req.template_id = SiteSetting.sms_template_id
    req.template_param_set = [code]
    
    begin
      resp = client.SendSms(req)
      log_to_host("Tencent SMS response: #{resp.to_json}")
    rescue TencentCloud::Common::TencentCloudSDKException => e
      log_to_host("Tencent SMS error: #{e.message}", level: "ERROR")
      raise e
    end
  end
end