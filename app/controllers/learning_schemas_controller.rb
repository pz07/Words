class LearningSchemasController < ApplicationController
  # GET /learning_schema
  # GET /learning_schema.xml
  def index
    @learning_schema = LearningSchema.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @learning_schema }
    end
  end

  # GET /learning_schema/1
  # GET /learning_schema/1.xml
  def show
    @learning_schema = LearningSchema.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @learning_schema }
    end
  end

  # GET /learning_schema/new
  # GET /learning_schema/new.xml
  def new
    @learning_schema = LearningSchema.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @learning_schema }
    end
  end

  # GET /learning_schema/1/edit
  def edit
    @learning_schema = LearningSchema.find(params[:id])
  end

  # POST /learning_schema
  # POST /learning_schema.xml
  def create
    @learning_schema = LearningSchema.new(params[:learning_schema])

    respond_to do |format|
      if @learning_schema.save
        flash[:notice] = 'LearningSchema was successfully created.'
        format.html { redirect_to(@learning_schema) }
        format.xml  { render :xml => @learning_schema, :status => :created, :location => @learning_schema }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @learning_schema.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /learning_schema/1
  # PUT /learning_schema/1.xml
  def update
    @learning_schema = LearningSchema.find(params[:id])

    respond_to do |format|
      if @learning_schema.update_attributes(params[:learning_schema])
        flash[:notice] = 'LearningSchema was successfully updated.'
        format.html { redirect_to(@learning_schema) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @learning_schema.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /learning_schema/1
  # DELETE /learning_schema/1.xml
  def destroy
    @learning_schema = LearningSchema.find(params[:id])
    @learning_schema.destroy

    respond_to do |format|
      format.html { redirect_to(learning_schema_url) }
      format.xml  { head :ok }
    end
  end
end
