# frozen_string_literal: true

class CreatePortkeyShortLinks < ActiveRecord::Migration[5.2]
  def change
    create_table :portkey_short_links do |t|
      t.string :url, null: false
      t.string :shortened_path
      t.integer :visits, null: false, default: 0

      t.timestamps
    end

    add_index(:portkey_short_links, :url)
    add_index(:portkey_short_links, :shortened_path, unique: true)
  end
end
