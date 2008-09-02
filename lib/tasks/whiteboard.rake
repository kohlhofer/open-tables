require 'config/environment'
namespace :whiteboard do
  desc "Creates items from a directory's content"
  task :pull => :environment, :needs => [:directory] do |task, args|
    
    Dir.open(args[:dir]) do |dir|
      dir.each do |file|
        next if file.match /^\./
        topic_id = file.downcase.match(/^t(\d+)_/)[1] if file.downcase.match(/^t(\d+)_/)
        title = file.match(/^(.+)\./).nil? 'whiteboard file' : file.match(/^(.+)\./)[1]
        if file.downcase.match /(png|jpg|gif)$/
          File.rename(file, RAILS_ROOT + '/public/images/' + file.downcase)
          Photo.create!(:body => image_url(file.downcase), :topic_id => topic_id, :title => title)
        elsif file.downcase.match /txt$/
          f = File.new(file, 'r')
          Article.create!(:source => '/txt/' + file.downcase, :body => f.read, :topic_id => topic_id, :title => title)
          File.rename(file, RAILS_ROOT + '/public/txt/' + file.downcase)
        end
      end
    end
  end
end
