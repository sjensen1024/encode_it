require 'rails_helper'

RSpec.describe "encoded_items/new", type: :view do
  before(:each) do
    assign(:encoded_item, EncodedItem.new(
      descriptor: "MyString",
      value: "MyString"
    ))
  end

  it "renders new encoded_item form" do
    render

    assert_select "form[action=?][method=?]", encoded_items_path, "post" do
      assert_select "input[name=?]", "encoded_item[descriptor]"

      assert_select "input[name=?]", "encoded_item[value]"
    end
  end
end
