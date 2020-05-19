# frozen_string_literal: true

class RenamePortkeyShortLinkIndex < ActiveRecord::Migration[5.2]
  def up
    execute 'DROP INDEX index_portkey_short_links_on_lowercase_shortened_path;'
    execute 'CREATE UNIQUE INDEX index_darjeelink_short_links_on_lowercase_shortened_path
             ON darjeelink_short_links USING btree (lower(shortened_path));'
  end

  def down
    execute 'DROP INDEX index_darjeelink_short_links_on_lowercase_shortened_path;'
    execute 'CREATE UNIQUE INDEX index_portkey_short_links_on_lowercase_shortened_path
             ON portkey_short_links USING btree (lower(shortened_path));'
  end
end
