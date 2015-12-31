class ImportsController < ApplicationController

  def index
    @imports = Import.order('created_at DESC')
    @total_revenue = Import.total_revenue
  end

  def create
    data_file = params[:import_file]

    if data_file.nil?
      flash[:alert] = "Error: no data file was selected."
    else
      begin
        options = {}
        if data_file.content_type == "text/tab-separated-values"
          options[:using_tsv] = true
        end

        Import.run_import(data_file.path, data_file.original_filename, options)

      rescue CSV::MalformedCSVError => e
        flash[:alert] = "Error: data file is incorrectly formatted."
      rescue Import::EmptyDataFileError, Import::InvalidDataError => e
        flash[:alert] = e.message
      rescue Import::DuplicateFileNameError => e
        flash[:alert] = e.message
        flash[:link_path] = import_path(e.duplicate_import_id)
        flash[:link_text] = "Click here to view the previous import."
      end
    end
    flash[:notice] = "Data was imported successfully." if flash[:alert].nil?

    redirect_to action: :index
  end

  def show
    @import = Import.find(params[:id])

    respond_to do |format|
      format.html
      format.csv {
        options = {}

        if File.extname(@import.file_name) == ".tsv"
          options[:using_tsv] = true
        end
        send_data @import.to_csv(options), filename: @import.file_name
      }
    end
  end

  def destroy
    import = Import.find(params[:id])

    if import.destroy
      flash[:notice] = "Import was deleted successfully."
    else
      flash[:alert] = "Error: import was deletion was unsuccessful."
    end

    redirect_to action: :index
  end

end
