class CreateWishes < ActiveRecord::Migration
  def change
    create_table :wishes do |t|
      t.string  :content
      t.string  :url
      t.string  :priority
      t.integer :user_id

      t.timestamps
    end
  end
end