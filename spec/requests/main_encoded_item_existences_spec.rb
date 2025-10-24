require 'rails_helper'

RSpec.describe "/main_encoded_item_existence", type: :request do
    describe "GET /show" do
        it 'returns a true response if the main encoded item exists' do
            allow(EncodedItem).to receive(:does_item_with_main_descriptor_exist?).and_return(true)
            get "/main_encoded_item_existence.json"
            json_response = JSON.parse(response.body).symbolize_keys
            expect(json_response[:does_main_encoded_item_exist]).to be(true)
        end

        it 'returns a false response if the main encoded item does not exist' do
            allow(EncodedItem).to receive(:does_item_with_main_descriptor_exist?).and_return(false)
            get "/main_encoded_item_existence.json"
            json_response = JSON.parse(response.body).symbolize_keys
            expect(json_response[:does_main_encoded_item_exist]).to be(false)
        end
    end
end
