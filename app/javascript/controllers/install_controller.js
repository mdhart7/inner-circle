import { Controller } from "@hotwired/stimulus"

// Shows "Add to Home Screen" help that matches the visitor's phone.
// Hidden when already installed (standalone), on desktop, or after dismissal.
export default class extends Controller {
  static targets = ["ios", "android", "button"]

  connect() {
    this.refresh = this.refresh.bind(this)
    window.addEventListener("install-prompt-ready", this.refresh)
    this.refresh()
  }

  disconnect() {
    window.removeEventListener("install-prompt-ready", this.refresh)
  }

  refresh() {
    const standalone =
      window.matchMedia("(display-mode: standalone)").matches || window.navigator.standalone === true
    if (standalone || this.dismissed()) return this.hide()

    const ua = window.navigator.userAgent
    const isIOS = /iPhone|iPad|iPod/.test(ua) ||
      (navigator.platform === "MacIntel" && navigator.maxTouchPoints > 1)
    const isAndroid = /Android/.test(ua)

    if (isIOS) {
      this.show(this.iosTarget)
    } else if (isAndroid) {
      this.show(this.androidTarget)
      this.buttonTarget.hidden = !window.deferredInstallPrompt
    } else {
      this.hide()
    }
  }

  async install() {
    const prompt = window.deferredInstallPrompt
    if (!prompt) return
    prompt.prompt()
    await prompt.userChoice
    window.deferredInstallPrompt = null
    this.refresh()
  }

  dismiss() {
    try { localStorage.setItem("installBannerDismissed", "1") } catch (e) {}
    this.hide()
  }

  dismissed() {
    try { return localStorage.getItem("installBannerDismissed") === "1" } catch (e) { return false }
  }

  show(target) {
    this.element.hidden = false
    this.iosTarget.hidden = target !== this.iosTarget
    this.androidTarget.hidden = target !== this.androidTarget
  }

  hide() {
    this.element.hidden = true
  }
}
