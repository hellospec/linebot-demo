require "test_helper"

class ApiMessageCaptureTest < ActionDispatch::IntegrationTest
  test "can create sale order" do
    api_user = users(:api_user1)
    authorization = ActionController::HttpAuthentication::Basic.encode_credentials(api_user.email, 'password')
    assert_difference 'Sale.count' do
      post "/api/sale_orders", 
        headers: { 'HTTP_AUTHORIZATION' => authorization }, 
        params: post_params
    end

    assert_equal 200, status
  end

  test "bad request without params" do
    api_user = users(:api_user1)
    authorization = ActionController::HttpAuthentication::Basic.encode_credentials(api_user.email, 'password')
    post "/api/sale_orders", 
      headers: { 'HTTP_AUTHORIZATION' => authorization }

    assert_equal 400, status
    assert_equal "param is missing or the value is empty: sale", JSON.parse(response.body).fetch("error")
  end

  test "bad request with bad credential" do
    api_user = users(:api_user1)
    authorization = ActionController::HttpAuthentication::Basic.encode_credentials(api_user.email, 'bad')
    post "/api/sale_orders", 
      headers: { 'HTTP_AUTHORIZATION' => authorization },
      params: post_params

    assert_equal 401, status
    assert_equal "Not authorized", JSON.parse(response.body).fetch("error")
  end

  test "with missing attributes" do
    api_user = users(:api_user1)
    authorization = ActionController::HttpAuthentication::Basic.encode_credentials(api_user.email, 'password')
    post "/api/sale_orders", 
      headers: { 'HTTP_AUTHORIZATION' => authorization },
      params: {
        sale: { amount: "20" }
      }

    assert_equal 422, status
    assert_equal "Product code can't be blank,Channel code can't be blank", JSON.parse(response.body).fetch("error")
  end

  private

  def post_params
    {
      sale: {
        amount: "10", 
        product_code: Product.first.code,
        channel_code: "line"
      }
    }
  end
end

