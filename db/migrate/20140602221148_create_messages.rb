class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.string :number
      t.string :content
      t.datetime :sent_at

      t.timestamps
    end
  end
end
