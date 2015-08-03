class CreateVotes < ActiveRecord::Migration
  def change
    create_table :votes do |t|
      t.integer :challenge_id
      t.integer :user_id
      t.integer :recipient_id 

      t.timestamps null: false
    end
  end
end
