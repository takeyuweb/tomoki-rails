class CreateVoices < ActiveRecord::Migration[5.1]
  def change
    create_table :voices, id: :uuid do |t|
      t.string :from, null: false
      t.string :to, null: false
      t.text :text, null: false
      t.string :response_url, null: false

      t.timestamps
    end
  end
end
