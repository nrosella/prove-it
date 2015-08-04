class RemoveChallengerIdChallengedIdFromChallenges < ActiveRecord::Migration
  def change
    remove_column :challenges, :challenger_id
    remove_column :challenges, :challenged_id
  end
end
