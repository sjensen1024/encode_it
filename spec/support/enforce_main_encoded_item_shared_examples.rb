shared_examples "it redirects if an encoded item with the main descriptor doesn't exist yet" do
    let(:call_that_should_redirect) { "ex: get encoded_items_url" }

    context "there is no encoded item with the main descriptor yet" do
        before { allow(EncodedItem).to receive(:does_item_with_main_descriptor_exist?).and_return(false) }

        it "should redirect to the url for making a new encoded item" do
            expect(call_that_should_redirect).to redirect_to(new_encoded_item_url)
        end
    end
end

shared_examples "it does NOT redirect if an encoded item with the main descriptor doesn't exist yet" do
    let(:call_that_should_not_redirect) { "ex: get new_encoded_item_url" }

    context "there is no encoded item with the main descriptor yet" do
        before { allow(EncodedItem).to receive(:does_item_with_main_descriptor_exist?).and_return(false) }

        it "should redirect to the url for making a new encoded item" do
            expect(call_that_should_not_redirect).not_to redirect_to(new_encoded_item_url)
        end
    end
end
