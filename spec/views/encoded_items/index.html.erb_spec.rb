require 'rails_helper'

RSpec.describe "encoded_items/index", type: :view do
  before(:each) do
    assign(:encoded_items, [
      EncodedItem.create!(
        descriptor: "Descriptor",
        value: "Value"
      ),
      EncodedItem.create!(
        descriptor: "Descriptor",
        value: "Value"
      )
    ])
  end

  it "renders a list of encoded_items" do
    render
    cell_selector = 'div>p'
    assert_select cell_selector, text: Regexp.new("Descriptor".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("Value".to_s), count: 2
  end
end
