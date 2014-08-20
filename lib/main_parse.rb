#encoding: utf-8
class MainParse
  
  def get_params
    start_count = 1
    end_count = 9999999
    unless ARGV.nil?
      result = {}
      ARGV.each do |arg|
        case arg
        when /start/
          start_count = /\w+=(?<start>[\d]{1,})/.match(arg)[:start].to_i
          result[:start_count] = start_count
        when /end/
          end_count = /\w+=(?<end>[\d]{1,})/.match(arg)[:end].to_i
          result[:end_count] = end_count
        when /name/
          reg = /\w+=(?<name>[\wА-яёЁ]{1,})/.match(arg)
          if reg.nil?
            puts "Невозможно разпознать имя файла"
          else
            name = reg[:name] + '.xls'
            result[:name] = name
          end
        when /log/
          log = true
          result[:log] = true
        end
      end
      return result
    end
    return {}
  end
end