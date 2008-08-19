xml.tag! "graph" do
  xml.tag! "tags" do
    @item.tags.each do |tag|
      xml.tag! "tag", {:id => tag.id, :tag => tag}
    end
  end
  xml.tag! "items" do
    xml.item do
      xml.id @item.id
      xml.tag! "type", @item.type
      xml.title(@item.title)
      # TODO xml.cdata!
      xml.tag! "body" do
        xml.cdata! ( render(:file => "items/_" + @item.type.to_s.downcase + ".html.erb", :locals => {:item => @item }))
      end
      xml.tag! "source", @item.source
      xml.tag! "preview", @item.preview_url
      xml.tag! "created_at", (@item.updated_at.rfc2822)
      xml.link(item_url(@item))
      xml.tag! "relevant", @item.relevant?
    end
  end
  xml.tag! "tagEdges" do
    @item.tags.each do |tag|
      xml.tag! "tagEdge", {:item_id => @item.id, :tag_id => tag.id }
    end
  end
end