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
    sort_order = "ASC"
    sort_order = params[:sort_order] if params[:sort_order] 
    
    sort_column = "next_attempt_date"
    sort_column = params[:sort_column] if params[:sort_column]
    
    out_sort = ", id DESC"
    out_sort = ", next_attempt_date ASC " + out_sort unless sort_column.include? "next_attempt_date" 
    
    @lesson = Lesson.find(params[:id])
    @questions = Question.paginate :page => params[:page], :per_page => 10, 
                      :conditions => {:lesson_id => @lesson}, 
                      :order => "#{sort_column} #{sort_order} #{out_sort}",
                      :joins => "left join level l on \"question\".level_id = l.id left join answer a on \"question\".id = a.question_id and a.priority = 1"
    
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
