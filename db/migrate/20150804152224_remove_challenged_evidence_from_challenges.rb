class RemoveChallengedEvidenceFromChallenges < ActiveRecord::Migration
  def change
    remove_column :challenges, :challenged_evidence_comment
  end
end
