import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  sync(event) {
    const value = event.target.value
    const targetId = event.target.getAttribute("data-sync-target")
    const targetNode = document.getElementById(targetId)
    targetNode.value = value
  }
}
