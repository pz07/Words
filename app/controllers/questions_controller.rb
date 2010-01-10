class QuestionsController < ApplicationController

  # GET /question/1
  # GET /question/1.xml
  def show
    @question = Question.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @question }
    end
  end

  # GET /question/new
  # GET /question/new.xml
  def new
    @question = Question.new
    @question.lesson = Lesson.find(params[:lesson_id])
    
    @answer = Answer.new
    
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @question }
    end
  end

  # GET /question/1/edit
  def edit
    @question = Question.find(params[:id])
    #TODO do zmiany
    @answer = @question.first_answer
  end

  # POST /question
  # POST /question.xml
  def create
    @question = Question.new(params[:question])
    
    @question.lesson = Lesson.find(params[:lesson_id])
    @question.level = @question.lesson.learning_schema.start_level
    @question.last_level_update = Time.now
    
    @answer = Answer.new(params[:answer])

    if @question.valid?
      @answer.question = @question
      if @answer.valid?
        Question.transaction do
          @question.save
          @answer.save
          
          flash[:notice] = 'Question was successfully added.'
          redirect_to :controller => 'lessons', :action => "show", :id => @question.lesson    
        end
      else
        render :action => 'new'
      end
    else
      @answer.valid?
      render :action => 'new'
    end
  end

  # PUT /question/1
  # PUT /question/1.xml
  def update
    @question = Question.find(params[:id])
    @answer = @question.first_answer

    #todo sprawdzić czy działa walidacja
    if @question.update_attributes(params[:question]) and @answer.update_attributes(params[:answer])
      flash[:notice] = 'Question was successfully updated.'
      redirect_to :controller => 'lessons', :action => "show", :id => @question.lesson    
    else
      render :action => "edit"
    end
  end

  # DELETE /question/1
  # DELETE /question/1.xml
  def destroy
    @question = Question.find(params[:id])
    lesson = @question.lesson
    
    @question.destroy

    flash[:notice] = 'Word was successfully deleted'
    redirect_to :controller => 'lessons', :action => 'show', :id => lesson
  end
end
