#encoding: utf-8

class Day19112014 < ActiveRecord::Base
  require 'net/http'
  require 'open-uri'
  #attr_accessible :name, :adres, :site, :phone , :email  , :type_number , :page , :segment
  #types
  TYPE_LAKI_KRASKI = 1 # Лаки краски
  NAMES = {
    1 => 'Лаки и краски',
    111 => 'Полы',
    112 => 'Потолки',
    113 => 'Краски, сухие смеси, стройхимия',
    114 => 'Кирпич и керамика',
    115 => 'Фасады / Наружная отделка',
    116 => 'Обои / Внутренняя отделка стен',
    2 => 'Агентства'
  }

  def laki_kraski
    (0 .. 23).each do |page|
      uri = URI.parse("https://yaca.yandex.by/yca/cat/Business/Construction/Building_Supplies/Dyes/#{page}.html")
      uri.open
      res = uri.read
      doc = Nokogiri::HTML::Document.parse(res)
      doc.css('.b-result__item').each do |item|
        value = {
          :type_number => TYPE_LAKI_KRASKI,
          :segment => NAMES[TYPE_LAKI_KRASKI]
        }
        value[:name] = item.css('.b-result__name')[0].text.strip
        #value[:site] = item.css('.b-result__name')[0].href.strip
        info = item.css('.b-result__info')[1]
        unless info.blank?
          value[:phone] = info.children.first.text.strip
          value[:adres] = info.css('a').first.text.strip
        end
        value[:site] = item.css('.b-result__url').first.text.strip
        _save(value)
      end
    end
  end

  def poli()
    default_value = {:type_number => 111, :segment => "Полы"}
    _save_mail(3, default_value, 'http://list.mail.ru/32351/1/0_1_0_')
  end

  def potolki()
    default_value = {:type_number => 112, :segment => "Потолки"}
    _save_mail(2, default_value, 'http://list.mail.ru/32852/1/0_1_0_')
  end

  def kraski_smesi()
    default_value = {:type_number => 113, :segment => "Краски, сухие смеси, стройхимия"}
    _save_mail(4, default_value, 'http://list.mail.ru/32642/1/0_1_0_')
  end

  def kirpich_keramika()
    default_value = {:type_number => 114, :segment => "Кирпич и керамика"}
    _save_mail(3, default_value, 'http://list.mail.ru/32286/1/0_1_0_')
  end

  def facad()
    default_value = {:type_number => 115, :segment => "Фасады / Наружная отделка"}
    _save_mail(2, default_value, 'http://list.mail.ru/33141/1/0_1_0_')
  end

  def oboi()
    default_value = {:type_number => 116, :segment => "Обои / Внутренняя отделка стен"}
    _save_mail(2, default_value, 'http://list.mail.ru/32283/1/0_1_0_')
  end

  def _save_mail(max_count, default_value, adres)
    (1 .. max_count).each do |page|
      uri = URI("#{adres}#{page}.html")
      #uri.open
      #res = uri.read
      res = Net::HTTP.get_response(uri)
      doc = Nokogiri::HTML::Document.parse(res.body)

      set = false
      value = default_value
      #p doc.css('.lft').css('tr')
      #return
      doc.css('.lft').css('tr').each do |tr|
        h = tr.css('.rez-h')
        if (set)
          desc = tr.css('.rez-descr')
          if d = desc[0]
            value[:site] = d.css('a').first.text.strip
          end
          if d = desc[1]
            value[:adres] = d.css('a')[1].text.strip
            value[:adres] = d.css('a')[0].text.strip if value[:adres].blank?
          end
          _save(value)
          value = default_value
          set = false
        end
        if (!h.blank? && !set)
          next if h.children.count > 3
          value[:name] = h.css('a').text.strip
          set = true
        end
      end
    end
  end

  def eip()
    (1 .. 161).each do |page|
      uri = URI("http://www.eip.ru/agency//#{page}")
      res = Net::HTTP.get_response(uri)
      res.body.force_encoding("windows-1251")
      res.body.encode!
      doc = Nokogiri::HTML::Document.parse(res.body)
      p "open #{page}"
      doc.css('.smallcard').each do |item|
        value = {:type_number => 2, :segment => "Агентства недвижимости"}
        trs = item.css('tr')
        value[:name] = trs[0].text.strip
        txt = trs[1].text #.force_encoding("utf-8")
        value[:phone] = Regexp.last_match[:phone].strip if txt =~ /Телефон:\ (?<phone>[\d() \u00A0]{1,})/imx
        value[:adres] = Regexp.last_match[:adres].strip if txt =~ /Адрес:\ (?<adres>[\wА-яЁё (),.-]{1,})/imx
        value[:site] =  Regexp.last_match[:site].strip if txt =~ /Домашняя\ страница:\ (?<site>[\w.]{1,})/imx
        value[:email] = Regexp.last_match[:email].strip if txt =~ /EMail:\ (?<email>[\wА-яЁё(),. @-]{1,})/imx
        _save(value)
      end
    end
  end

  def _save(values)
    model = Day19112014
    if values[:name].blank?
      puts "Не могу найти имя"
      return
    end
    school = model.find_by_name(values[:name])
    if school.blank?
      school = model.new(values)
      if school.save
        puts "сохранена - #{values[:name]}"
      else
        puts "не могу сохранить - #{values[:name]}"
      end
    else
      if school.update_attributes(values)
        puts "обновлена - #{values[:name]}"
      else
        puts "не могу обновить - #{values[:name]}"
      end
    end
  end
end
