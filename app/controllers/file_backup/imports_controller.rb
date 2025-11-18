class FileBackup::ImportsController < ApplicationController
    def create
        uploaded_file = params[:file]
        if uploaded_file.nil?
            render json: { error: "No file uploaded" }, status: :bad_request
            return
        end

        file_content = uploaded_file.read

        importer = FileBackup::Importer.new(file_content)
        imported_items = importer.import

        render json: { imported_count: imported_items.size }, status: :created
        rescue JSON::ParserError
        render json: { error: "Invalid JSON file" }, status: :unprocessable_entity
    end
end
