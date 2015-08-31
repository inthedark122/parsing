class Day19112014Controller < ApplicationController


  def show
    @data = Day19112014.where(:type_number => params[:id])
  end

  def getXls
    names = Day19112014::NAMES
    id = names.select{|key, val| val == params[:id] }.keys.first
    @data = Day19112014.where(:type_number => id)
    render "show"
  end
end
