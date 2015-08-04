class AddAttachmentPhotoToEvidences < ActiveRecord::Migration
  def self.up
    change_table :evidences do |t|
      t.attachment :photo
    end
  end

  def self.down
    remove_attachment :evidences, :photo
  end
end
