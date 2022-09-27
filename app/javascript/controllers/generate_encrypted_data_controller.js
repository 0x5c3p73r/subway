import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["masterKey", "encrypedData", "rawData"]

  generate(event) {
    event.target.setAttribute("disabled", "false")

    fetch("/tools/encrypted_data", {
      method: "POST"
    }).then((response) => response.json())
      .then((json) => {
        const masterKey = json.master_key
        const encrypedData = json.encrypted_data
        const contents = json.contents

        this.masterKeyTarget.value = masterKey
        this.encrypedDataTarget.value = encrypedData
        this.rawDataTarget.value = JSON.stringify(contents)

        event.target.removeAttribute("disabled")
    });
  }
}
