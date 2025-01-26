require "rails_helper"

RSpec.describe EncodedItemsController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/encoded_items").to route_to("encoded_items#index")
    end

    it "routes to #new" do
      expect(get: "/encoded_items/new").to route_to("encoded_items#new")
    end

    it "routes to #show" do
      expect(get: "/encoded_items/1").to route_to("encoded_items#show", id: "1")
    end

    it "routes to #edit" do
      expect(get: "/encoded_items/1/edit").to route_to("encoded_items#edit", id: "1")
    end


    it "routes to #create" do
      expect(post: "/encoded_items").to route_to("encoded_items#create")
    end

    it "routes to #update via PUT" do
      expect(put: "/encoded_items/1").to route_to("encoded_items#update", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/encoded_items/1").to route_to("encoded_items#update", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/encoded_items/1").to route_to("encoded_items#destroy", id: "1")
    end
  end
end
