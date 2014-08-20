class ChurchesController < ApplicationController
  
  def church_parse(params)
    Church.new().parse_main(params)
  end
end
