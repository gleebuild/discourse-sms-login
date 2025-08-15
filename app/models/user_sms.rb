# discourse-sms-login/app/models/user_sms.rb
class UserSMS
  def self.add_to_class!
    User.class_eval do
      validate :phone_format
      validates :phone, uniqueness: true, allow_blank: true

      def phone_format
        return if phone.blank?
        errors.add(:phone, :invalid) unless phone =~ /\A\d{11}\z/
      end
    end
  end
end

UserSMS.add_to_class!