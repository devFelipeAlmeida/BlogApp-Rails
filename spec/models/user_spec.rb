require 'rails_helper'

RSpec.describe User, type: :model do
  describe '#valid?' do
  it 'não deve ser válido sem nome' do
    user = build(:user, name: '')
  
    expect(user).not_to be_valid
    expect(user.errors[:name]).to include('não pode ficar em branco') # Mensagem em português
  end
  end

  describe 'associações' do
    it { should have_many(:posts).dependent(:destroy) }
  end

  it { should validate_presence_of(:email) }
  it { should validate_presence_of(:password) }
  it { should validate_uniqueness_of(:email).case_insensitive }
end

