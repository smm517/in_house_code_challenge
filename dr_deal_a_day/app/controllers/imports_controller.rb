class ImportsController < ApplicationController

  def index
    @imports = Import.all
    @total_revenue = Import.total_revenue
  end

  def create
    data_file = params[:import_file]
    duplicate_file_name = Import.where(file_name: data_file.try(:original_filename)).first

    if data_file.nil?
      flash[:alert] = "Error: no data file was selected."
    elsif  duplicate_file_name.present?
      flash[:alert] = "A previous import has the same file name as the file you have selected. After ensuring that your file does not have the same data as the previous import, please upload it with a different file name."
      flash[:link_path] = import_path(duplicate_file_name.id)
      flash[:link_text] = "Click here to view the previous import."
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
    import.orders.destroy_all
    import.destroy!

    redirect_to action: :index
  end

end
