class LevelsController < ApplicationController
  before_filter :require_user

  # GET /level
  # GET /level.xml
  def index
    @level = Level.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @level }
    end
  end

  # GET /level/1
  # GET /level/1.xml
  def show
    @level = Level.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @level }
    end
  end

  # GET /level/new
  # GET /level/new.xml
  def new
    @level = Level.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @level }
    end
  end

  # GET /level/1/edit
  def edit
    @level = Level.find(params[:id])
  end

  # POST /level
  # POST /level.xml
  def create
    @level = Level.new(params[:level])

    respond_to do |format|
      if @level.save
        flash[:notice] = 'Level was successfully created.'
        format.html { redirect_to(@level) }
        format.xml  { render :xml => @level, :status => :created, :location => @level }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @level.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /level/1
  # PUT /level/1.xml
  def update
    @level = Level.find(params[:id])

    respond_to do |format|
      if @level.update_attributes(params[:level])
        flash[:notice] = 'Level was successfully updated.'
        format.html { redirect_to(@level) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @level.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /level/1
  # DELETE /level/1.xml
  def destroy
    @level = Level.find(params[:id])
    @level.destroy

    respond_to do |format|
      format.html { redirect_to(level_url) }
      format.xml  { head :ok }
    end
  end
end
