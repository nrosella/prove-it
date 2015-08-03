class CreateChallenges < ActiveRecord::Migration
  def change
    create_table :challenges do |t|
      t.string :title
      t.text :description
      t.datetime :challenge_start
      t.datetime :challenge_end
      t.integer :challenge_duration
      t.integer :voting_duration
      t.integer :challenger_id
      t.integer :challenged_id
      t.string :status
      t.text :challenger_evidence_comment
      t.text :challenged_evidence_comment


      t.timestamps null: false
    end
  end
end
