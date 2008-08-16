class ItemsController < ApplicationController
  before_filter :current_item, :only => [:show, :edit, :update, :add_tag, :delete_tag, :toggle_relevant, :destroy]
  before_filter :current_topic
  
  include TagsHelper
  helper :tags

  def index
    per_page = 20
    per_page = 9 if request.format == :html
    if params[:tags]
#      params[:tags] = params[:tags][0].split(',') unless params[:tags].is_a?(Array)
      if @topic
        @items = @topic.items.published.find_tagged_with(params[:tags].join(','), :match_all => true).paginate(:per_page => per_page, :page => params[:page])
      else
        @items = Item.published.find_tagged_with(params[:tags], :match_all => true).paginate(:per_page => per_page, :page => params[:page])
      end
    elsif @topic
      @items = @topic.items.published.paginate(:per_page => per_page, :page => params[:page])
    else
      @items = Item.published.paginate(:per_page => per_page, :page => params[:page])
    end

    respond_to do |format|
      format.html # index.html.erb
      format.xml do # index.xml.erb
        @tags = @items.collect{|item| item.tags }.flatten.uniq 
        @tags.concat(@topic.tags).uniq if @topic
      end
    end
  end

  def show
    if !@topic and @item.topics and @item.topics.size == 1
      redirect_to formatted_topic_item_url(@item.topics[0], @item, params[:format]) and return if params[:format]
            redirect_to topic_item_url(@item.topics[0], @item) and return
    end
    @tags = @item.filtered_tags
    @tags += @topic.tags if @topic
    @tags = @tags.collect{|tag| tag.name }.sort.uniq
    respond_to do |format|
      format.html # show.html.erb
      format.xml  {  }
    end
  end

  def new
    @item = Item.new
    @item.topics << @topic if @topic

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @item }
    end
  end

  def edit
  end

  def create
    @item = Item.new(params[:item])
    @item.topics = [@topic] if @topic
    unless logged_in?
      @user = create_guest(params[:user])
      render :action => :new and return if @user.new_record?
    end
    respond_to do |format|
      if @item.save
        flash[:notice] = 'Item was successfully created.'
        format.html { redirect_to item_url(@item) and return }
        format.xml  { render :xml => @item, :status => :created, :location => @item }
      else
        flash[:error] = 'Item couldn\'t be created.'
        format.html { render :action => "new" and return}
        format.xml  { render :xml => @item.errors, :status => :unprocessable_entity }
      end
    end
  end

  def update
    @item.topics << @topic if @topic
    respond_to do |format|
      if @item.update_attributes(params[:item])
        flash[:notice] = 'Item was successfully updated.'
        format.html { redirect_to item_url(@item) and return }
        format.xml  { head :ok }
      else
        flash[:error] = 'Item couldn\'t be updated.'
        format.html { render :action => "edit" and return }
        format.xml  { render :xml => @item.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @item.destroy

    respond_to do |format|
      flash[:notice] = 'Item was destroyed'
      format.html { redirect_to(admin_items_url) }
      format.xml  { head :ok }
    end
  end
  
  def tag_cloud
    @tags = Item.tag_counts
  end
  
  def toggle_relevant
    @item.toggle_relevant(params[:tag])
    respond_to do |format|
      if @item.save(false)
        format.js { render :partial => 'relevant_rejected' }
      end
    end
  end
  def add_tag
    @item.tag_list.add(params[:tag])
    respond_to do |format|
      if @item.save(false)
        flash[:notice] = "Added tag"
        format.js { render :partial => 'tag', :locals => {:tag => params[:tag]} }
      else
        flash[:error] = "Couldn't add tag"
      end
      format.html { redirect_to :back and return }
    end
  end
  
  def delete_tag
    @item.tag_list.remove(params[:tag])
    respond_to do |format|
      if @item.save(false)
        format.js { render :partial => 'tag', :locals => {:tag => params[:tag]} }
      end
    end
  end
  
  private
  def current_item
    @item = Item.find(params[:id])
  end

  def current_topic
    return unless params[:topic_id]
    @topic = Topic.find(params[:topic_id])
  end
end
