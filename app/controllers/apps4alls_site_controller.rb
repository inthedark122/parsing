#encoding: utf-8
require 'net/http'
class Apps4allsSiteController < ApplicationController
  
  def add_cmp(start_page, end_page, log)
    apps4alls_site = Apps4allsSite.new
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
      Apps4allsSite.new().save_site(res, page)
    end
  end
end
