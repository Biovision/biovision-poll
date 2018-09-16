class RenameVoteFootprint < ActiveRecord::Migration[5.2]
  def up
    if column_exists?(:poll_votes, :footprint)
      rename_column :poll_votes, :footprint, :slug
    end
  end

  def down
    # No rollback needed
  end
end
