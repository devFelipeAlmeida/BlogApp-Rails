require 'rails_helper'

RSpec.describe Post, type: :model do
  # Testando associações
  describe 'associações' do
    it { should belong_to(:user) }
    it { should have_many(:comments).dependent(:destroy) }
    it { should have_and_belong_to_many(:tags) }
  end

  # Testando validações
  describe 'validações' do
    it { should validate_presence_of(:title) }
    it { should validate_presence_of(:content) }
  end

  # Testando métodos personalizados
  describe 'métodos personalizados' do
    let(:user) { create(:user) }
    let(:post) { create(:post, user: user) }

    describe '#tag_names=' do
      it 'cria ou encontra tags a partir de uma string de nomes separados por vírgula' do
        post.tag_names = 'Rails, Ruby, Testing'

        expect(post.tags.map(&:name)).to match_array(['rails', 'ruby', 'testing'])
      end

      it 'remove espaços extras e padroniza os nomes em letras minúsculas' do
        post.tag_names = '  RSpec , FactoryBot '

        expect(post.tags.map(&:name)).to match_array(['rspec', 'factorybot'])
      end
    end

    describe '#tag_names' do
      it 'retorna os nomes das tags como uma string separada por vírgulas' do
        post.tags << create(:tag, name: 'rails')
        post.tags << create(:tag, name: 'ruby')

        expect(post.tag_names).to eq('rails, ruby')
      end
    end
  end
end
