class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  def enforce_main_encoded_item_existence
    redirect_to new_encoded_item_url unless EncodedItem.does_main_item_exist?
  end
end
