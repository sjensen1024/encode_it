module MainSecretEntry
  extend ActiveSupport::Concern

  private

  def is_entered_main_secret_valid?
    return false if params["main_secret_entry"].blank?

    main_encoded_item = EncodedItem.with_main_descriptor
    params["main_secret_entry"] == main_encoded_item.decode_value
  end
end
