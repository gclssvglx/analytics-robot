import consumer from "channels/consumer"

consumer.subscriptions.create("FakerChannel", {
  connected() {
    console.log("Connected to FakerChannel")
  },

  disconnected() {
    console.log("Disconnected from FakerChannel")
  },

  received(data) {
    var json = JSON.parse(data)
    var dataDisplay = "<div class='card mb-3 p-2'>"
    dataDisplay += "<div class='card-header text-bg-light p-3>" + json["event"] + "</div>"
    dataDisplay += "<div class='card-body'>"
    dataDisplay += "<details>"
    dataDisplay += "<pre><code>" + JSON.stringify(json, undefined, 4) + "</code></pre>"
    dataDisplay += "</details>"
    dataDisplay += "</div>"
    dataDisplay += "</div>"

    var output = document.getElementById('faker-output')
    output.innerHTML += dataDisplay
  }
});
