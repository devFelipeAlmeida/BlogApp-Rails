require 'rails_helper'

RSpec.describe Post, type: :model do
  let(:user) { create(:user) }
  let(:post) { create(:post, user: user, title: "Post de Teste", content: "Este é um conteúdo de teste.") }

  describe "associações" do
    it "pertence a um usuário" do
      expect(post.user).to eq(user)
    end

    it "tem muitos comentários" do
      comment = create(:comment, post: post)
      expect(post.comments).to include(comment)
    end

    it "tem muitas tags" do
      tag = create(:tag, name: "tag1", post: post)
      expect(post.tags).to include(tag)
    end

    it "destrói os comentários associados quando o post for destruído" do
      comment = create(:comment, post: post)
      expect { post.destroy }.to change(Comment, :count).by(-1)
    end

    it "destrói as tags associadas quando o post for destruído" do
      tag = create(:tag, name: "tag1", post: post)
      expect { post.destroy }.to change(Tag, :count).by(-1)
    end
  end

  describe "validações" do
    it "é válido com atributos válidos" do
      expect(post).to be_valid
    end

    it "não é válido sem um título" do
      post.title = nil
      expect(post).to_not be_valid
    end

    it "não é válido sem conteúdo" do
      post.content = nil
      expect(post).to_not be_valid
    end
  end

  describe "#tag_names=" do
    it "atribui tags a partir de uma string separada por vírgulas" do
      post.tag_names = "tag1, tag2, tag3"
      expect(post.tags.count).to eq(3)
      expect(post.tags.map(&:name)).to match_array(["tag1", "tag2", "tag3"])
    end

    it "ignora espaços extras ao atribuir tags" do
      post.tag_names = " tag1 , tag2 , tag3 "
      expect(post.tags.count).to eq(3)
      expect(post.tags.map(&:name)).to match_array(["tag1", "tag2", "tag3"])
    end
  end

  describe "#tag_names" do
    it "retorna uma string separada por vírgulas dos nomes das tags" do
      post.tag_names = "tag1, tag2, tag3"
      expect(post.tag_names).to eq("tag1, tag2, tag3")
    end
  end
end
