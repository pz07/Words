class LessonsController < ApplicationController
  # GET /lesson
  # GET /lesson.xml
  def index
    @lessons = Lesson.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @lessons }
    end
  end

  # GET /lesson/1
  # GET /lesson/1.xml
  def show
    @lesson = Lesson.find(params[:id])
    @questions = Question.paginate :page => params[:page], :per_page => 10, 
                      :conditions => {:lesson_id => @lesson}, :order => 'level_id DESC, created_at DESC'
    
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @lesson }
    end
  end

  # GET /lesson/new
  # GET /lesson/new.xml
  def new
    @lesson = Lesson.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @lesson }
    end
  end

  # GET /lesson/1/edit
  def edit
    @lesson = Lesson.find(params[:id])
  end

  # POST /lesson
  # POST /lesson.xml
  def create
    @lesson = Lesson.new(params[:lesson])

    respond_to do |format|
      if @lesson.save
        flash[:notice] = 'Lesson was successfully created.'
        format.html { redirect_to(@lesson) }
        format.xml  { render :xml => @lesson, :status => :created, :location => @lesson }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @lesson.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /lesson/1
  # PUT /lesson/1.xml
  def update
    @lesson = Lesson.find(params[:id])

    respond_to do |format|
      if @lesson.update_attributes(params[:lesson])
        flash[:notice] = 'Lesson was successfully updated.'
        format.html { redirect_to(@lesson) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @lesson.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /lesson/1
  # DELETE /lesson/1.xml
  def destroy
    @lesson = Lesson.find(params[:id])
    @lesson.destroy

    respond_to do |format|
      format.html { redirect_to(lessons_url) }
      format.xml  { head :ok }
    end
  end
end
