xml.instruct!
xml.rss(:version=>"2.0", "xmlns:dc" => "http://purl.org/dc/elements/1.1/", "xmlns:atom" => "http://www.w3.org/2005/Atom") do
  xml.channel do
    xml.title(Goldberg.settings.site_name)
    xml.link(Goldberg.settings.site_url_prefix)
    xml.language("en-UK")
    
    for item in @items
      xml.item do
        xml.title(item.title)
        xml.description do
          xml.cdata! ( render(:file => "items/_" + item.type.to_s.downcase + ".html.erb", :locals => {:item => item }))
        end
        xml.tag! "source", item.source
        for tag in item.tags
          xml.tag! "category", tag
        end
        xml.pubDate(item.updated_at.rfc2822)
        xml.link(item_url(item))
        xml.guid(item_url(item))
      end
    end
  end
end