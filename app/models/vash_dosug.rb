#encoding: utf-8
require 'net/http'
require 'open-uri'

class VashDosug < ActiveRecord::Base
  #attr_accessible :name, :phome, :site, :posta, :page
  # --type
  # 101 - (кинотеатр)
  # 102 - (театр)
  # 103 - (музей)
  
  def parse_main(params)
    #yandex_url = {}
    
    islam_love = {
      101 => 'http://www.vashdosug.ru/msk/cinema/places/',
      102 => 'http://www.vashdosug.ru/msk/theatre/places/',
      103 => 'http://www.vashdosug.ru/msk/exhibition/places/'
    }
    if params[:str].blank?
      parse_vashdosug(islam_love[101], 101, params)
      parse_vashdosug(islam_love[102], 102, params)
      parse_vashdosug(islam_love[103], 103, params)
    else
      case params[:str].to_i
      when 101
        parse_vashdosug(islam_love[101], 101, params)
      when 102
        parse_vashdosug(islam_love[102], 102, params)
      when 103
        parse_vashdosug(islam_love[103], 103, params)
      end
    end
  end
  
  def parse_vashdosug(url, site_id, params)
    return if !params[:str].blank? && params[:str].to_i != site_id
    (params[:start_count]  .. params[:end_count]).each do |page|
      uri = URI.parse("#{url}page#{page}/byrating/za/")
      res = Net::HTTP.get_response(uri)
      doc = Nokogiri::HTML::Document.parse(res.body)
      break if doc.css('.numList').text.strip.blank?
      doc.css('.numList').first.css('article').each do |item|
        url_item = item.css('.h3').first.children.first[:href] 
        uri_item = URI.parse("http://www.vashdosug.ru/#{url_item}")
        res_item = Net::HTTP.get_response(uri_item)
        doc_item = Nokogiri::HTML::Document.parse(res_item.body)
        values = {:site_id => site_id, :page => page}
        values[:name] = doc_item.css('h1[itemprop="name"]').first.text
        head_desc = doc_item.css('.head-desc dl').first().css('dd')
        is_phone = true
        while true # head_desc.last.blank? && ( !head_desc.last.attributes['itemprop'].blank? && head_desc.last.attributes['itemprop'].value != 'telephone')
          unless head_desc.last.blank?
            unless head_desc.last.attributes['itemprop'].blank?
              if head_desc.last.attributes['itemprop'].value == 'telephone'
                break 
              end
            end
            if !head_desc.last.children.first.blank? && !head_desc.last.children.first.attributes.blank? && 
               !head_desc.last.children.first.attributes['data-url'].blank? && !head_desc.last.children.first.attributes['data-url'].value.blank?
              is_phone = false
              break
            end
          end
          break if head_desc.blank?
          head_desc.pop
        end
        if head_desc.blank?
          text = " Не могу получить данные по сайт #{values[:name]}, где page = #{page}, site_id = #{site_id}"
          File.open("#{Rails.root.to_s}/tmp/very_error_vash_dosug.txt", 'a') { |file| file.puts(Time.now.strftime("%d.%m.%Y %H:%M") + text ) }
          save_item(values)
          next
        end
        if is_phone
          values[:phone] = head_desc.last.text
          head_desc.pop
        end
        values[:site] = head_desc.last.children.first.attributes['data-url'].value if !head_desc.last.text.blank? && !head_desc.last.children.first.attributes['data-url'].blank?
        save_item(values)
      end
    end
  end
  
  def parse_ya(yandex_url, params)
    yandex_url.each do |type, url|
      next if !params[:str].blank? && params[:str].to_i != type
      (params[:start_count]  .. params[:end_count]).each do |page|
        uri = URI.parse("#{url}/#{page}.html")
        uri.open
        res = uri.read
        doc = Nokogiri::HTML::Document.parse(res)
        #values = {:page => page, :type_vash_dosug => type}
        values = {:type_vash_dosug => type, :page => page}
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
  
  def save_item(values)
    if values[:name].blank?
      puts "Не могу найти имя"
      return
    end
    date = Time.now.strftime("%d.%m.%Y %H:%M") + "  "
    vash_dosug = VashDosug.where(:name => values[:name], :page=> values[:page], :site_id => values[:site_id]).first
    if vash_dosug.blank?
      vash_dosug = VashDosug.new(values)
      if vash_dosug.save
        text = "сохранена - #{values[:name]}"
        File.open("#{Rails.root.to_s}/tmp/sucess_vash_dosug.txt", 'a') { |file| file.puts(date + text) }
      else
        text = "не могу сохранить - #{values[:name]}"
        File.open("#{Rails.root.to_s}/tmp/error_vash_dosug.txt", 'a') { |file| file.puts(date + text) }
      end
    else
      if vash_dosug.update_attributes(values)
        text = "обновлена - #{values[:name]}"
        File.open("#{Rails.root.to_s}/tmp/sucess_update_vash_dosug.txt", 'a') { |file| file.puts(date + text) }
      else
        text = "не могу обновить - #{values[:name]}"
        File.open("#{Rails.root.to_s}/tmp/error_vash_dosug.txt", 'a') { |file| file.puts(date + text) }
      end
    end
    puts text
  end
end
