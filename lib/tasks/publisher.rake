#encoding: utf-8
require 'main_parse'
namespace :parse do
  task :publisher_parse => :environment do
    params = {:start_count => 0, :end_count => 9999999, :name => "campaign.xls", :log => false}
    params = params.merge(MainParse.new().get_params)
    parse = PublishersController.new
    parse.parse_data(params)
  end
  
end