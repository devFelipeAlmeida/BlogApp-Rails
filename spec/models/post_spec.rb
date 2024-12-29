require 'rails_helper'

RSpec.describe Post, type: :model do
  # Definindo o user para os testes
  let(:user) { create(:user) }

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
    describe '#tag_names=' do
      it 'cria ou encontra tags a partir de uma string de nomes separados por vírgula' do
        post = create(:post, user: user)  # Cria o post com o usuário associado
        post.tag_names = 'Rails, Ruby, Testing'
        post.save!  # Salva o post

        expect(post.tags.map(&:name)).to match_array(['rails', 'ruby', 'testing'])
      end

      it 'remove espaços extras e padroniza os nomes em letras minúsculas' do
        post = create(:post, user: user)  # Cria o post com o usuário associado
        post.tag_names = '  RSpec , FactoryBot '
        post.save!  # Salva o post

        expect(post.tags.map(&:name)).to match_array(['rspec', 'factorybot'])
      end
    end
  end
end

