![logotype](https://repository-images.githubusercontent.com/504593718/08cf2ea6-cf81-42aa-8bfc-dd3d9c7fd16f)

A tool for developers and performance analysts that are working on replacing Google Universal Analaytics (UA) with Google Analytics 4 (GA4) on [GOV.UK](https://www.gov.uk).

It is designed to do the following:

* Generate realistic GA4 events. This works by simply navigating to a list of known pages with specific components on, and interacting with the elements and components (tags, accordions, links etc) in the same way a real user might.

* Test that the resulting events contain the data expected. This ensures that the events generated haven't been changed or altered.

* Assist developers when adding or testing event interactions. Essentially, a developer can supply any URL (including localhost), the tool will then find all GA4 elements on the page and click them all. A suitable report will then be produced.

## Architecture

The tool is a standard [Ruby on Rails](https://rubyonrails.org/) project - and does not require a database.

## Development

### Installing dependencies

```bash
bundle install
bundle exec npm install
bundle exec yarn install
```


## Ensure your chromedriver is installed/up to date/has executable permission
- Update to the latest version of Google Chrome.
- Note your version of Google Chrome by clicking the Menu in the top right of Chrome, then clicking Help > About Chrome
- Download the version of `chromedriver` relevant to your version of Google Chrome from https://googlechromelabs.github.io/chrome-for-testing/ - you'll want the `mac-arm64` version if you're on an M1 Mac. **Make sure you have downloaded `chromedriver` and not `chrome` ! (see screenshot)**

![chromedriver](https://github.com/AshGDS/analytics-robot/assets/8880610/ab28421b-9ad1-499d-aefd-146b742bfc96)

- Copy the relevant chromedriver URL from the table, and open it in a new tab so that the download process begins.
- Once download, extract the `.zip` file by double clicking it.
- Move the `chromedriver` file to `/usr/local/bin`. You can do this by doing `cp /Users/[YOUR.NAME]/Downloads/chrome-mac-arm64/chromedriver /usr/local/bin/chromedriver`
- Change directory to `/usr/local/bin` in your terminal
- Run `chmod +x chromedriver` to make chromedriver executable
- Run `sudo xattr -r -d com.apple.quarantine chromedriver` to remove Apple's security quarantine from the file
- Restart your terminal, and to test chromedriver is working, run `chromedriver -v`

### Running the application

For development...

```bash
rails s
```

** NOTE: connect to the VPN if you are testing integration/staging environments, otherwise the tests for these pages will not work!**

Should now be running at [http://localhost:3000](http://localhost:3000/)


### Testing

```bash
bundle exec rake
```

## Faking events

You can either use the UI available at [http://localhost:3000](http://localhost:3000/) or the [`check_events` rake task](lib/tasks/check_events.rake) to fake events.

The general format to run the task is...

```bash
bundle exec rake check_events[fake,<ENVIRONMENT>,<ELEMENTS>,<ITERATIONS>]
```

Form example:

```bash
bundle exec rake check_events[fake,integration,accordions,2]
```

Output is logged to a date/time named file in the [log](log/) directory.

## Testing events

You can also use the [`check_events` rake task](lib/tasks/check_events.rake) that tests events and validates that the data and data structure hasn't changed.

The general format to run the task is...

```bash
bundle exec rake check_events[test,<ENVIRONMENT>,<ELEMENTS>,<ITERATIONS>]
```

Form example:

```bash
bundle exec rake check_events[test,integration,accordions,2]
```

Output is logged to a date/time named file in the [log](log/) directory.

## The `developer` route

This tool can be found at: http://localhost:3000/developer/index, simply enter the URL that you'd like to check the events for and click `Process`. The result will be a report detailing the URL tested and a list of the events found and created. The raw event data is also presented for reference.
