#encoding: utf-8

module ChurchesHelper
  
  def get_type_cherch_rus(type)
    case type
    when 1
      return 'Православие'
    when 2
      return 'Католичество'
    when 3
      return 'Протестантизм'
    when 4
      return 'Храмы и монастыри'
    when 5
      return 'Христианские СМИ'
    when 6
      return 'Иудаизм'
    when 7
      return 'Ислам'
    when 8
      return 'Буддизм'
    when 9
      return 'Индуизм'
    when 10
      return 'Атеизм'
    when 11
      return 'Язычество'
    when 12 
      return 'Мечети'
    end
  end
end
