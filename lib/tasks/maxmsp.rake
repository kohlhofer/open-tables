require 'config/environment'
require 'xmlsimple'
namespace :maxmsp do
  desc "Pulls data from maxmsp output into database"
  task :pull => :environment, :needs => [:file] do |task, args|
    
    xml_content = XmlSimple.xml_in(args[:file])
    return if xml_content.nil?
    xml_content['tagEdge'].each do |item|
      Item.update(item['item_id'], {:tag_list => item['tag_list']}) rescue nil
    end
  end
end
