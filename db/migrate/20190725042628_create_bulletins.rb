class CreateBulletins < ActiveRecord::Migration[5.2]
  def change
    create_table :bulletins do |t|
      t.string :title
      t.text :content
      t.date :publish_from
      t.date :publish_to
      t.boolean :require_acknowledge, default: false
      t.timestamps
      t.bigint :created_by, index: true
      t.bigint :updated_by, index: true
    end
    
    create_table :bulletin_audiences do |t|
      t.belongs_to :bulletin, index: true
      t.references :bulletin_audienceable, polymorphic: true, index: { name: "index_bulletin_audiences_on_bulletin_audienceable" }

      t.timestamps
    end

    create_table :bulletin_user_view_logs do |t|
      t.belongs_to :bulletin, index: true
      t.belongs_to :user, index: true
      t.boolean :acknowledged, default: false, index: true
      t.timestamps
    end
  end
end
