#encoding: utf-8
class Apps4allsSite < ActiveRecord::Base
  
  def save_site(res, page, log = false)
    doc = Nokogiri::HTML::Document.parse(res.body)
    trs = doc.css('tr')
    count = 0
    while true
      if trs.empty?
        count += 1
        break if count > 10
        next
      end
      trs.shift
      trs.each do |tr|
        params = {:page=> page}
        params[:url_site] = tr.css('a')[0]['href']
        params[:cmp_name] = tr.css('a')[0].text
        params[:ident] = tr.css('td[class="col_01"]')[0].text
        
        save_cmp_site(params)
        puts params if log
      end
      puts "Закончил #{page} страницу"
      break
    end
  end
  
  def save_cmp_site(params)
    if Apps4allsSite.find_by_ident(params[:ident]).blank?
      site = Apps4allsSite.new(params)
      if site.save
        puts "№ #{params[:ident]} -- успешно сохранен -- #{params[:cmp_name]}"
      else
        pust "№ #{params[:ident]} -- не могу сохранить -- #{params[:cmp_name]}"
      end
    else
      puts "№ #{params[:ident]} -- уже сохранено -- #{params[:cmp_name]}"
    end
  end
end
