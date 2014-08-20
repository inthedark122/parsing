# encoding: utf-8
class Apps4allController < ApplicationController
  
  def show
    @posts = Apps4all.all
    respond_to do |format|
      format.html { render 'apps4all/show' }
      format.xls { render 'apps4all/show' }
    end
  end
  
  
  def add_cmp(start_count, end_count, name, log)
    apps4all = Apps4all.new
    apps4all.load_site(start_count, end_count, log)
  end

end
