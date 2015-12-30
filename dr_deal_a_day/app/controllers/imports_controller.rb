class ImportsController < ApplicationController

  def index
    @imports = Import.all
  end

  def create
    Import.run_import(params[:import_file])
    redirect_to action: :index
  end

  def show
  end

  def destroy
  end

  def export
  end

end
