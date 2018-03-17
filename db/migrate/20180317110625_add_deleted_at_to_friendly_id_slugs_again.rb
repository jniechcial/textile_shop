class AddDeletedAtToFriendlyIdSlugsAgain < ActiveRecord::Migration[5.1]
  def change
    add_column :friendly_id_slugs, :deleted_at, :datetime
  end
end
