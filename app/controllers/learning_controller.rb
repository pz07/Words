class LearningController < ApplicationController
  before_filter :require_user

  def index
    redirect_to :action => 'learn'
  end
  
  def info
    @repetitions = Repetition.find_by_user_id current_user.id
    @to_learn = Question.count(:conditions => ['next_attempt_date < ? and lesson.user_id = ? and lesson.active = ?', 
                                                    Time.now.utc.tomorrow.at_beginning_of_day, current_user.id, true ],
                                    :include => [:lesson])
    @in_lessons = Question.count(:select => 'lesson_id', :distinct => true, 
                                     :conditions => ['next_attempt_date < ? and lesson.user_id = ? and lesson.active = ?', 
                                                    Time.now.utc.tomorrow.at_beginning_of_day, current_user.id, true ],
                                     :include => [:lesson])
    
    @to_repeat = Repetition.count(:conditions => ['user_id = ?', current_user.id ])
    
    render :layout => "application"
  end
  
  # GET /learning/learn
  def learn
    repetition = false;
    repetition = params[:repetition] if params[:repetition]
    
    @attempt = LearningAttempt.new(current_user, repetition, params[:lesson_id])
    
    session[:attempt] = @attempt
  end
  
  def question
    @attempt = session[:attempt]
    
    changes = @attempt.get_changes
    @mark_correct = changes[:mark_correct]
    @mark_repeat = changes[:mark_repeat]
    
    qId = @attempt.current;
    if !qId
      @to_repeat = Repetition.count(:conditions => ['user_id = ?', current_user.id ]) 
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

    respond_to do |format|
      format.js {render :action => 'check'}
    end
  end
  
  def mark
    @attempt = session[:attempt]
    note = params[:note].to_i
    
    id = @attempt.mark note
    
    q = Question.find(id)
    if not @attempt.repetition then
      q.check note
      
      if note < 4 then
        Repetition.create(:user => current_user, :question => q, :day => Time.now.at_beginning_of_day).save
      end
    end
    
    if @attempt.repetition then
        if note >= 4 then
          Repetition.find_all_by_user_id_and_question_id(current_user, q).each do |r|
            r.destroy
          end
        end
    end
    
    redirect_to(:action => "question")
  end

  def fonetic_keyboard
  end

end
