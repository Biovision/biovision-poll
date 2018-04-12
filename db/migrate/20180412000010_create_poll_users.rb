class CreatePollUsers < ActiveRecord::Migration[5.2]
  def up
    unless PollUser.table_exists?
      create_table :poll_users do |t|
        t.timestamps
        t.references :poll, null: false, foreign_key: { on_update: :cascade, on_delete: :cascade }
        t.references :user, null: false, foreign_key: { on_update: :cascade, on_delete: :cascade }
      end
    end

    unless column_exists? :polls, :exclusive
      add_column :polls, :exclusive, :boolean, default: false, null: false
    end
  end

  def down
    if PollUser.table_exists?
      drop_table :poll_users
    end
  end
end
