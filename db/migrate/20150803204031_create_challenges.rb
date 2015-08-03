class CreateChallenges < ActiveRecord::Migration
  def change
    create_table :challenges do |t|

      t.timestamps null: false
    end
  end
end
