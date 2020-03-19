class CreateCrawlers < ActiveRecord::Migration[6.0]
  def change
    create_table :crawlers do |t|
      t.string :source
      t.string :url
      t.string :title
      t.string :subtitle
      t.string :body
      t.string :tags
      t.string :publication

      t.timestamps
    end
  end
end
