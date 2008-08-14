# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def site_title
    @page_title.blank? ? Goldberg.settings.site_name : ('%s // %s' % [@page_title, Goldberg.settings.site_name])
  end
  
  def tag_list(tags = nil)
    tags = params[:tags][0] if tags.nil? and params[:tags]
    return [] if tags.nil?
    return tags.split(',') unless tags.is_a?(Array)
  end
  def rejected_or_relevant(tags = nil)
    tag_list(tags).each do |tag|
      return tag if %w(rejected relevant).include?(tag)
    end
  end
  def filtered_tag_list(tags = nil)
    tags = tag_list(tags)
    tags.reject{|t| ['rejected', 'relevant'].include?(t.to_s) }
  end
  
  def tag_list_for_url(new_tag = nil, tags = nil)
    tags = tag_list(tags)
    if params[:tags]
      if ['rejected', 'relevant'].include?(new_tag)
        puts new_tag.inspect
        tags.reject!{|t| ['rejected', 'relevant'].include?(t.to_s) }
        puts y tags
      end
      tags << new_tag if new_tag
      return tags.uniq.join(',')
    else
      new_tag
    end
  end
end
