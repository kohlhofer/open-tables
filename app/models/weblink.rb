class Weblink < Item
  def url_short
    self.source.gsub(/https?:\/\//, '').gsub(/\/$/, '')
  end
end
