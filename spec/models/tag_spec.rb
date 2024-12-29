# spec/models/tag_spec.rb
require 'rails_helper'

RSpec.describe Tag, type: :model do
  # Testando a validação de unicidade do nome
  describe "validations" do
    it "deve ser válido com um nome único" do
      tag = create(:tag, name: "Tecnologia") # Usando o FactoryBot para criar a tag
      expect(tag).to be_valid
    end

    it "não deve ser válido com um nome duplicado" do
      create(:tag, name: "Tecnologia") # Cria uma tag com nome "Tecnologia"

      tag = build(:tag, name: "Tecnologia") # Cria uma nova tag com o mesmo nome
      expect(tag).not_to be_valid
      expect(tag.errors[:name]).to include("has already been taken") # Verifica o erro de unicidade
    end
  end

  # Testando a criação de uma tag
  describe "criação de tags" do
    it "deve criar uma tag com um nome único" do
      tag = create(:tag, name: "Saúde") # Usa FactoryBot para criar a tag
      expect(tag).to be_persisted
      expect(tag.name).to eq("Saúde")
    end
  end
end
