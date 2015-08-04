class CreateUserChallenges < ActiveRecord::Migration
  def change
    create_table :user_challenges do |t|
      t.integer :user_id
      t.integer :challenge_id
      t.boolean :admin, default: false

      t.timestamps null: false
    end
  end
end
