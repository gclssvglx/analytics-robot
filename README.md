![logotype](https://repository-images.githubusercontent.com/504593718/e7d63c5c-0050-48d8-a2f1-2f79c3a6f2cf)

A tool for generating realistic Google Analytics 4 (GA4) events on the [GOV.UK](https://www.gov.uk) `integration` and `staging` environments. It does this by simply navigating to pages and (if required) interacting with specific elements and components (tags, accordions, links etc) in the same way a real user might.

It can also be used to test that the resulting events contain the data - in a predetermined and specific data structure - are as expected and haven't changed. Useful to validate that changes within the overall system haven't altered your expected analytics behaviour and event output.

It was built primarily for Performance Analysts and others who want to generate bulk events quickly, easily and in a pre-determined manner.

## Architecture

The tool is a standard [Ruby on Rails](https://rubyonrails.org/) project - and does not require a database.

## Development

### Installing dependencies

```bash
bundle install
bundle exec yarn install
bundle exec npm install
// Q: do we need yarn and npm here?
```

### Running the application

For development...

```bash
bin/dev
```

Should now be running at [http://localhost:3000](http://localhost:3000/)

For production...

```bash
// TODO
```

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
