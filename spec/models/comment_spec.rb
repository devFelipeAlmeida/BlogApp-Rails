require 'rails_helper'

RSpec.describe Comment, type: :model do
  describe 'associações' do
    it { should belong_to(:post) }
    it { should belong_to(:user).optional }
  end

  describe 'validações' do
    it { should validate_presence_of(:message) }
  end
end
