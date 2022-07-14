desc 'Check event data is as expected'
task :check_events, [:action, :environment, :interaction_type, :iterations] => :environment do |_, args|
  # Example: bundle exec rake check_events[create,integration,accordions,2]
  validate_args(args)

  options = {
    action: args[:action],
    environment: args[:environment],
    interaction_type: args[:interaction_type],
    iterations: args[:iterations]
  }

  klass = if options[:action] == "create"
    # Output events to a file
    CreateEvents.new(options)
  elsif options[:action] == "test"
    # Diff events against the expected event structure
    TestEvents.new(options)
  else
    "Invalid action param - Must be 'test' or 'create"
    exit
  end

  klass.run

  puts "Done!"
end

def validate_args(args)
  interaction_keys = ApplicationController.helpers.interactions.keys

  raise ArgumentError, "Invalid action param - Must be 'test' or 'fake'" unless ["test", "fake"].include? args[:action]
  raise ArgumentError, "Invalid environment param - Must be 'integration' or 'staging'" unless ["integration", "staging"].include? args[:environment]
  raise ArgumentError, "Invalid interaction_type param" unless interaction_keys.include? args[:interaction_type]
end
