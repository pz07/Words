require 'test_helper'

class LessonsControllerTest < ActionController::TestCase
  
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:lessons)
    assert_equal 2, assigns(:lessons).size
    assert_select "table.dblist tr td", "Test lesson 02"
  end

  test "should get new" do
    get :new
    assert_response :success
    
    assert_select "form input#lesson_name"
  end

  test "should create lesson" do
    assert_difference('Lesson.count') do
      post :create, :lesson => {:name => "just created", :learning_schema => learning_schema(:default)}
    end

    assert_redirected_to lesson_path(assigns(:lesson))
  end

  test "should show lesson" do
    get :show, :id => lesson(:lesson01).to_param
    assert_response :success
    
    assert_select "table.dblist tr td", "Test lesson 01"
  end

  test "should get edit" do
    get :edit, :id => lesson(:lesson01).to_param
    assert_response :success
    
    assert_select "form input#lesson_name[value='Test lesson 01']"  
  end

  test "should update lesson" do
    put :update, :id => lesson(:lesson01).to_param, :lesson => {:name => "changed lesson name"}
    assert_redirected_to lesson_path(assigns(:lesson))
    
    assert_equal "changed lesson name", Lesson.find(lesson(:lesson01).id).name
  end

  test "should destroy lesson" do
    assert_difference('Lesson.count', -1) do
      delete :destroy, :id => lesson(:lesson01).to_param
    end

    assert_redirected_to lessons_path
  end
end
