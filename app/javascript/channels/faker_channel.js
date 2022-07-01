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
    var dataDisplay = "<details>"
    dataDisplay += "<summary>" + json["event"] + "</summary>"
    dataDisplay += "<pre><code>" + JSON.stringify(json, undefined, 4) + "</code></pre>"
    dataDisplay += "</details>"

    var output = document.getElementById('faker-output')
    output.innerHTML += dataDisplay
  }
});
