require "application_system_test_case"

class EncodedItemsTest < ApplicationSystemTestCase
  setup do
    @encoded_item = encoded_items(:one)
  end

  test "visiting the index" do
    visit encoded_items_url
    assert_selector "h1", text: "Encoded items"
  end

  test "should create encoded item" do
    visit encoded_items_url
    click_on "New encoded item"

    fill_in "Value", with: @encoded_item.value
    click_on "Create Encoded item"

    assert_text "Encoded item was successfully created"
    click_on "Back"
  end

  test "should update Encoded item" do
    visit encoded_item_url(@encoded_item)
    click_on "Edit this encoded item", match: :first

    fill_in "Value", with: @encoded_item.value
    click_on "Update Encoded item"

    assert_text "Encoded item was successfully updated"
    click_on "Back"
  end

  test "should destroy Encoded item" do
    visit encoded_item_url(@encoded_item)
    click_on "Destroy this encoded item", match: :first

    assert_text "Encoded item was successfully destroyed"
  end
end
