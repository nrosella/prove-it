class RemoveChallengeStartFromChallenges < ActiveRecord::Migration
  def change
    remove_column :challenges, :challenge_start, :challenger_evidence_comment, :challenged_evidence_comment
  end
end
