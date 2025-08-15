// discourse-sms-login/assets/javascripts/discourse/controllers/password-reset.js.es6
import Controller from "@ember/controller";
import { action } from "@ember/object";
import { inject as service } from "@ember/service";
import { logToHost } from "../../../lib/log_helper";

export default class PasswordResetController extends Controller {
  @service router;
  phone = "";
  verificationCode = "";
  newPassword = "";
  confirmPassword = "";
  resendDisabled = false;
  resendCount = 60;

  @action
  sendCode() {
    logToHost("Sending reset code", { phone: this.phone });
    // 调用API发送验证码
    this.startResendTimer();
  }

  startResendTimer() {
    this.resendDisabled = true;
    const timer = setInterval(() => {
      this.resendCount--;
      if (this.resendCount <= 0) {
        clearInterval(timer);
        this.resendDisabled = false;
        this.resendCount = 60;
      }
    }, 1000);
  }

  @action
  verifyCode() {
    logToHost("Verifying reset code", { phone: this.phone });
    this.router.transitionTo("reset-password-new");
  }

  @action
  submitNewPassword() {
    logToHost("Password reset submitted", { phone: this.phone });
    this.router.transitionTo("reset-password-success");
  }
}