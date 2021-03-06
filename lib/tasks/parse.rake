#encoding: utf-8
require 'main_parse'
namespace :parse do
  task :save_app4all => :environment do
    start_count = 1
    end_count = 9999999
    name = "campaign.xls"
    log = false
    unless ARGV.nil?
      ARGV.each do |arg|
        case arg
        when /start/
          start_count = /\w+=(?<start>[\d]{1,})/.match(arg)[:start].to_i
        when /end/
          end_count = /\w+=(?<end>[\d]{1,})/.match(arg)[:end].to_i
        when /name/
          reg = /\w+=(?<name>[\wА-яёЁ]{1,})/.match(arg)
          if reg.nil?
            puts "Невозможно разпознать имя файла"
          else
            name = reg[:name] + '.xls'
          end
        when /log/
          log = true
        end
      end
    end
    parse = Apps4allController.new
    parse.add_cmp(start_count, end_count, name, log)
  end
  
  task :save_app4all_site => :environment do
    params = {:start_count => 1, :end_count => 9999999, :name => "campaign.xls", :log => false}
    params = params.merge(MainParse.new().get_params)
    parse = Apps4allsSiteController.new
    parse.add_cmp(params[:start_count], params[:end_count], params[:log])
  end
  
end