# frozen_string_literal: true

class RenamePortkeyShortLinksToDarjeelinkShortLinks < ActiveRecord::Migration[5.2]
  def change
    rename_table :portkey_short_links, :darjeelink_short_links
  end
end
