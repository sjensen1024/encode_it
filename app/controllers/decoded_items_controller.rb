class DecodedItemsController < ApplicationController
    def index
        encoded_items = EncodedItem.all

        render json: encoded_items.map { |item| format_item_with_decoded_value(item) }
    end

    def show
        encoded_item = EncodedItem.find(params[:id])

        render json: format_item_with_decoded_value(encoded_item)
    end

    private

    def format_item_with_decoded_value(encoded_item)
        {
            descriptor: encoded_item.descriptor,
            value: encoded_item.decode_value.force_encoding("ISO-8859-1").encode("UTF-8")
        }
    end
end
