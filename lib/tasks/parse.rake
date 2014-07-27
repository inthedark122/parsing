#encoding: utf-8
namespace :parse do
  task :save_app4all => :environment do
    start_count = 0
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
end