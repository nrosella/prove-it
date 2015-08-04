class RemoveChallengerEvidenceFromChallenges < ActiveRecord::Migration
  def change
    remove_column :challenges, :challenger_evidence_comment, :challenged_evidence_comment
  end
end
