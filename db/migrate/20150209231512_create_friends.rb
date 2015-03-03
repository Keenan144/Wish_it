class CreateFriends < ActiveRecord::Migration
  def change
    create_table :friends do |t|
      t.integer :friender_id
      t.integer :friended_id
    end
  end
end


