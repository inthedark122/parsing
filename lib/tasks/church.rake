#encoding: utf-8
require 'main_parse'
namespace :parse do
  task :church_parse => :environment do
    params = {:start_count => 0, :end_count => 9999999, :name => "campaign.xls", :log => false}
    params = params.merge(MainParse.new().get_params)
    parse = ChurchesController.new
    parse.church_parse(params)
  end
  
end