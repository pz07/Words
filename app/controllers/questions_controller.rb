class QuestionsController < ApplicationController
  before_filter :require_user

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
    
    @iteration = Iteration.new
    @iteration.question = @question
    @iteration.iteration = 1
    @iteration.day_interval = 1
    @iteration.learning_begin = Time.now
    @iteration.answers_0 = 0
    @iteration.answers_1 = 0
    @iteration.answers_2 = 0
    @iteration.answers_3 = 0
    @iteration.answers_4 = 0
    @iteration.answers_5 = 0
    
    @question.lesson = Lesson.find(params[:lesson_id])
    @question.e_factor = 2.5
    @question.iteration = @iteration.iteration
    @question.last_attempt_date = Time.now
    @question.next_attempt_date = Time.now.advance(:days => @iteration.day_interval)
    
    @answer = Answer.new(params[:answer])
    @answer.priority = 1
    @answer.question = @question
    
    if @answer.valid?
      @question.answers << @answer
      if @question.valid?
        Question.transaction do
          @question.iterations << @iteration
          
          @question.save
          @answer.save
          
          Repetition.create(:user => current_user, :question => @question, :day => Time.now.at_beginning_of_day).save
          
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
  
  def level_down
    @question = Question.find(params[:id])

    @question.prev_level

    flash[:notice] = 'Question was successfully downgrade.'
    redirect_to question_path(@question)    
  end
  
  def level_up
    @question = Question.find(params[:id])

    @question.next_level

    flash[:notice] = 'Question was successfully downgrade.'
    redirect_to question_path(@question)    
  end
end
