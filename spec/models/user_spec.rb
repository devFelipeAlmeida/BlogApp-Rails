require 'rails_helper'

RSpec.describe User, type: :model do
  # Testando a validação de nome
  describe '#valid?' do
    it 'não deve ser válido sem nome' do
      user = build(:user, name: '')

      expect(user).not_to be_valid
      expect(user.errors[:name]).to include("can't be blank")
    end
  end

  # Testando a associação com posts
  describe 'associações' do
    it { should have_many(:posts).dependent(:destroy) }
  end

  # Testando as validações do Devise
  it { should validate_presence_of(:email) }
  it { should validate_presence_of(:password) }
  it { should validate_uniqueness_of(:email).case_insensitive }
end

