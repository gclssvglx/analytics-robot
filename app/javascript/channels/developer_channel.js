import consumer from 'channels/consumer'

consumer.subscriptions.create('DeveloperChannel', {
  connected () {
    console.log('Connected to DeveloperChannel')
  },

  disconnected () {
    console.log('Disconnected from DeveloperChannel')
  },

  received (data) {
    const url = document.getElementById('url').value
    const outputElement = document.getElementById('developer-output')

    let events = {
      event_data: [],
      page_view: [],
      search: [],
      other: []
    }

    for (let i = 0; i < data.length; i++) {
      if (data[i].event === 'event_data') {
        events['event_data'].push(data[i])
      } else if (data[i].event === 'page_view') {
        events['page_view'].push(data[i])
      } else if (data[i].event === 'search') {
        events['search_results'].push(data[i])
      } else {
        events['other'].push(data[i])
      }
    }

    outputElement.append(this.createSummary(events, data.length, url))

    var that = this
    Object.keys(events, that).forEach(function (key, index) {
      var keyEvents = events[key]

      outputElement.append(
        that.createDetails(
          that.createEventHeader(key, keyEvents.length),
          that.prettyPrint(keyEvents)
        )
      )
    })

    outputElement.append(
      this.createDetails('RAW DATA', this.prettyPrint(data))
    )
  },

  createDetails (header, body) {
    let details = document.createElement('details')
    details.setAttribute('class', 'govuk-details')
    details.setAttribute('data-module', 'govuk-details')

    details.append(this.createDetailsHeader(header))
    details.append(this.createDetailsBody(body))

    return details
  },

  createDetailsHeader (header) {
    let summary = document.createElement('summary')
    summary.setAttribute('class', 'govuk-details__summary')

    let span = document.createElement('span')
    span.setAttribute('class', 'govuk-details__summary-text')
    span.innerHTML = header

    summary.append(span)

    return summary
  },

  createDetailsBody (body) {
    let div = document.createElement('div')
    div.setAttribute('class', 'govuk-details__text')

    let pre = document.createElement('pre')
    let code = document.createElement('code')
    code.innerHTML = this.prettyPrint(JSON.parse(body))

    pre.append(code)
    div.append(pre)

    return div
  },

  createSummary (events, eventCount, url) {
    let dl = document.createElement('dl')
    dl.setAttribute('class', 'govuk-summary-list')

    dl.append(this.createSummaryRow('URL', url))
    dl.append(this.createSummaryRow('Total events', eventCount))

    Object.keys(events).forEach(function (key) {
      let div = document.createElement('div')
      div.setAttribute('class', 'govuk-summary-list__row')

      let dt = document.createElement('dt')
      dt.setAttribute('class', 'govuk-summary-list__key')
      dt.innerHTML = key

      let dd = document.createElement('dd')
      dd.setAttribute('class', 'govuk-summary-list__value')
      dd.innerHTML = events[key].length

      div.append(dt)
      div.append(dd)
      dl.append(div)
    })

    return dl
  },

  createSummaryRow (key, value) {
    let div = document.createElement('div')
    div.setAttribute('class', 'govuk-summary-list__row')

    let dt = document.createElement('dt')
    dt.setAttribute('class', 'govuk-summary-list__key')
    dt.innerHTML = key

    let dd = document.createElement('dd')
    dd.setAttribute('class', 'govuk-summary-list__value')
    dd.innerHTML = value

    div.append(dt)
    div.append(dd)

    return div
  },

  createEventHeader (eventType, count) {
    return eventType.toUpperCase() + ' events [' + count + ']'
  },

  prettyPrint (events) {
    return JSON.stringify(events, undefined, 2)
  }
})
