#encoding: utf-8
module SchoolHelper
  def get_type(type)
    case type
    when 1
      return "Языковые курсы"
    when 2 
      return "Вузы"
    when 3 
      return "Частные школы"
    when 4 
      "Лицеи"
    end
  end
end
