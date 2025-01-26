json.extract! encoded_item, :id, :descriptor, :value, :created_at, :updated_at
json.url encoded_item_url(encoded_item, format: :json)
