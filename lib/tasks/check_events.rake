desc "Check event data is as expected"
task :check_events, %i[action environment interaction_type iterations] => :environment do |_, args|
  # Example: bundle exec rake check_events[fake,integration,accordions,2]
  validate_args(args)

  options = {
    action: args[:action],
    environment: args[:environment],
    interaction_type: args[:interaction_type],
    iterations: args[:iterations],
  }

  klass = case options[:action]
          when "fake"
            # Output events to a file
            FakeEvents.new(options)
          when "test"
            # Diff events against the expected event structure
            TestEvents.new(options)
          end

  klass.run

  puts "\nDone!"
end

def validate_args(args)
  interaction_keys = ApplicationController.helpers.interactions.keys

  raise ArgumentError, "Invalid action param - Must be 'test' or 'fake'" unless %w[test fake].include? args[:action]
  raise ArgumentError, "Invalid environment param - Must be 'integration' or 'staging'" unless %w[integration staging].include? args[:environment]
  raise ArgumentError, "Invalid interaction_type param" unless interaction_keys.include? args[:interaction_type]
end
