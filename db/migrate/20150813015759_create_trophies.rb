class CreateTrophies < ActiveRecord::Migration
  def change
    create_table :trophies do |t|
      t.integer :user_id
      t.integer :challenge_id
      t.text :photo_url

      t.timestamps null: false
    end
  end
end
