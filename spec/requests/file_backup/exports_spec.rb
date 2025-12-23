require 'rails_helper'

RSpec.describe "FileBackup::Exports", type: :request do
  describe "POST /file_backup/export" do
    let(:tmpfile) { Tempfile.new([ 'items_export', '.json' ]) }

    after do
      tmpfile.close!
    end

    it "sends the export file on success" do
      # prepare exporter double to avoid touching implementation
      exporter = double('Exporter', export: true, file_path: tmpfile.path)
      allow(FileBackup::Exporter).to receive(:new).and_return(exporter)

      post file_backup_export_path

      expect(response).to have_http_status(:ok)
      # content should come from send_file; at minimum ensure content-type is json
      expect(response.header['Content-Type']).to include('application/json')
    end

    it "renders an error when exporter raises" do
      exporter = double('Exporter')
      allow(FileBackup::Exporter).to receive(:new).and_return(exporter)
      allow(exporter).to receive(:export).and_raise(StandardError.new('boom'))

      post file_backup_export_path

      expect(response).to have_http_status(:internal_server_error)
      parsed = JSON.parse(response.body)
      expect(parsed['error']).to include('boom')
    end
  end
end
