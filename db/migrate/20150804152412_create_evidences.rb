class CreateEvidences < ActiveRecord::Migration
  def change
    create_table :evidences do |t|
      t.integer :challenge_id
      t.integer :user_id
      t.string :comment
      t.timestamps null: false
    end
  end
end
