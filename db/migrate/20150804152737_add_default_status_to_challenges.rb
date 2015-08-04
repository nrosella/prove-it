class AddDefaultStatusToChallenges < ActiveRecord::Migration
  def change
    change_column_default(:challenges, :status, 'pending')
  end
end
