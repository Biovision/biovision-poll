# This migration comes from biovision_base_engine (originally 20170302000003)
class CreateTokens < ActiveRecord::Migration[5.0]
  def up
    unless Token.table_exists?
      create_table :tokens do |t|
        t.timestamps
        t.references :user, foreign_key: true, null: false, on_update: :cascade, on_delete: :cascade
        t.references :agent, foreign_key: true, on_update: :cascade, on_delete: :nullify
        t.inet :ip
        t.datetime :last_used, index: true
        t.boolean :active, default: true, null: false
        t.string :token
      end

      add_index :tokens, :token, unique: true
    end
  end

  def down
    if Token.table_exists?
      drop_table :tokens
    end
  end
end
