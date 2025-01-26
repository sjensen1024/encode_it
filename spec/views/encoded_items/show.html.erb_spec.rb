require 'rails_helper'

RSpec.describe "encoded_items/show", type: :view do
  before(:each) do
    assign(:encoded_item, EncodedItem.create!(
      descriptor: "Descriptor",
      value: "Value"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Descriptor/)
    expect(rendered).to match(/Value/)
  end
end
