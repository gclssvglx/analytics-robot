import consumer from "channels/consumer"

consumer.subscriptions.create("FakerChannel", {
  connected() {
    console.log("Connected to FakerChannel")
  },

  disconnected() {
    console.log("Disconnected from FakerChannel")
  },

  received(data) {
    console.log(data)
    var output = document.getElementById('faker-output')
    output.innerHTML += "<p>" + data + "</p>"
  }
});
