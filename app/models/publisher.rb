#encoding: utf-8
require 'net/http'
require 'open-uri'

class Publisher < ActiveRecord::Base
    #attr_accessible :name, :tip, :phome, :site, :posta, :page, :mk_type_publisher
  
  def parse_main(params)
    yandex_url = {
      1 => 'http://yaca.yandex.by/yca/geo/Russia/cat/Business/Production/Consumables/Publishing/'
    }
    
    other_url = {
      101 => 'http://bookvall.ru/publishers_ru.php'
    }
    
    parse_bookvall(other_url[101], 101, params)
    
    yandex_url.each do |site_id, url|
      next if !params[:str].blank? && params[:str].to_i != site_id
      (params[:start_count]  .. params[:end_count]).each do |page|
        uri = URI.parse("#{url}/#{page}.html")
        uri.open
        res = uri.read
        doc = Nokogiri::HTML::Document.parse(res)
        values = {:site_id => site_id, :page => page}
        break if doc.css('.b-result__item').blank?
        doc.css('.b-result__item').each do |item|
          values[:name] = item.css('.b-result__name')[0].text
          info = item.css('.b-result__info')[1]
          unless info.blank?
            values[:phone] = info.children.first.text.strip
            values[:posta] = info.css('a').first.text.strip

          end
          values[:site] = item.css('.b-result__url').first.text.strip
          save_item(values)
        end
      end
    end
  end
  
  def parse_bookvall(url, site_id, params)
    return if !params[:str].blank? && params[:str].to_i != site_id
    uri = URI.parse(url)
    res = Net::HTTP.get_response(uri)
    #uri.open
    #res = uri.read
    doc = Nokogiri::HTML::Document.parse(res.body)
    next_site = false
    values = {}
    doc.css('#colTwo').children.each do |block|
      if next_site
        values[:site] = block.text.gsub(/^.*(?=http)/, '').strip
        next_site = false
        save_item(values)
      end
      if block.name == 'h3'
        next_site = true
        values = {:site_id => site_id, :page => 0, :name => block.children.children.text.strip}
      end
    end
    
    
  end
  
  def save_item(values)
    if values[:name].blank?
      puts "Не могу найти имя"
      return
    end
    date = Time.now.strftime("%d.%m.%Y %H:%M") + "  "
    publisher = Publisher.where(:name => values[:name], :page=> values[:page]).first
    if publisher.blank?
      publisher = Publisher.new(values)
      if publisher.save
        text = "сохранена - #{values[:name]}"
        File.open("#{Rails.root.to_s}/tmp/sucess_publisher.txt", 'a') { |file| file.puts(date + text) }
      else
        text = "не могу сохранить - #{values[:name]}"
        File.open("#{Rails.root.to_s}/tmp/error_publisher.txt", 'a') { |file| file.puts(date + text) }
      end
    else
      if publisher.update_attributes(values)
        text = "обновлена - #{values[:name]}"
        File.open("#{Rails.root.to_s}/tmp/sucess_update_publisher.txt", 'a') { |file| file.puts(date + text) }
      else
        text = "не могу обновить - #{values[:name]}"
        File.open("#{Rails.root.to_s}/tmp/error_publisher.txt", 'a') { |file| file.puts(date + text) }
      end
    end
    puts text
  end
  
end
