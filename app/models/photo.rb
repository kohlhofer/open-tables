class Photo < Item
  
  def preview_url
    if self.body.match(/flickr\.com/)
      return self.body.gsub(/\.jpg/, '_m.jpg')
    end
    return self.body
  end
end
