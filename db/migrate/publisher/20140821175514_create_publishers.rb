class CreatePublishers < ActiveRecord::Migration
  def change
    create_table :publishers do |t|   
      t.string :name
      t.string :site
      t.string :phone
      t.string :posta
      
      t.integer :page
      t.integer :site_id
      t.timestamps
    end
  end
end
