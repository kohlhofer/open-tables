xml.instruct! :xml, :version=>"1.0" 
xml.rss(:version=>"2.0") do
  xml.channel do
    xml.title(Goldberg.settings.site_name)
    xml.link(Goldberg.settings.site_url_prefix)
    xml.language("en-UK")
    for item in @items
      xml.item do
        xml.tag! "type", item.type
        xml.title(item.title)
        # TODO xml.cdata!
        xml.tag! "body", ( render(:file => "items/_" + item.type.to_s.downcase + ".html.erb", :locals => {:item => item }))
        xml.tag! "source", item.source
        xml.tag! "tags" do
          for tag in item.tags
            xml.tag! "tag", {:id => tag.id, :tag => tag}
          end
        end
        xml.pubDate(item.updated_at.rfc2822)
        xml.link(item_url(item))
        xml.guid(item_url(item))
      end
    end
  end
end