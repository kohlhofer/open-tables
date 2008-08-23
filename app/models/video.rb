class Video < Item
  
  def preview_url
    if self.source.match(/youtube/)
      return self.source.gsub(/.*watch\?v=/, 'http://i2.ytimg.com/vi/') + '/default.jpg'
    end
    return false
  end
  
  def video_url
    if self.source.match(/youtube/)
      return self.source.gsub(/watch\?v=/, 'v/')
    end
    return self.source
  end
end
