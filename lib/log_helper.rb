# discourse-sms-login/lib/log_helper.rb
module LogHelper
  PLUGIN_LOG_PATH = "/var/discourse/shared/standalone/log/plugin_operations.log"

  def log_to_host(message, level: "INFO")
    log_entry = "[#{Time.now.utc}] [#{Process.pid}] #{level}: #{message}\n"
    File.open(PLUGIN_LOG_PATH, "a") { |f| f.write(log_entry) }
    true
  rescue => e
    Rails.logger.error "Failed to write plugin log: #{e.message}"
    false
  end
end