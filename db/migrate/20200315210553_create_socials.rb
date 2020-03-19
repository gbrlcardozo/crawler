class CreateSocials < ActiveRecord::Migration[6.0]
  def change
    create_table :socials do |t|
      t.string :source
      t.string :url
      t.string :title
      t.string :subtitle
      t.string :publication
      t.string :tags
      t.string :body
      
      t.timestamps
    end
  end
end
