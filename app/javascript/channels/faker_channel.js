import consumer from 'channels/consumer'

consumer.subscriptions.create('FakerChannel', {
  connected () {
    console.log('Connected to FakerChannel')
  },

  disconnected () {
    console.log('Disconnected from FakerChannel')
  },

  received (data) {
    const json = JSON.parse(data)

    let dataDisplay = '<details class="govuk-details" data-module="govuk-details">'
    dataDisplay += '<summary class="govuk-details__summary">'
    dataDisplay += '<span class="govuk-details__summary-text">'
    if (json.event === 'event_data') {
      dataDisplay += json.event_data.type + ' | ' + json.event_data.text
    } else if (json.event === 'page_view') {
      dataDisplay += json.event + ' | ' + json.page_view.title
    }
    dataDisplay += '</span>'
    dataDisplay += '</summary>'
    dataDisplay += '<div class="govuk-details__text">'
    dataDisplay += '<pre><code>' + JSON.stringify(json, undefined, 4) + '</code></pre>'
    dataDisplay += '</div>'
    dataDisplay += '</details>'

    const output = document.getElementById('faker-output')
    output.innerHTML += dataDisplay
  }
})
