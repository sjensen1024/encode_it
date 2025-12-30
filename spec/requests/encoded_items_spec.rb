require 'rails_helper'

RSpec.describe "/encoded_items", type: :request do
  let(:valid_attributes) do
    {
        descriptor: 'Some descriptor',
        value: 'Hello world!'
    }
  end
  let(:encoded_item) { FactoryBot.create(:encoded_item, valid_attributes) }

  before { allow(EncodedItem).to receive(:does_item_with_main_descriptor_exist?).and_return(true) }

  describe "GET /index" do
    it "renders a successful response" do
      encoded_item
      get encoded_items_url
      expect(response).to be_successful
    end
  end

  describe "GET /show" do
    it "renders a successful response" do
      get encoded_item_url(encoded_item)
      expect(response).to be_successful
    end
  end

  describe "POST /create" do
    context "with a successful save" do
      it "creates a new EncodedItem" do
        expect {
          post encoded_items_url, params: { encoded_item: valid_attributes }
        }.to change(EncodedItem, :count).by(1)
      end

      it "redirects to the created encoded_item" do
        post encoded_items_url, params: { encoded_item: valid_attributes }, as: :turbo_stream
        expect(response.body).to include("Some descriptor")
      end
    end

    context 'with an unsuccessful save' do
      before { allow_any_instance_of(EncodedItem).to receive(:save).and_return(false) }

      # TODO: Change this once we make it so it doesn't reload the entire page.
      it 'should have a status of unprocessable entity' do
        post encoded_items_url, params: { encoded_item: valid_attributes }, as: :turbo_stream
        expect(response).to have_http_status(302)
      end
    end
  end

  describe "DELETE /destroy" do
    it "destroys the requested encoded_item" do
      encoded_item = EncodedItem.create! valid_attributes
      expect {
        delete encoded_item_url(encoded_item)
      }.to change(EncodedItem, :count).by(-1)
    end

    it "redirects to the encoded_items list" do
      encoded_item = EncodedItem.create! valid_attributes
      delete encoded_item_url(encoded_item), as: :turbo_stream
      expect(response.body).not_to include("Some descriptor")
    end
  end
end
