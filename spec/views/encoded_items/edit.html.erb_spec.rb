require 'rails_helper'

RSpec.describe "encoded_items/edit", type: :view do
  let(:encoded_item) {
    EncodedItem.create!(
      descriptor: "MyString",
      value: "MyString"
    )
  }

  before(:each) do
    assign(:encoded_item, encoded_item)
  end

  it "renders the edit encoded_item form" do
    render

    assert_select "form[action=?][method=?]", encoded_item_path(encoded_item), "post" do

      assert_select "input[name=?]", "encoded_item[descriptor]"

      assert_select "input[name=?]", "encoded_item[value]"
    end
  end
end
