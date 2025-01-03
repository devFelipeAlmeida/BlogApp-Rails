require 'rails_helper'

RSpec.describe Post, type: :model do
  let(:user) { create(:user) }

  describe 'associações' do
    it { should belong_to(:user) }
    it { should have_many(:comments).dependent(:destroy) }
    it { should have_and_belong_to_many(:tags) }
  end

  describe 'validações' do
    it { should validate_presence_of(:title) }
    it { should validate_presence_of(:content) }
  end

  describe 'métodos personalizados' do
    describe '#tag_names=' do
      it 'cria ou encontra tags a partir de uma string de nomes separados por vírgula' do
        post = create(:post, user: user)
        post.tag_names = 'Rails, Ruby, Testing'
        post.save!

        expect(post.tags.map(&:name)).to match_array(['rails', 'ruby', 'testing'])
      end

      it 'remove espaços extras e padroniza os nomes em letras minúsculas' do
        post = create(:post, user: user)
        post.tag_names = '  RSpec , FactoryBot '
        post.save!

        expect(post.tags.map(&:name)).to match_array(['rspec', 'factorybot'])
      end
    end
  end
end

