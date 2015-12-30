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
  end

  def destroy
  end

  def export
  end

end
