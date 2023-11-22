import consumer from 'channels/consumer'

consumer.subscriptions.create('DeveloperChannel', {
  connected () {
    console.log('Connected to DeveloperChannel')
  },

  disconnected () {
    console.log('Disconnected from DeveloperChannel')
  },

  received (data) {
    console.log(data) // Output the dataLayer JSONs to the console for developer benefit
    const url = document.getElementById('url').value
    const outputElement = document.getElementById('developer-output')

    const events = {
      event_data: [],
      page_view: [],
      search: [],
      other: []
    }

    for (let i = 0; i < data.length; i++) {
      if (data[i].event === 'event_data') {
        events.event_data.push(data[i])
      } else if (data[i].event === 'page_view') {
        events.page_view.push(data[i])
      } else if (data[i].event === 'search_results') {
        events.search.push(data[i])
      } else {
        events.other.push(data[i])
      }
    }

    outputElement.append(this.createSummary(events, data.length, url))

    const that = this
    Object.keys(events, that).forEach(function (key, index) {
      const keyEvents = events[key]

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
    const details = document.createElement('details')
    details.setAttribute('class', 'govuk-details')
    details.setAttribute('data-module', 'govuk-details')

    details.append(this.createDetailsHeader(header))
    details.append(this.createDetailsBody(body))

    return details
  },

  createDetailsHeader (header) {
    const summary = document.createElement('summary')
    summary.setAttribute('class', 'govuk-details__summary')

    const span = document.createElement('span')
    span.setAttribute('class', 'govuk-details__summary-text')
    span.innerHTML = header

    summary.append(span)

    return summary
  },

  createDetailsBody (body) {
    const div = document.createElement('div')
    div.setAttribute('class', 'govuk-details__text')

    const pre = document.createElement('pre')
    const code = document.createElement('code')
    const dataLayerEvents = JSON.parse(body)
    for(var i = 0; i < dataLayerEvents.length; i++) {

      var dataLayerEvent = dataLayerEvents[i]
      var summary = 'Event'
      if(dataLayerEvent.event_data) {
        summary = dataLayerEvent.event_data.event_name + ' - ' + dataLayerEvent.event_data.type + ' - ' + dataLayerEvent.event_data.text
      }
      else if (dataLayerEvent.page_view) {
        summary = 'Pageview'
      }
      else if (dataLayerEvent.search_results) {
        summary = 'Search Results'
      }

      code.innerHTML += '<details><summary>' + summary + '</summary>' + this.prettyPrint(dataLayerEvents[i])  + '</details>'
    }

    pre.append(code)
    div.append(pre)

    return div
  },

  createSummary (events, eventCount, url) {
    const dl = document.createElement('dl')
    dl.setAttribute('class', 'govuk-summary-list')

    dl.append(this.createSummaryRow('URL', url))
    dl.append(this.createSummaryRow('Total events', eventCount))

    Object.keys(events).forEach(function (key) {
      const div = document.createElement('div')
      div.setAttribute('class', 'govuk-summary-list__row')

      const dt = document.createElement('dt')
      dt.setAttribute('class', 'govuk-summary-list__key')
      dt.innerHTML = key

      const dd = document.createElement('dd')
      dd.setAttribute('class', 'govuk-summary-list__value')
      dd.innerHTML = events[key].length

      div.append(dt)
      div.append(dd)
      dl.append(div)
    })

    return dl
  },

  createSummaryRow (key, value) {
    const div = document.createElement('div')
    div.setAttribute('class', 'govuk-summary-list__row')

    const dt = document.createElement('dt')
    dt.setAttribute('class', 'govuk-summary-list__key')
    dt.innerHTML = key

    const dd = document.createElement('dd')
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
