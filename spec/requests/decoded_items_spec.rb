require 'rails_helper'

RSpec.describe "/decoded_items", type: :request do
    let(:valid_attributes) do
        {
            descriptor: 'Some descriptor',
            value: 'Hello world!'
        }
    end

    describe "GET /index" do
        it "renders a successful response" do
          EncodedItem.create! valid_attributes
          get encoded_items_url
          expect(response).to be_successful
        end
      end
    
      describe "GET /show" do
        it "renders a successful response" do
          encoded_item = EncodedItem.create! valid_attributes
          get encoded_item_url(encoded_item)
          expect(response).to be_successful
        end
      end
end
