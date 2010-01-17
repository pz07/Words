require 'test_helper'

class AnswersControllerTest < ActionController::TestCase

  test "should get new" do
    get :new, :question_id => question(:home)
    assert_response :success
    
    assert_select "form input#answer_text[type=text]"
  end

  test "should create answer" do
    assert_difference('Answer.count') do
      post :create, :answer => {:text => "test answer"}, :question_id => question(:home).id
    end

    assert_redirected_to question_path(question(:home))
  end

  test "should get edit" do
    get :edit, :id => answer(:home0).to_param
    assert_response :success

    assert_select "form input#answer_text[type=text][value=dom]"
  end

  test "should update answer" do
    put :update, :id => answer(:home0).to_param, :answer => {:text => "changed answer"}
    assert_redirected_to question_path(question(:home))
    
    assert_equal "changed answer", Answer.find(answer(:home0)).text
  end

  test "should destroy answer" do
    assert_difference('Answer.count', -1) do
      delete :destroy, :id => answer(:home0).to_param
    end

    assert_redirected_to question_path(question(:home))
  end
end
