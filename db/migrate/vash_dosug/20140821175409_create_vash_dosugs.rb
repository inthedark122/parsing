class CreateVashDosugs < ActiveRecord::Migration
  def change
    create_table :vash_dosugs do |t|
      t.string :name
      t.string :site
      t.string :phone
      t.string :posta
      t.integer :type_item
      
      t.integer :page
      t.integer :site_id
      t.timestamps
    end
  end
end
