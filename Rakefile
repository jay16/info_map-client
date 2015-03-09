#!/usr/bin/env rake
# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

$:.unshift(File.dirname(__FILE__))

task :default => [:environment]

desc "set up environment for rake"
task :environment => "Gemfile.lock" do
  ENV["APP_ROOT_PATH"] = Dir.pwd
  ENV["RACK_ENV"]      = "production"
  require "%s/config/boot.rb" % ENV["APP_ROOT_PATH"]
  load "%s/config/settings.rb" % ENV["APP_ROOT_PATH"]

  @settings = Settings
end
Dir.glob('tasks/*.rake').each { |file| load file }
