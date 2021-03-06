class CreatePages < ActiveRecord::Migration
  def change
    create_table :pages do |t|
      t.text :content

      t.integer  :book_nr, null: false
      t.integer  :source_page_nr, null: false

      t.references :transcriber, index: true
      t.references :reviewer, index: true

      t.datetime :checked_out_at
      t.datetime :submitted_at
      t.datetime :reviewed_at

      t.timestamps null: false
    end

    add_index :pages, :checked_out_at
    add_index :pages, :submitted_at
    add_index :pages, :reviewed_at
  end
end
