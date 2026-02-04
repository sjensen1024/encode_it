class DecodedItemsController < ApplicationController
    include MainSecretEntry

    def index
        render json: { allowed: false, decoded_items: [] } and return unless is_entered_main_secret_valid?

        render json: {
            allowed: true,
            decoded_items: EncodedItem.all.map { |item| format_item_with_decoded_value(item) }
        }
    end

    def show
        render json: { allowed: false, decoded_item: nil } and return unless is_entered_main_secret_valid?

        render json: {
            allowed: true,
            decoded_item: format_item_with_decoded_value(EncodedItem.find(params[:id]))
        }
    end

    private

    def format_item_with_decoded_value(encoded_item)
        {
            id: encoded_item.id,
            descriptor: encoded_item.descriptor,
            value: encoded_item.decode_value.force_encoding("ISO-8859-1").encode("UTF-8")
        }
    end
end
