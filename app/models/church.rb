#encoding: utf-8
require 'net/http'
require 'open-uri'

class Church < ActiveRecord::Base
  #attr_accessible :name, :tip, :phome, :site, :posta, :page, :mk_type_church
  
  def parse_main(params)
    yandex_url = {
      1 => 'http://yaca.yandex.ua/yca/cat/Society/Religion/Christianity/Orthodoxy/',
      2 => 'http://yaca.yandex.ua/yca/geo/Russia/cat/Society/Religion/Christianity/Catholicism/',
      3 => 'http://yaca.yandex.ua/yca/geo/Russia/cat/Society/Religion/Christianity/',
      4 => 'http://yaca.yandex.ua/yca/geo/Russia/cat/Society/Religion/Christianity/Churches/',
      5 => 'http://yaca.yandex.ua/yca/cat/Society/Religion/Christianity/Media/',
      6 => 'http://yaca.yandex.ua/yca/cat/Society/Religion/Judaism/',
      7 => 'http://yaca.yandex.ua/yca/geo/Russia/cat/Society/Religion/Islam/',
      8 => 'http://yaca.yandex.ua/yca/geo/Russia/cat/Society/Religion/Buddhism/',
      9 => 'http://yaca.yandex.ua/yca/geo/Russia/cat/Society/Religion/Hinduism/',
      10 => 'http://yaca.yandex.ua/yca/cat/Society/Religion/Atheism/',
      11 => 'http://yaca.yandex.ua/yca/cat/Society/Religion/Paganism/'
    }
    
    islam_love = {
      12 => [
        'http://www.islam-love.ru/catalog-mechetey-i-medrese?catid=34',
        'http://www.islam-love.ru/catalog-mechetey-i-medrese?catid=38',
        'http://www.islam-love.ru/catalog-mechetey-i-medrese?catid=39',
        'http://www.islam-love.ru/catalog-mechetey-i-medrese?catid=37',
        'http://www.islam-love.ru/catalog-mechetey-i-medrese?catid=36',
        'http://www.islam-love.ru/catalog-mechetey-i-medrese?catid=35',
        'http://www.islam-love.ru/catalog-mechetey-i-medrese?catid=33',
        'http://www.islam-love.ru/catalog-mechetey-i-medrese?catid=3'
      ]
    }
    
    yandex_url.each do |type, url|
      next if !params[:str].blank? && params[:str].to_i != type
      (params[:start_count]  .. params[:end_count]).each do |page|
        uri = URI.parse("#{url}/#{page}.html")
        uri.open
        res = uri.read
        doc = Nokogiri::HTML::Document.parse(res)
        #values = {:page => page, :type_church => type}
        values = {:type_church => type, :page => page}
        break if doc.css('.b-result__item').blank?
        doc.css('.b-result__item').each do |item|
          values[:name] = item.css('.b-result__name')[0].text
          info = item.css('.b-result__info')[1]
          unless info.blank?
            values[:phone] = info.children.first.text.strip
            values[:posta] = info.css('a').first.text.strip

          end
          values[:site] = item.css('.b-result__url').first.text.strip
          save_church(values)
        end
      end
    end
    
    islam_love.each do |type, urls|
      next if !params[:str].blank? && params[:str].to_i != type
      mk_type_church = 0
      urls.each do |url|
        mk_type_church += 1
        next if !params[:mk_type].blank? && params[:mk_type].to_i != mk_type_church
        (params[:start_count]  .. params[:end_count]).each do |page|
          url_page = page*50
          uri = URI.parse("#{url}&start=#{url_page}")
          uri.open
          res = uri.read
          doc = Nokogiri::HTML::Document.parse(res)
          values = {:type_church => type, :page => page, :mk_type_church => mk_type_church}
          next if doc.css('.sobi2Listing').first.css('td').first.text.blank?
          doc.css('.sobi2Listing').first.css('td').each do |item|
            values[:name] = item.css('a').first.text.strip
            values[:site] = item.css('a').first[:href]
            
            if strit = item.css('.sobi2Listing_field_street').first
              values[:posta] = strit.children.last.text.strip
            end
            if phone = item.css('.sobi2Listing_field_phone').first
              values[:phone] = phone.children.last.text.strip
            end
            save_church(values)
          end
        end
      end
    end
    
  end
  
  def save_church(values)
    if values[:name].blank?
      puts "Не могу найти имя"
      return
    end
    date = Time.now.strftime("%d.%m.%Y %H:%M") + "  "
    church = Church.find_by_name(values[:name])
    if church.blank?
      church = Church.new(values)
      if church.save
        text = "сохранена - #{values[:name]}"
        File.open("#{Rails.root.to_s}/tmp/sucess_church.txt", 'a') { |file| file.puts(date + text) }
      else
        text = "не могу сохранить - #{values[:name]}"
        File.open("#{Rails.root.to_s}/tmp/error_church.txt", 'a') { |file| file.puts(date + text) }
      end
    else
      if church.update_attributes(values)
        text = "обновлена - #{values[:name]}"
        File.open("#{Rails.root.to_s}/tmp/sucess_update_church.txt", 'a') { |file| file.puts(date + text) }
      else
        text = "не могу обновить - #{values[:name]}"
        File.open("#{Rails.root.to_s}/tmp/error_church.txt", 'a') { |file| file.puts(date + text) }
      end
    end
    puts text
  end
end
