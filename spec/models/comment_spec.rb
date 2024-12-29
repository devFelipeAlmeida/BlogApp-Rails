require 'rails_helper'

RSpec.describe Comment, type: :model do
  # Testando associações
  describe 'associações' do
    it { should belong_to(:post) }
    it { should belong_to(:user).optional }
  end

  # Testando validações
  describe 'validações' do
    it { should validate_presence_of(:message) }
  end
end
