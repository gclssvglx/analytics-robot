# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require_relative "config/application"

Rails.application.load_tasks

# Undo any existing default tasks added by depenencies so we can redefine the task
Rake::Task[:default].clear if Rake::Task.task_defined?(:default)
task default: %i[lint spec]
