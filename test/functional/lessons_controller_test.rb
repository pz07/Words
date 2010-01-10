require 'test_helper'

class LessonsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:lesson)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create lesson" do
    assert_difference('Lesson.count') do
      post :create, :lesson => { }
    end

    assert_redirected_to lesson_path(assigns(:lesson))
  end

  test "should show lesson" do
    get :show, :id => lesson(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => lesson(:one).to_param
    assert_response :success
  end

  test "should update lesson" do
    put :update, :id => lesson(:one).to_param, :lesson => { }
    assert_redirected_to lesson_path(assigns(:lesson))
  end

  test "should destroy lesson" do
    assert_difference('Lesson.count', -1) do
      delete :destroy, :id => lesson(:one).to_param
    end

    assert_redirected_to lesson_path
  end
end
