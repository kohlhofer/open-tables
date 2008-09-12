class TimedCacheStore
  attr_reader :parent_cache_store
  def initialize(*args)
    @parent_cache_store = ActiveSupport::Cache.lookup_store(args)    
  end

  def read(key, options = {})
    options = {:until => options} unless options.is_a?(Hash)
    if options[:until]
      expiry = @parent_cache_store.read("meta/" + key, options)
      if expiry && Time.parse(expiry) > Time.now && value = @parent_cache_store.read(key, options)
        return value
      end
      return false
    end  
    @parent_cache_store.read(key, options)
  end
  
  def write(key, value, options = {})
    options = {:until => options} unless options.is_a?(Hash)
    if options[:until]
      @parent_cache_store.write("meta/" + key, options[:until].to_s, options)
    end
    @parent_cache_store.write(key, value, options)
  end
  
  def exist?(key, options = {})
    options = {:until => options} unless options.is_a?(Hash)
    if options[:until]
      expiry = @parent_cache_store.read("meta/" + key, options)
      unless expiry && Time.parse(expiry) > Time.now
        return false
      end
    end
    @parent_cache_store.exist?(key, options)
  end

  def method_missing(method, *args)
    @parent_cache_store.send method, *args
  end
end