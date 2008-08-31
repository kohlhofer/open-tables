require 'config/environment'

namespace :feedme do
  desc "Pull the latest feeds and populate the database."
  task :pull_feeds => :environment do 
    feeds = Feed.find(:all)
    
    feeds.each do |feed|
      begin
        feed.refresh
      rescue RuntimeError => e
        # Silent but deadly...well, not so much.
        # Let's note this and move on to the next feed.
        puts e
      end
    end
  end
end