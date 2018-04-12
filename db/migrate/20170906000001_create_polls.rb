class CreatePolls < ActiveRecord::Migration[5.1]
  def up
    unless Poll.table_exists?
      create_table :polls do |t|
        t.timestamps
        t.references :user, null: false, foreign_key: { on_update: :cascade, on_delete: :cascade }
        t.integer :region_id, index: true
        t.references :agent, foreign_key: { on_update: :cascade, on_delete: :nullify }
        t.inet :ip
        t.integer :pollable_id
        t.string :pollable_type
        t.boolean :visible, default: true, null: false
        t.boolean :active, default: true, null: false
        t.boolean :show_on_homepage, default: true, null: false
        t.boolean :anonymous_votes, default: true, null: false
        t.boolean :open_results, default: true, null: false
        t.boolean :exclusive, default: false, null: false
        t.date :end_date
        t.integer :poll_questions_count, default: 0, null: false
        t.integer :comments_count, default: 0, null: false
        t.string :image
        t.string :name
        t.string :description
      end

      if Gem.loaded_specs.key?('biovision-regions')
        add_foreign_key :polls, :regions, column: :region_id, on_update: :cascade, on_delete: :cascade
      end

      create_privileges
    end
  end

  def down
    if Poll.table_exists?
      drop_table :polls
    end
  end

  def create_privileges
    Privilege.create(slug: 'chief_poll_manager', name: 'Главный управляющий опросами')
    chief = Privilege.find_by!(slug: 'chief_poll_manager')

    Privilege.create(
      slug: 'poll_manager',
      name: 'Управляющий опросами центра',
      parent_id: chief
    )
    Privilege.create(
      slug: 'regional_poll_manager',
      name: 'Управляющий опросами региона',
      parent_id: chief,
      regional: true
    )

    PrivilegeGroup.create(slug: 'poll_managers', name: 'Управляющие опросами')
    group = PrivilegeGroup.find_by!(slug: 'poll_managers')

    group.add_privilege(chief)
    chief.children.each { |privilege| group.add_privilege(privilege) }
  end
end
