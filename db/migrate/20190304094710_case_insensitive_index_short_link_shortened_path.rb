# frozen_string_literal: true

class CaseInsensitiveIndexShortLinkShortenedPath < ActiveRecord::Migration[5.2]
  def up
    remove_index(:portkey_short_links, :shortened_path)
    execute 'CREATE UNIQUE INDEX index_portkey_short_links_on_lowercase_shortened_path
             ON portkey_short_links USING btree (lower(shortened_path));'
  end

  def down
    execute 'DROP INDEX index_portkey_short_links_on_lowercase_shortened_path;'
    add_index(:portkey_short_links, :shortened_path, unique: true)
  end
end
