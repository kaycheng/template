require 'fileutils'

source_paths.unshift(File.dirname(__FILE__))

def copy_procfile
  copy_file 'Procfile.dev'
  copy_file '.foreman'
end

gem_group :development, :test do
  gem 'foreman', '~> 0.87.1'
  gem 'hirb-unicode', '~> 0.0.5'
  gem 'rspec-rails', '~> 4.0', '>= 4.0.1'
  gem 'factory_bot_rails', '~> 5.2'
  gem 'faker', '~> 2.12'
  gem 'pry-rails', '~> 0.3.9'
end

after_bundle do
  application do <<-RUBY
    config.generators do |g|
      g.assets false
      g.helper false
      g.test_framework false
    end
  RUBY
  end

  copy_procfile

  route "root 'welcome#index'"

  run "spring stop"

  generate :controller, "welcome"

  file 'app/views/welcome/index.html.erb', <<-CODE
    <h1>Welcome, Rails :)</h1>
  CODE

  generate "rspec:install"
  remove_dir "test"

  git :init
  git add: '.'
  git commit: "-a -m 'First init.'"
end
