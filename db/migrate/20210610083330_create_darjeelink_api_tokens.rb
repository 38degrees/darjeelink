# frozen_string_literal: true

class CreateDarjeelinkApiTokens < ActiveRecord::Migration[6.1]
  def change
    create_table :darjeelink_api_tokens do |t|
      t.string :token, null: false
      t.string :username, null: false
      t.boolean :active, null: false, default: false
      t.timestamps
    end

    add_index(:darjeelink_api_tokens, :username, unique: true)
    add_index(:darjeelink_api_tokens, :token, unique: true)
  end
end
