class ChurchesController < ApplicationController
  
  def show_all
    if params[:type]
      @churches = Church.where(:type_cherch => params[:type])
    else
      @churches = Church.all.order("type_church DESC")
    end
    respond_to do |format|
      format.html { render 'churches/show' }
      format.xls { render 'churches/show' }
    end
  end
  
  def church_parse(params)
    Church.new().parse_main(params)
  end
end
