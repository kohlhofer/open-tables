require 'config/environment'
namespace :whiteboard do
  desc "Creates items from a directory's content"
  task :pull => :environment, :needs => [:directory] do |task, args|
    
    Dir.open(args[:dir]) do |dir|
      dir.each do |file|
        filename = args[:dir] + file
        next if file.match /^\./
        topic_id = file.downcase.match(/^t(\d+)_/)[1] if file.downcase.match(/^t(\d+)_/)
        title = file.match(/^(.+)\./).nil? ? 'whiteboard file' : file.match(/^(.+)\./)[1]
        if file.downcase.match /(png|jpg|gif)$/
          File.rename(filename, RAILS_ROOT + '/public/images/' + file.downcase)
          Photo.create!(:body => image_url(file.downcase), :topic_ids => topic_id, :title => title)
        elsif file.downcase.match /txt$/
          f = File.new(filename, 'r')
          Article.create!(:source => '/txt/' + file.downcase, :body => f.read, :topic_ids => topic_id, :title => title)
          f.close
          File.rename(filename, RAILS_ROOT + '/public/txt/' + file.downcase)
        end
      end
    end
  end
end
