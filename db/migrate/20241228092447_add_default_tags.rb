class AddDefaultTags < ActiveRecord::Migration[7.2]
  def up
    Tag.create!([
      { name: "Tecnologia" },
      { name: "Educação" },
      { name: "Esportes" },
      { name: "Saúde" },
      { name: "Entretenimento" }
    ])
  end

  def down
    Tag.where(name: [ "Tecnologia", "Educação", "Esportes", "Saúde", "Entretenimento" ]).destroy_all
  end
end
