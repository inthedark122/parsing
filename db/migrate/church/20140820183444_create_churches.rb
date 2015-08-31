class CreateChurches < ActiveRecord::Migration
  def change
    create_table :churches do |t|
      t.string :name
      t.string :site
      t.string :phone
      t.string :posta
      
      t.integer :page
      t.integer :type_church
      t.integer :mk_type_church
      t.timestamps
    end
  end
end
