require 'test_helper'

class QuestionsControllerTest < ActionController::TestCase
  
  test "should get new" do
    get :new, :lesson_id => lesson(:lesson01)
    assert_response :success
    
    assert_select "form input#question_text[type=text]"
    assert_select "form input#answer_text[type=text]"
  end

  test "should create question" do
    assert_difference('Question.count') do
      post :create, {:question => {:text => "test question"}, :answer => {:text => "test answer"}, :lesson_id => lesson(:lesson01).id}
    end

    assert_redirected_to lesson_path(lesson(:lesson01))
  end

  test "should show question" do
    get :show, :id => question(:home).to_param
    assert_response :success
    
    assert_select "table.dbdetails tr:nth-child(2) td", "home"
  end

  test "should get edit" do
    get :edit, :id => question(:home).to_param
    assert_response :success
    
    assert_select "form input#question_text[type=text][value=home]"
  end

  test "should update question" do
    put :update, :id => question(:home).id, :question => {:text => "home222"}
    assert_redirected_to question_path(assigns(:question))
    
    assert_equal "home222", Question.find(question(:home).id).text
  end

  test "should destroy question" do
    assert_difference('Question.count', -1) do
      delete :destroy, :id => question(:home).to_param
    end

    assert_redirected_to :controller => 'lessons', :action => 'show', :id => lesson(:lesson01)
  end
end
