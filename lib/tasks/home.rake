#encoding: utf-8
require 'main_parse'
namespace :parse do
  task :home_language_courses => :environment do
    params = {:start_count => 1, :end_count => 9999999, :name => "campaign.xls", :log => false}
    params = params.merge(MainParse.new().get_params)
    parse = SchoolsController.new
    parse.school_parse(1, params)
    
  end
  
  task :home_universities => :environment do
    params = {:start_count => 1, :end_count => 9999999, :name => "campaign.xls", :log => false}
    params = params.merge(MainParse.new().get_params)
    parse = SchoolsController.new
    parse.school_parse(2, params)
    
  end
  
  task :home_private_schools => :environment do
    params = {:start_count => 1, :end_count => 9999999, :name => "campaign.xls", :log => false}
    params = params.merge(MainParse.new().get_params)
    parse = SchoolsController.new
    parse.school_parse(3, params)
    
  end
  
  task :home_lyceums => :environment do
    params = {:start_count => 1, :end_count => 9999999, :name => "campaign.xls", :log => false}
    params = params.merge(MainParse.new().get_params)
    parse = SchoolsController.new
    parse.school_parse(4, params)
    
  end
  
end