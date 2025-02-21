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
    it_behaves_like "it redirects if an encoded item with the main descriptor doesn't exist yet" do
      let(:call_that_should_redirect) { get encoded_items_url }
    end

    it "renders a successful response under normal circumstances" do
      encoded_item
      get encoded_items_url
      expect(response).to be_successful
    end
  end

  describe "GET /show" do
    it_behaves_like "it redirects if an encoded item with the main descriptor doesn't exist yet" do
      let(:call_that_should_redirect) { get encoded_item_url(encoded_item) }
    end

    it "renders a successful response under normal circumstances" do
      get encoded_item_url(encoded_item)
      expect(response).to be_successful
    end
  end

  describe "GET /new" do
    it_behaves_like "it does NOT redirect if an encoded item with the main descriptor doesn't exist yet" do
      let(:call_that_should_not_redirect) { get new_encoded_item_url }
    end

    it "renders a successful response" do
      get new_encoded_item_url
      expect(response).to be_successful
    end
  end

  describe "POST /create" do
    it_behaves_like "it does NOT redirect if an encoded item with the main descriptor doesn't exist yet" do
      let(:call_that_should_not_redirect) {  post encoded_items_url, params: { encoded_item: valid_attributes } }
    end

    context "under normal circumstances" do
      context "with a successful save" do
        it "creates a new EncodedItem" do
          expect {
            post encoded_items_url, params: { encoded_item: valid_attributes }
          }.to change(EncodedItem, :count).by(1)
        end

        it "redirects to the created encoded_item" do
          post encoded_items_url, params: { encoded_item: valid_attributes }
          expect(response).to redirect_to(encoded_item_url(EncodedItem.last))
        end
      end

      context 'with an unsuccessful save' do
        before { allow_any_instance_of(EncodedItem).to receive(:save).and_return(false) }

        it 'should have a status of unprocessable entity' do
          post encoded_items_url, params: { encoded_item: valid_attributes }
          expect(response).to have_http_status(:unprocessable_entity)
        end
      end
    end
  end

  describe "DELETE /destroy" do
    it_behaves_like "it redirects if an encoded item with the main descriptor doesn't exist yet" do
      let(:call_that_should_redirect) { delete encoded_item_url(encoded_item) }
    end

    context "under normal circumstances" do
      it "destroys the requested encoded_item" do
        encoded_item = EncodedItem.create! valid_attributes
        expect {
          delete encoded_item_url(encoded_item)
        }.to change(EncodedItem, :count).by(-1)
      end

      it "redirects to the encoded_items list" do
        encoded_item = EncodedItem.create! valid_attributes
        delete encoded_item_url(encoded_item)
        expect(response).to redirect_to(encoded_items_url)
      end
    end
  end
end
