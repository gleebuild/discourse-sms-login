// discourse-sms-login/assets/javascripts/discourse/controllers/sms-login.js.es6
import Controller from "@ember/controller";
import { action } from "@ember/object";
import { inject as service } from "@ember/service";
import { logToHost } from "../../../lib/log_helper";

export default class SmsLoginController extends Controller {
  @service router;
  
  phone = "";
  slideVerified = false;

  @action
  showPasswordLogin() {
    logToHost("Switched to password login");
    this.router.transitionTo("password-login");
  }

  @action
  slideVerify() {
    this.slideVerified = true;
    logToHost("Slider verification passed", { phone: this.phone });
  }

  @action
  nextStep() {
    logToHost("SMS login next step", { phone: this.phone });
    this.router.transitionTo("sms-verify", { queryParams: { phone: this.phone } });
  }

  @action
  showRegister() {
    logToHost("User clicked register");
    this.router.transitionTo("sms-login");
  }
}