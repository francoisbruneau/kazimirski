class CreatePages < ActiveRecord::Migration
  def change
    create_table :pages do |t|
      t.text :content

      t.integer  :book_nr, null: false
      t.integer  :source_page_nr, null: false

      t.references :submitter, index: true
      t.references :reviewer, index: true

      t.datetime :submitted_at
      t.datetime :reviewed_at

      t.timestamps null: false
    end

    add_index :pages, :submitted_at
    add_index :pages, :reviewed_at
  end
end
