require 'test_helper'

class LevelsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:level)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create level" do
    assert_difference('Level.count') do
      post :create, :level => { }
    end

    assert_redirected_to level_path(assigns(:level))
  end

  test "should show level" do
    get :show, :id => level(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => level(:one).to_param
    assert_response :success
  end

  test "should update level" do
    put :update, :id => level(:one).to_param, :level => { }
    assert_redirected_to level_path(assigns(:level))
  end

  test "should destroy level" do
    assert_difference('Level.count', -1) do
      delete :destroy, :id => level(:one).to_param
    end

    assert_redirected_to level_path
  end
end
