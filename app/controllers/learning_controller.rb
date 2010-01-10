class LearningController < ApplicationController
  
  def index
    redirect_to :action => 'learn'
  end
  
  # GET /learning/learn
  def learn
    lesson = Lesson.find(params[:lesson_id])
    @attempt = LearningAttempt.new(lesson)
    
    session[:attempt] = @attempt
  end
  
  def question
    @attempt = session[:attempt]
    
    if params[:mark_correct]
      @mark_correct = [params[:mark_correct]]
    end
    if params[:mark_repeat]
      @mark_repeat = [params[:mark_repeat]]
    end
    
    if @attempt.questionsToLearn.size > 0
      @question = Question.find(@attempt.questionsToLearn[0])
    elsif @attempt.questionsToRepeat.size > 0 
      @question = Question.find(@attempt.questionsToRepeat[0])
    else
      respond_to do |format|
        format.js {render :action => 'end_of_lesson'}
      end      
      return
    end
    
    respond_to do |format|
      format.js {render :action => 'question'}
    end
  end
  
  def check
    @question = Question.find(params[:question_id])
    
    if @question.correct?(params[:answer])
      respond_to do |format|
        format.js {render :action => 'correct'}
      end
    else
      respond_to do |format|
        format.js {render :action => 'wrong'}
      end
    end
  end
  
  def correct
    @attempt = session[:attempt]
    passed = @attempt.correct(params[:question_id])

    if passed
      q = Question.find(passed)
      q.next_level
      
      q.save!
      
      redirect_to(:action => "question", :mark_correct => passed)
    else
      redirect_to(:action => "question")
    end
  end

  def wrong
    @attempt = session[:attempt]
    to_repeat = @attempt.wrong(params[:question_id])
    
    if to_repeat
      redirect_to(:action => "question", :mark_repeat => to_repeat)
    else
      redirect_to(:action => "question")
    end
  end
  
end
