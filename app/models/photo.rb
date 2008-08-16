class Photo < Item
  
  def preview_url
    if self.body.match(/flickr\.com/)
      return self.body.gsub(/_s\.jpg/, '_m.jpg')
    end
    return self.body
  end
end
