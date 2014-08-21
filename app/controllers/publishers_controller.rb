class PublishersController < ApplicationController
  
  def show
    if params[:type]
      @items = Publisher.where(:type_cherch => params[:type])
    else
      @items = Publisher.all.order('site_id ASC').order('page ASC')
    end
    respond_to do |format|
      format.html { render 'show' }
      format.xls { render 'show' }
    end
  end
  
  def parse_data(params)
    Publisher.new().parse_main(params)
  end
end
