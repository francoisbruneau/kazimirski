class AddScannedImageToPages < ActiveRecord::Migration
  def up
    add_attachment :pages, :scanned_image
  end

  def down
    remove_attachment :pages, :scanned_image
  end
end