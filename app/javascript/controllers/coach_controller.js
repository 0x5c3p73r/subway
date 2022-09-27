import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["coachId", "ticket"]

  submit(event) {
    event.target.setAttribute("disabled", "false")

    const coachId = this.coachIdTarget.value
    const ticket = this.ticketTarget.value

    var redirectUrl = window.location.origin
    const segments = window.location.pathname.split("/")
    if (segments.length > 3) {
      redirectUrl += "/" + segments[1] + "/" + segments[2]
    } else {
      redirectUrl += "/" + segments[1]
    }
    redirectUrl += "/" + coachId + "?ticket=" + ticket

    console.log("id, ticket", coachId, ticket, redirectUrl)
    window.location.href = redirectUrl

    event.target.removeAttribute("disabled")
  }
}
