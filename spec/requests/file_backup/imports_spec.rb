require 'rails_helper'

RSpec.describe "FileBackup::Imports", type: :request do
  describe "POST /file_backup/import" do
    it "creates imported items from a valid JSON file" do
      payload = [
        { descriptor: 'D1', value: 'V1', placement: 'P1' },
        { descriptor: 'D2', value: 'V2', placement: 'P2' }
      ]

      file = Tempfile.new([ 'import', '.json' ])
      begin
        file.write(payload.to_json)
        file.rewind

        uploaded = Rack::Test::UploadedFile.new(file.path, 'application/json')

        post file_backup_import_path, params: { file: uploaded }

        expect(response).to have_http_status(:created)
        parsed = JSON.parse(response.body)
        expect(parsed['imported_count']).to eq(2)
      ensure
        file.close!
      end
    end

    it "returns 400 when no file is uploaded" do
      post file_backup_import_path, params: {}

      expect(response).to have_http_status(:bad_request)
      parsed = JSON.parse(response.body)
      expect(parsed['error']).to include('No file uploaded')
    end

    it "returns 422 for invalid JSON" do
      file = Tempfile.new([ 'invalid', '.json' ])
      begin
        file.write('not a json')
        file.rewind

        uploaded = Rack::Test::UploadedFile.new(file.path, 'application/json')

        post file_backup_import_path, params: { file: uploaded }

        expect(response).to have_http_status(:unprocessable_entity)
        parsed = JSON.parse(response.body)
        expect(parsed['error']).to include('Invalid JSON file')
      ensure
        file.close!
      end
    end
  end
end
