class CreateDay19112014s < ActiveRecord::Migration
  def change
    create_table :day19112014s do |t|
      t.string :name
      t.string :adres
      t.string :site
      t.string :phone
      t.string :email
      t.integer :type_number
      t.integer :page
      t.string :segment

      t.timestamps
    end
  end
end
