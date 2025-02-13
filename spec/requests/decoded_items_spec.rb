require 'rails_helper'

RSpec.describe "/decoded_items", type: :request do
  let(:valid_attributes) do
    {
      descriptor: 'Some descriptor',
      value: 'Hello world!'
    }
  end
  let(:encoded_item) { FactoryBot.create(:encoded_item, valid_attributes) }

  before { allow(EncodedItem).to receive(:does_item_with_main_descriptor_exist?).and_return(true) }

  describe "GET /index" do
    it_behaves_like "it redirects if an encoded item with the main descriptor doesn't exist yet" do
      let(:call_that_should_redirect) { get decoded_items_url }
    end

    it "renders a successful response under normal circumstances" do
      encoded_item
      get decoded_items_url
      expect(response).to be_successful
    end
  end

  describe "GET /show" do
    it_behaves_like "it redirects if an encoded item with the main descriptor doesn't exist yet" do
      let(:call_that_should_redirect) { get decoded_item_url(encoded_item) }
    end

    it "renders a successful response under normal circumstances" do
      get decoded_item_url(encoded_item)
      expect(response).to be_successful
    end
  end
end
