class MainEncodedItemExistencesController < ApplicationController
    def show
        render json: { does_main_encoded_item_exist: EncodedItem.does_item_with_main_descriptor_exist? }
    end
end
