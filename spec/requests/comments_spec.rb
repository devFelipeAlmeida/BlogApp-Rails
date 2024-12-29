require 'rails_helper'

RSpec.describe "Comments", type: :request do
  let(:user) { create(:user) }
  let(:post) { create(:post, user: user) }
  let(:valid_attributes) { { message: 'Este é um comentário válido' } }

  describe 'POST /posts/:post_id/comments' do
    context 'quando o usuário está autenticado' do
      before { sign_in user } # Usando o Devise::Test::IntegrationHelpers para autenticar o usuário

      it 'cria um comentário e associa ao usuário autenticado' do
        expect {
          post "/posts/#{post.id}/comments", params: { comment: { message: 'Este é um comentário válido' } }
        }.to change(Comment, :count).by(1)

        expect(Comment.last.user).to eq(user) # Verifica se o comentário está associado ao usuário
      end
    end

    context 'quando o usuário não está autenticado' do
      it 'cria um comentário sem associar a um usuário' do
        expect {
          post "/posts/#{post.id}/comments", params: { comment: { message: 'Este é um comentário válido' } }
        }.to change(Comment, :count).by(1)

        expect(Comment.last.user).to be_nil # Verifica se o comentário não tem usuário associado
      end
    end
  end
end
