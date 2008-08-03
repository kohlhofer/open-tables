class ItemsController < ApplicationController
  before_filter :current_item, :only => [:show, :edit, :update, :add_tag, :destroy]
  before_filter :current_topic
  
  include TagsHelper
  helper :tags

  def index
    if params[:tags] || params[:tag]
      params[:tags] = params[:tags].split(',') unless params[:tags].is_a?(Array)
      if @topic
        @items = @topic.items.published.find_tagged_with(params[:tags] || params[:tag], :match_all => true).paginate(:per_page => 20, :page => params[:page])
      else
        @items = Item.published.find_tagged_with(params[:tags] || params[:tag], :match_all => true).paginate(:per_page => 20, :page => params[:page])
      end
    elsif params[:topic_id].blank?
      @items = Item.published.paginate(:per_page => 20, :page => params[:page])
    else
      @items = @topic.items.published.paginate(:per_page => 20, :page => params[:page])
    end

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @items }
    end
  end

  def show
    if !@topic and @item.topics and @item.topics.size == 1
      redirect_to topic_item_url(@item.topics[0], @item) and return
    end
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @item }
    end
  end

  def new
    @item = @topic.items.new
    @item.topics << @topic

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @item }
    end
  end

  def edit
  end

  def create
    @item = Item.new(params[:item])
    unless logged_in?
      @user = create_guest(params[:user])
      render :action => :new and return if @user.new_record?
    end
    respond_to do |format|
      if @item.save
        flash[:notice] = 'Item was successfully created.'
        format.html { render :action => "show" and return }
        format.xml  { render :xml => @item, :status => :created, :location => @item }
      else
        flash[:error] = 'Item couldn\'t be created.'
        format.html { render :action => "new" and return}
        format.xml  { render :xml => @item.errors, :status => :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @item.update_attributes(params[:item])
        flash[:notice] = 'Item was successfully updated.'
        format.html { render :action => "show" and return }
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
  
  def add_tag
    @item.tag_list.add(params[:tag])
    respond_to do |format|
      if @item.save!
        flash[:notice] = "Added tag"
      else
        flash[:error] = "Couldn't add tag"
      end
      format.html { redirect_to :back and return }
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
