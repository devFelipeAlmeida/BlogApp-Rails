require 'rails_helper'

RSpec.describe Tag, type: :model do
  describe "criação de tags" do
    it "deve criar tags com o mesmo nome" do
      tag1 = create(:tag, name: "Saúde")
      tag2 = create(:tag, name: "Esporte")
      expect(tag1).to be_persisted
      expect(tag2).to be_persisted
      expect(tag1.name).to eq("Saúde")
      expect(tag2.name).to eq("Esporte")
    end
  end
end
