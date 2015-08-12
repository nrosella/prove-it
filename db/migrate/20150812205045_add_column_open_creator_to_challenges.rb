class AddColumnOpenCreatorToChallenges < ActiveRecord::Migration
  def change
    add_column :challenges, :open, :boolean, default: false
    add_column :challenges, :creator, :string
  end
end
