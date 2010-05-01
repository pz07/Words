class AnswersController < ApplicationController
  before_filter :require_user
  
  # GET /answer/new
  # GET /answer/new.xml
  def new
    @answer = Answer.new
    @answer.question = Question.find(params[:question_id])
  end

  # GET /answer/1/edit
  def edit
    @answer = Answer.find(params[:id])
  end

  # POST /answer
  # POST /answer.xml
  def create
    @answer = Answer.new(params[:answer])
    @answer.question = Question.find(params[:question_id])
    
    @answer.priority = @answer.question.answers[(@answer.question.answers.size) -1].priority + 1

    if @answer.save
      flash[:notice] = 'Answer was successfully created.'
      redirect_to question_path(@answer.question)
    else
      render :action => "new"
    end
  end

  # PUT /answer/1
  # PUT /answer/1.xml
  def update
    @answer = Answer.find(params[:id])

    if @answer.update_attributes(params[:answer])
      flash[:notice] = 'Answer was successfully updated.'
      redirect_to question_path(@answer.question)
    else
      render :action => "edit"
    end
  end

  # DELETE /answer/1
  # DELETE /answer/1.xml
  def destroy
    answer = Answer.find(params[:id])
    question = answer.question
    
    answer.destroy

    redirect_to question_path(question)
  end
end
