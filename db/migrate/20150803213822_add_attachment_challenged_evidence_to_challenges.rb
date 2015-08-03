class AddAttachmentChallengedEvidenceToChallenges < ActiveRecord::Migration
  def self.up
    change_table :challenges do |t|
      t.attachment :challenged_evidence
    end
  end

  def self.down
    remove_attachment :challenges, :challenged_evidence
  end
end
