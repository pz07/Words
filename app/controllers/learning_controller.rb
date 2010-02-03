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
    
    @answer = params[:answer]
    @levenshteinPercent = @question.correct(@answer) 
    if @levenshteinPercent == 100
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
    passed = @attempt.correct

    if passed
      q = Question.find(passed)
      q.correct_answer
    end

    redirect_to(:action => "question")
  end

  def wrong
    @attempt = session[:attempt]
    @attempt.wrong
    
    Question.find(@attempt.current).wrong_answer
    
    redirect_to(:action => "question")
  end
  
  def skip
    @attempt = session[:attempt]
    @attempt.skip
    
    redirect_to(:action => "question")
  end
  
  def onlyRepetitions
   session[:attempt].onlyRepetitions
   redirect_to(:action => "correct")
 end
 
  def fonetic_keyboard
    
  end

end
