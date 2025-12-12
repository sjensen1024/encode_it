module FileBackup
    class ExportsController < ApplicationController
        def create
            items_to_export = EncodedItem.all
            exporter = FileBackup::Exporter.new(items_to_export)
            exporter.export

            send_file exporter.file_path, type: "application/json", filename: File.basename(exporter.file_path)
            rescue StandardError => e
            render json: { error: e.message }, status: :internal_server_error
        end
    end
end
