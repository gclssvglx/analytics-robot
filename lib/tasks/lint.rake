desc "Run all linters"
task lint: :environment do
  sh "bundle exec rubocop"
  sh "yarn run lint" # lint JS and SCSS
end
