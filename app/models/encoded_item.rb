class EncodedItem < ApplicationRecord
    before_create :encode_value

    def decode_value
        Base64.decode64(self.value)
    end

    private

    def encode_value
        self.value = Base64.encode64(self.value)
    end
end
