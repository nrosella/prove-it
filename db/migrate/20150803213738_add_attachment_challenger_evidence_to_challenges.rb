class AddAttachmentChallengerEvidenceToChallenges < ActiveRecord::Migration
  def self.up
    change_table :challenges do |t|
      t.attachment :challenger_evidence
    end
  end

  def self.down
    remove_attachment :challenges, :challenger_evidence
  end
end
