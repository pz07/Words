require 'test_helper'

class LearningSchemasControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:learning_schema)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create learning_schema" do
    assert_difference('LearningSchema.count') do
      post :create, :learning_schema => { }
    end

    assert_redirected_to learning_schema_path(assigns(:learning_schema))
  end

  test "should show learning_schema" do
    get :show, :id => learning_schema(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => learning_schema(:one).to_param
    assert_response :success
  end

  test "should update learning_schema" do
    put :update, :id => learning_schema(:one).to_param, :learning_schema => { }
    assert_redirected_to learning_schema_path(assigns(:learning_schema))
  end

  test "should destroy learning_schema" do
    assert_difference('LearningSchema.count', -1) do
      delete :destroy, :id => learning_schema(:one).to_param
    end

    assert_redirected_to learning_schema_path
  end
end
