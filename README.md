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

## Setup Chrome for Testing + chromedriver


- Download both `chrome` AND `chromedriver` from https://googlechromelabs.github.io/chrome-for-testing/ - you'll want the `mac-arm64` version if you're on an M1 Mac.
- Extract the zip file for `chrome` by double clicking the downloaded file.
- Open your terminal, and go to the folder where Chrome was extracted, e.g. `~/Downloads/chrome-mac-arm64`
- Run `sudo xattr -cr 'Google Chrome for Testing.app'`. This removes Apple's security, which prevents files that originated from zip files from being executed.
- In your Finder, move `Google Chrome for Testing.app` into your Mac's Applications folder, like you usually do to install applications on a Mac.
- Now, we need to setup `chromedriver`.
- Extract the `.zip` file for `chromedriver` by double clicking the downloaded file.
- Move the `chromedriver` file to `/usr/local/bin`. You can do this by running `cp /Users/[YOUR.NAME]/Downloads/chrome-mac-arm64/chromedriver /usr/local/bin/chromedriver`
- Change directory to `/usr/local/bin` in your terminal
- Run `chmod +x chromedriver` to make chromedriver executable
- Run `sudo xattr -r -d com.apple.quarantine chromedriver` to remove Apple's security quarantine from the file
- Restart your terminal, and to test chromedriver is working, run `chromedriver -v`
- You shouldn't need to run these steps ever again, unless you want to update your test version of Google Chrome

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
