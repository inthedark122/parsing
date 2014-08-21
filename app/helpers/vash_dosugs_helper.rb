#encoding: utf-8
module VashDosugsHelper
  
  def get_type_item_rus_by_vash_dosug(site_id)
    case site_id
    when  101 
      return 'кинотеатр'
    when 102 
      return 'театр'
    when 103 
      return 'музей'
    end
  end
end
