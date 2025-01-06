require 'rails_helper'

RSpec.describe Tag, type: :model do
  describe "criação de tags" do
    let(:post) { create(:post) } 
    it "deve criar tags com o mesmo nome associadas ao post" do
      tag1 = create(:tag, name: "Saúde", post: post)
      tag2 = create(:tag, name: "Esporte", post: post)
      
      expect(tag1).to be_persisted
      expect(tag2).to be_persisted
      expect(tag1.name).to eq("Saúde")
      expect(tag2.name).to eq("Esporte")
      expect(tag1.post).to eq(post) 
      expect(tag2.post).to eq(post)
    end

    it "não deve criar tag sem post associado" do
      tag = build(:tag, name: "Saúde", post: nil)
      expect(tag).to_not be_valid
    end
  end
end
