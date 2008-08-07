xml.instruct! :xml, :version=>"1.0" 
xml.tag! "graph" do
  xml.tag! "tags" do
    @tags.each do |tag|
      xml.tag! "tag", {:id => tag.id, :tag => tag}
    end
  end
  xml.tag! "items" do
    @items.each do |item|
      xml.tag! "item", {:id => item.id, :title => item.title, :source => item.source,
        :body => item.body, :updated_at => item.updated_at.rfc2822, :type => item.type }
    end
  end
  xml.tag! "tagEdges" do
    @items.each do |item|
      item.tags.each do |tag|
        xml.tag! "tagEdge", {:item_id => item.id, :tag_id => tag.id }
      end
    end
  end
end