class TopicsController < ApplicationController
  before_filter :current_topic, :only => [:show, :edit, :update, :add_tag, :destroy]

  include TagsHelper
  helper :tags
  
  caches_action [:index], :until => Time.now + 5.minutes

  def index
    @topics = Topic.active.paginate(:per_page => 20, :page => params[:page])

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @topics }
    end
  end

  def show
    redirect_to :controller => 'items', :topic_id => params[:id] and return
  end

  def new
    @topic = Topic.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @topic }
    end
  end

  def edit
  end

  def create
    @topic = Topic.new(params[:topic])
    respond_to do |format|
      if @topic.save
        flash[:notice] = 'Topic was successfully created.'
        format.html { render :action => "show" and return }
        format.xml  { render :xml => @topic, :status => :created, :location => @topic }
      else
        flash[:error] = 'Topic couldn\'t be created.'
        format.html { render :action => "new" and return}
        format.xml  { render :xml => @topic.errors, :status => :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @topic.update_attributes(params[:topic])
        flash[:notice] = 'Topic was successfully updated.'
        format.html { redirect_to topic_url(@topic) and return }
        format.xml  { head :ok }
      else
        flash[:error] = 'Topic couldn\'t be updated.'
        format.html { render :action => "edit" and return }
        format.xml  { render :xml => @topic.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @topic.update_attribute(:active, false)

    respond_to do |format|
      flash[:notice] = 'Topic was destroyed'
      format.html { redirect_to(admin_topics_url) }
      format.xml  { head :ok }
    end
  end
  
  private
  def current_topic
    @topic = Topic.find(params[:id])
  end
end