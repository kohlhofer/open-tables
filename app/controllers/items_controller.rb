class ItemsController < ApplicationController
  before_filter :current_item, :only => [:show, :edit, :update, :add_tag, :destroy]

  def index
    @items = Item.published.paginate(:per_page => 20, :page => params[:page])

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @items }
    end
  end

  def show
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @item }
    end
  end

  def new
    @item = Item.new

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
  
  private
  def current_item
    @item = Item.find(params[:id])
  end
end
