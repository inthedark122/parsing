#encoding: utf-8
class School < ActiveRecord::Base
  require 'net/http'
  require 'open-uri'
  # 1 - Языковые курсы - language_courses_parse
  # 2 - Вузы - universities_parse
  # 3 - Частные школы - private_schools_parse
  # 4 - Лицеи - lyceums_parse
  #attr_accessible :name, :type_school, :phome, :site, :posta
  
  def language_courses_parse(params)
    (params[:start_count] .. params[:end_count]).each do |page|
      uri = URI.parse("http://yaca.yandex.ua/yca/geo/Russia/Central/Moscow_District/Moscow/cat/Science/Advanced_Training/Languages/#{page}.html")
      uri.open # do |f|    end
      res = uri.read
      doc = Nokogiri::HTML::Document.parse(res)
      doc.css('.b-result__item').each do |vuz|
        values = {:type_school => 1}
        values[:name] = vuz.css('.b-result__name')[0].text
        info = vuz.css('.b-result__info')[1]
        unless info.blank?
          values[:phone] = info.children.first.text.strip
          values[:posta] = info.css('a').first.text.strip
          
        end
        values[:site] = vuz.css('.b-result__url').first.text.strip
        
        save_school(values)
      end
    end
  end
  
  def universities_parse(params)
    main = 'http://vuz.edunetwork.ru'
    (params[:start_count] .. params[:end_count]).each do |i|
      uri = URI("#{main}/ajax.bin")
      params_uri = {:act=> 'moreVuz', :page=>i, :url=>"#{main}/77/?page=#{i}&level=first"}
      res = Net::HTTP.post_form(uri, params_uri)
      doc = Nokogiri::HTML::Document.parse(res.body)
      doc.css('.block').each do |block|
        values = {:type_school => 2, :name => block.css('a')[0].text, :page=>i}
        href = block.css('a')[0][:href]
        uri_block = URI("#{main}/#{href}")
        res_block = Net::HTTP.get_response(uri_block)
        doc_block = Nokogiri::HTML::Document.parse(res_block.body)
        contact_box = doc_block.css('.contact-box')[0]
        columns = contact_box.css('.columns')[0]
        
        col_posta = columns.css('.col01')[0].css('.frame').text
        unless col_posta.blank?
          values[:posta] = col_posta.gsub('<br>', '\n')
        end
        
        col_phones = columns.css('.col02')[0].css('a')
        if col_phones.blank?
          phone = columns.css('.col02')[0].css('.frame').text
        else
          phone = ''
          col_phones.each do |col_phone|
            phone += col_phone.text
          end
        end
        values[:phone] = phone
        
        col_site = columns.css('.col03')[0].css('a')
        unless col_site.blank?
          values[:site] = col_site[0][:href]
        end
        save_school(values)
      end
    end
  end
  
  def private_schools_parse(params)
    main = 'http://www.schoolotzyv.ru'
    uri = URI("#{main}/chastnye-shkoly-moskvy")
    res = Net::HTTP.get_response(uri)
    doc = Nokogiri::HTML::Document.parse(res.body)
    doc.css('li').each do |p|
      values = {:type_school => 3}
      a = p.css('a')
      next if a.blank?
      next unless a[0]['href'] =~ /private-schools/i
      uri = URI("#{main}#{a[0]['href']}")
      res = Net::HTTP.get_response(uri)
      doc = Nokogiri::HTML::Document.parse(res.body)
      name = doc.css('h1[itemprop="name"]')
      unless name.css('span').blank?
        name = name.css('span').text
      else
        name = name.text
      end
      if name.blank?
        name = a[0].text
        puts a[0].text
      end
      values[:name] = name
      page = doc.css('.art-PostContent').first
      if page.to_s =~ /Телефоны:\s*<\/span>\s*(?<phone>[\d(),. -]{1,})\n*(<\/br>){0,}/im
        values[:phone] = Regexp.last_match(:phone)
      end
      if page.to_s =~ /Сайт: *<\/span> *<a([\wА-яЁё\\ ="':\/.?-]{1,})>(?<site>[\w\/А-яЁё.-]{1,})<\/a>/im
        values[:site] = Regexp.last_match(:site)
      end
      if page.to_s =~ /Директор:\s*<\/span>\s*(?<director>[\wА-яЁё(),. -]{1,})\n*(<\/br>){0,}/im
        values[:director] = Regexp.last_match(:director)
      end
      if page.to_s =~ /Адрес:\s*<\/span>\s*(?<posta>[\wА-яЁё(),. -]{1,})\n*(<\/br>){0,}/im
        values[:posta] = Regexp.last_match(:posta)
      end
      save_school(values)
    end
  end 
  
  def lyceums_parse(params)
    main = 'http://www.schoolotzyv.ru'
    uri = URI("#{main}/licei")
    res = Net::HTTP.get_response(uri)
    doc = Nokogiri::HTML::Document.parse(res.body)
    table = doc.css('#cattable').first
    doc.xpath('//table[@id="cattable"]/tr').each do |p|
      values = {:type_school => 3}
      a = p.css('a')
      #next if a.blank?
      uri = URI("#{main}#{a[0]['href']}")
      res = Net::HTTP.get_response(uri)
      doc = Nokogiri::HTML::Document.parse(res.body)
      name = doc.css('h1[itemprop="name"]')
      unless name.css('span').blank?
        name = name.css('span').text
      else
        name = name.text
      end
      if name.blank?
        name = a[0].text
        puts a[0].text
      end
      values[:name] = name
      page = doc.css('.art-PostContent').first
      if page.to_s =~ /Телефоны:\s*<\/span>\s*(?<phone>[\d(),. -]{1,})\n*(<\/br>){0,}/im
        values[:phone] = Regexp.last_match(:phone)
      end
      if page.to_s =~ /Сайт: *<\/span> *<a([\wА-яЁё\\ ="':\/.?-]{1,})>(?<site>[\w\/А-яЁё.-]{1,})<\/a>/im
        values[:site] = Regexp.last_match(:site)
      end
      if page.to_s =~ /Директор:\s*<\/span>\s*(?<director>[\wА-яЁё(),. -]{1,})\n*(<\/br>){0,}/im
        values[:director] = Regexp.last_match(:director)
      end
      if page.to_s =~ /Адрес:\s*<\/span>\s*(?<posta>[\wА-яЁё(),. -]{1,})\n*(<\/br>){0,}/im
        values[:posta] = Regexp.last_match(:posta)
      end
      save_school(values)
    end
  end
  
  def save_school(values)
    if values[:name].blank?
      puts "Не могу найти имя"
      return
    end
    school = School.find_by_name(values[:name])
    if school.blank?
      school = School.new(values)
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
