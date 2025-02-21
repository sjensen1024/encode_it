require 'rails_helper'

RSpec.describe "encoded_items/index", type: :view do
  before(:each) do
    assign(:encoded_items, [
      EncodedItem.create!(
        descriptor: "Descriptor 1",
        value: "Value 1"
      ),
      EncodedItem.create!(
        descriptor: "Descriptor 2",
        value: "Value 2"
      )
    ])
  end

  it "renders a list of encoded_items" do
    render
    expect(rendered).to match /Descriptor 1/
    expect(rendered).to match /Descriptor 2/
  end
end
