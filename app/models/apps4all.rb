# encoding: utf-8
require 'net/http'
class Apps4all < ActiveRecord::Base
  #attr_accessible :name, :type, :country, :city, :site, :ios, :android, :windows
  
  def load_site(start_page = 0, end_page = 99999)
    (start_page .. end_page).each do |page|
      uri = URI("http://apps4all.ru/developers/rating?page=#{page}")
      while true
        begin
          res = Net::HTTP.get_response(uri)
          break
        rescue
          puts "Не могу загрузить сайт"
          sleep 10
        end
      end
      doc = Nokogiri::HTML::Document.parse(res.body)
      trs = doc.css('tr')
      break if trs.empty?
      trs.shift
      trs.each do |tr|
        cmp = parse_page(tr)
        puts cmp if @log
      end
      puts "Закончил #{page} страницу"
    end
  end
  
  def parse_page(tr)
    cmp = {:ios => 0, :android => 0, :windows => 0}
    uri_cmp = URI('http://apps4all.ru' + tr.css('a')[0]['href'])
    while true
      begin
        res_cmp = Net::HTTP.get_response(uri_cmp)
        break
      rescue
        puts "Не могу загрузить сайт"
        sleep 10
      end
    end
    doc_cmp = Nokogiri::HTML::Document.parse(res_cmp.body)
    header = doc_cmp.css("div[class='header']")

    cmp[:name] = header.css('strong').text.strip
    cmp[:type_company] = header.css('b').text
    header.css('p').each do |p|
      case p.text
      when /^страна/i
        cmp[:country] = p.css('span').text
      when /^город/i
        cmp[:city] = p.css('span').text
      when /^сайт/i
        cmp[:site] = p.css('a').text
      when /^платформы/i
        imgs = p.css('img')
        imgs.each do |img|
          case img['src']
          when /xi_01/i
            cmp[:ios] = 1
          when /xi_02/i
            cmp[:android] = 1
          when /xi_03/i
            cmp[:windows] = 1
          end
        end

      end
    end
    save_company(cmp)
    return cmp
  end
  
  def save_company(cmp)
    if Apps4all.find_by_name(cmp[:name]).blank?
      app4all = Apps4all.new(cmp)
      if app4all.save
        puts "Кампания успешно сохранена - #{cmp[:name]}"
      else
        puts "Невозможно сохранить кампанию - #{cmp[:name]}"
      end
    else
      puts "Кампания уже создана - #{cmp[:name]}"
    end
  end
end
