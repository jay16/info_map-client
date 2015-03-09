namespace :client do
  desc "info map client main"
  task :main => :environment do
    puts Settings.base.url
    Rake::Task["meminfo:centos"].invoke
  end
end
