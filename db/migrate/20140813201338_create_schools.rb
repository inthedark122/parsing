class CreateSchools < ActiveRecord::Migration
  # Название учебного заведения
  # Тип учебного заведения (курсы, част. школа, лицей, вуз)
  # Сайт
  # Телефон г. Москва
  # Почта (если есть)
  def change
    create_table :schools do |t|
      t.string :name
      t.integer :type_school
      t.string :site
      t.string :phone 
      t.string :posta
      
      t.timestamps
    end
  end
end
