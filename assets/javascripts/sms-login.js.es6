// discourse-sms-login/assets/javascripts/sms-login.js.es6
import { logToHost } from "./lib/log_helper";

// 全局日志函数
export function globalLog(action, data = {}) {
  logToHost(`[Global] ${action}`, data);
}

// 初始化滑动验证
export function initSlider() {
  $(".slider-handle").draggable({
    axis: "x",
    containment: "parent",
    stop: function() {
      if ($(this).position().left > 150) {
        $(this).trigger("verification-passed");
      }
    }
  });
}

// 倒计时定时器
export function startCountdown(seconds, callback) {
  let count = seconds;
  const timer = setInterval(() => {
    count--;
    if (count <= 0) {
      clearInterval(timer);
      callback();
    }
  }, 1000);
  return timer;
}