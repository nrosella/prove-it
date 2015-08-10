class AddColumnExplainationToChallenges < ActiveRecord::Migration
  def change
  	add_column :challenges, :explaination, :string
  end
end
