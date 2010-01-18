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
    
    changes = @attempt.get_changes
    @mark_correct = changes[:mark_correct]
    @mark_repeat = changes[:mark_repeat]
    
    qId = @attempt.current;
    if !qId
      respond_to do |format|
        format.js {render :action => 'end_of_lesson'}
      end      
      return
    end
  
    @question = Question.find(qId)
    respond_to do |format|
      format.js {render :action => 'question'}
    end
  end
  
  def check
    @attempt = session[:attempt]
    @question = Question.find(@attempt.current)
    
    correct = @question.correct(params[:answer]) 
    if correct == 100
      respond_to do |format|
        format.js {render :action => 'correct'}
      end
    else
      @levenshteinPercent = correct
      respond_to do |format|
        format.js {render :action => 'wrong'}
      end
    end
  end
  
  def correct
    @attempt = session[:attempt]
    passed = @attempt.correct

    if passed
      q = Question.find(passed)
      q.next_level
      
      q.save!
    end

    redirect_to(:action => "question")
  end

  def wrong
    @attempt = session[:attempt]
    @attempt.wrong
    
    redirect_to(:action => "question")
  end
  
  def skip
    @attempt = session[:attempt]
    @attempt.skip
    
    redirect_to(:action => "question")
  end
end
