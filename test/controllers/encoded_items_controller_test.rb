require "test_helper"

class EncodedItemsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @encoded_item = encoded_items(:one)
  end

  test "should get index" do
    get encoded_items_url
    assert_response :success
  end

  test "should get new" do
    get new_encoded_item_url
    assert_response :success
  end

  test "should create encoded_item" do
    assert_difference("EncodedItem.count") do
      post encoded_items_url, params: { encoded_item: { value: @encoded_item.value } }
    end

    assert_redirected_to encoded_item_url(EncodedItem.last)
  end

  test "should show encoded_item" do
    get encoded_item_url(@encoded_item)
    assert_response :success
  end

  test "should get edit" do
    get edit_encoded_item_url(@encoded_item)
    assert_response :success
  end

  test "should update encoded_item" do
    patch encoded_item_url(@encoded_item), params: { encoded_item: { value: @encoded_item.value } }
    assert_redirected_to encoded_item_url(@encoded_item)
  end

  test "should destroy encoded_item" do
    assert_difference("EncodedItem.count", -1) do
      delete encoded_item_url(@encoded_item)
    end

    assert_redirected_to encoded_items_url
  end
end
