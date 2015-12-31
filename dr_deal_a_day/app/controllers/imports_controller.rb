class ImportsController < ApplicationController

  def index
    @imports = Import.all
    @total_revenue = Order.total_revenue
  end

  def create
    Import.run_import(params[:import_file])
    redirect_to action: :index
  end

  def show
    @import = Import.find(params[:id])

    respond_to do |format|
      format.html
      format.csv {
        send_data @import.to_csv, filename: @import.file_name
      }
    end
  end

  def destroy
  end

end
