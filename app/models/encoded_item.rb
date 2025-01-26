class EncodedItem < ApplicationRecord
    before_create :encode_value

    private

    def encode_value
        self.value = Base64.encode64(self.value)
    end
end
