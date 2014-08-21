class VashDosugsController < ApplicationController
  
  def show
    if params[:type]
      @items = VashDosug.where(:type_cherch => params[:type])
    else
      @items = VashDosug.all
    end
    respond_to do |format|
      format.html { render 'show' }
      format.xls { render 'show' }
    end
  end
  
  def parse_data(params)
    VashDosug.new().parse_main(params)
  end
end
