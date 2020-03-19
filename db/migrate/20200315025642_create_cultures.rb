class CreateCultures < ActiveRecord::Migration[6.0]
  def change
    drop_table :cultures
    create_table :cultures do |t|
      t.string :source
      t.string :url
      t.string :title
      t.string :subtitle
      t.string :publication
      t.string :body
      t.string :tags
      
      t.timestamps
    end
  end
end
