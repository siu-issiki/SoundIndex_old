class CreateCircles < ActiveRecord::Migration[5.2]
  def change
    create_table :circles do |t|
      t.string :name
      t.text :description
      t.string :homepage_url
      t.string :twitter_url
      t.string :soundcloud_url
      t.string :youtube_url
      t.string :niconico_url

      t.timestamps
    end
  end
end
