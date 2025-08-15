// discourse-sms-login/assets/javascripts/discourse/components/password-toggle.js.es6
import Component from "@glimmer/component";
import { tracked } from "@glimmer/tracking";
import { action } from "@ember/object";

export default class PasswordToggleComponent extends Component {
  @tracked showPassword = false;

  get inputType() {
    return this.showPassword ? "text" : "password";
  }

  get iconClass() {
    return this.showPassword ? "fa fa-eye-slash" : "fa fa-eye";
  }

  @action
  toggleVisibility() {
    this.showPassword = !this.showPassword;
  }
}