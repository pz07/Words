class QuestionsController < ApplicationController

  # GET /question/1
  # GET /question/1.xml
  def show
    @question = Question.find(params[:id])
  end

  # GET /question/new
  # GET /question/new.xml
  def new
    @question = Question.new
    @question.lesson = Lesson.find(params[:lesson_id])
    
    @answer = Answer.new
  end

  # GET /question/1/edit
  def edit
    @question = Question.find(params[:id])
  end

  # POST /question
  # POST /question.xml
  def create
    @question = Question.new(params[:question])
    
    @question.lesson = Lesson.find(params[:lesson_id])
    @question.level = @question.lesson.learning_schema.start_level
    @question.last_attempt_date = Time.now
    @question.next_attempt_date = Time.now
    
    @answer = Answer.new(params[:answer])
    @answer.priority = 1
    @answer.question = @question
    
    if @answer.valid?
      @question.answers << @answer
      if @question.valid?
        Question.transaction do
          @question.save
          @answer.save
          
          @question.lesson.reload
          
          flash[:notice] = 'Question was successfully added.'
          redirect_to lesson_path(@question.lesson)    
        end
      else
        render :action => 'new'
      end
    else
      @question.valid?
      render :action => 'new'
    end
  end

  # PUT /question/1
  # PUT /question/1.xml
  def update
    @question = Question.find(params[:id])

    if @question.update_attributes(params[:question])
      flash[:notice] = 'Question was successfully updated.'
      redirect_to question_path(@question)    
    else
      render :action => "edit"
    end
  end

  # DELETE /question/1
  # DELETE /question/1.xml
  def destroy
    question = Question.find(params[:id])
    lesson = question.lesson
    
    question.destroy

    flash[:notice] = 'Question was successfully deleted'
    redirect_to :controller => 'lessons', :action => 'show', :id => lesson
  end
  
end
