class EncodedItem < ApplicationRecord
    before_save :apply_placement, :encode_value

    def decode_value
        Base64.decode64(self.value)
    end

    private

    def encode_value
        self.value = Base64.encode64(self.value)
    end

    def apply_placement
        self.placement = Base64.encode64(rand(0..9).to_s)
    end

    def parse_placement
        Base64.decode64(self.placement).to_i
    end
end
