require 'rails_helper'

RSpec.describe UploadProcessorJob, type: :job do
  let(:usuario) { create(:user) }
  let(:blob) { ActiveStorage::Blob.create_and_upload!(io: StringIO.new(conteudo_arquivo), filename: 'teste.txt') }
  let(:conteudo_arquivo) { "Título do Post|Conteúdo do Post|Tag1,Tag2\nOutro Post|Outro Conteúdo|Tag3" }

  describe "#perform" do
    context "quando o blob existe" do
      it "processa o arquivo e cria posts com tags" do
        expect {
          UploadProcessorJob.perform_now(blob.id, usuario.id)
        }.to change(Post, :count).by(2)
          .and change(Tag, :count).by(3)

        post = Post.first
        expect(post.title).to eq("Título do Post")
        expect(post.content).to eq("Conteúdo do Post")
        expect(post.tags.pluck(:name)).to match_array(["Tag1", "Tag2"])
      end
    end

    context "quando o blob não existe" do
      it "não levanta um erro" do
        expect {
          UploadProcessorJob.perform_now(-1, usuario.id)
        }.not_to raise_error
      end
    end

    context "quando o conteúdo do arquivo é inválido" do
      it 'não cria posts ou tags quando o conteúdo do arquivo é inválido' do
        arquivo_invalido = Tempfile.new(['invalido', '.txt'])
        arquivo_invalido.write("Conteúdo Inválido Sem Pipe\n")
        arquivo_invalido.rewind

        blob_invalido = ActiveStorage::Blob.create_and_upload!(
          io: arquivo_invalido,
          filename: "invalido.txt",
          content_type: "text/plain"
        )

        expect {
          UploadProcessorJob.perform_now(blob_invalido.id, usuario.id)
        }.to_not change(Post, :count)

        expect {
          UploadProcessorJob.perform_now(blob_invalido.id, usuario.id)
        }.to_not change(Tag, :count)
      end
    end
  end
end
