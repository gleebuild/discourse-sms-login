// discourse-sms-login/assets/javascripts/discourse/initializers/sms-login.js.es6
import { withPluginApi } from "discourse/lib/plugin-api";

export default {
  name: "sms-login",
  initialize(container) {
    const siteSettings = container.lookup("site-settings:main");
    if (siteSettings.sms_login_enabled) {
      withPluginApi("0.8.31", (api) => {
        api.addRoutes([
          { path: "/login/sms", component: "sms-login" },
          { path: "/login/sms/verify", component: "sms-verify" },
          { path: "/login/password", component: "password-login" },
          { path: "/reset-password", component: "reset-password" },
          { path: "/reset-password/verify", component: "reset-password-verify" },
          { path: "/reset-password/new", component: "reset-password-new" },
          { path: "/reset-password/success", component: "reset-password-success" },
        ]);
      });
    }
  },
};