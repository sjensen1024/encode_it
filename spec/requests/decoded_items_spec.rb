require 'rails_helper'

RSpec.describe "/decoded_items", type: :request do
  let(:encoded_item) { FactoryBot.create(:encoded_item) }
  let(:main_secret_item) { FactoryBot.create(:encoded_item) }


  before do
    allow(main_secret_item).to receive(:decode_value).and_return("HelloWorld")
    allow(EncodedItem).to receive(:with_main_descriptor).and_return(main_secret_item)
    encoded_item
  end

  describe "GET /index" do
    context "there is no main secret item" do
      let(:main_secret_item) { nil }
      it_behaves_like "it redirects if an encoded item with the main descriptor doesn't exist yet" do
        let(:call_that_should_redirect) { get decoded_items_url }
      end
    end

    context "there is a main secret item" do
      context 'there is no main_secret_entry parameter' do
        let(:use_url) { decoded_items_url }

        it "does not return the decoded items" do
          get use_url
          expect(JSON.parse(response.body)).to eq(
            {
              allowed: false,
              decoded_items: []
            }.stringify_keys
          )
        end
      end

      context "there is a main_secret_entry parameter, but it does not match the main secret's decoded value" do
        let(:use_url) { decoded_items_url + "?main_secret_entry=Nope" }

        it "does not return the decoded items" do
          get use_url
          expect(JSON.parse(response.body)).to eq(
            {
              allowed: false,
              decoded_items: []
            }.stringify_keys
          )
        end
      end

      context "there is a main_secret_entry parameter that matches the main secret's decoded value" do
        let(:use_url) { decoded_items_url + "?main_secret_entry=HelloWorld" }

        it "returns the decoded items" do
          get use_url
          expect(JSON.parse(response.body)).to eq(
            {
              allowed: true,
              decoded_items: EncodedItem.all.map do |i|
                {
                  descriptor: i.descriptor,
                  id: i.id,
                  value: i.decode_value.force_encoding("ISO-8859-1").encode("UTF-8")
                }
              end
            }.deep_stringify_keys
          )
        end
      end
    end
  end

  describe "GET /show" do
    context "there is no main secret item" do
      let(:main_secret_item) { nil }
      it_behaves_like "it redirects if an encoded item with the main descriptor doesn't exist yet" do
        let(:call_that_should_redirect) { get decoded_item_url(encoded_item) }
      end
    end

    context "there is a main secret item" do
      context 'there is no main_secret_entry parameter' do
        let(:use_url) { decoded_item_url(encoded_item) }

        it "does not return the decoded item" do
          get use_url
          expect(JSON.parse(response.body)).to eq(
            {
              allowed: false,
              decoded_item: nil
            }.stringify_keys
          )
        end
      end

      context "there is a main_secret_entry parameter, but it does not match the main secret's decoded value" do
        let(:use_url) { decoded_item_url(encoded_item) + "?main_secret_entry=Nope" }

        it "does not return the decoded item" do
          get use_url
          expect(JSON.parse(response.body)).to eq(
            {
              allowed: false,
              decoded_item: nil
            }.stringify_keys
          )
        end
      end
    end

    context "there is a main_secret_entry parameter that matches the main secret's decoded value" do
      let(:use_url) { decoded_item_url(encoded_item) + "?main_secret_entry=HelloWorld" }

      it "returns the decoded item" do
        get use_url
        expect(JSON.parse(response.body)).to eq(
          {
            allowed: true,
            decoded_item: {
              descriptor: encoded_item.descriptor,
              id: encoded_item.id,
              value: encoded_item.decode_value.force_encoding("ISO-8859-1").encode("UTF-8")
            }
          }.deep_stringify_keys
        )
      end
    end
  end
end
