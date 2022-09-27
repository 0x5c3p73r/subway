import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  copy(event) {
    event.preventDefault()

    const value = event.target.value
    event.target.setSelectionRange(0, value.length)
    navigator.clipboard.writeText(value)
  }
}
