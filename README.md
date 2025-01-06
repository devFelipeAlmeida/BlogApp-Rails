# BlogApp - Rails

Este é um blog completo desenvolvido com **Ruby on Rails**, utilizando **PostgreSQL** como banco de dados, com funcionalidades como criação de posts, comentários, autenticação de usuários, e upload de arquivos com processamento assíncrono via **Sidekiq**.

## Tecnologias Utilizadas

- **Ruby on Rails** (backend)
- **PostgreSQL** (banco de dados)
- **HTML**, **CSS**, **JavaScript** (frontend)
- **Bootstrap** (opcional para estilização)
- **Sidekiq** (para processamento assíncrono)
- **Devise** (para autenticação de usuários)
- **RSpec** (para testes automatizados)

## Funcionalidades

### Área Deslogada
- Visualização de posts de todos os usuários (ordenados do mais novo para o mais antigo).
- Paginação de posts (máximo de 3 posts por página).
- Comentários anônimos.
- Cadastro de novos usuários.
- Login de usuários existentes.
- Recuperação de senha para usuários.

### Área Logada
- Criação de posts.
- Edição e exclusão de posts do próprio usuário.
- Comentários identificados (feitos por usuários logados).
- Edição de perfil do usuário.
- Alteração da senha do usuário logado.

### Funcionalidades Extras
- Testes automatizados simples (utilizando **RSpec**).
- Internacionalização do aplicativo.
- Sistema de tags associadas aos posts, com filtros para exibição de posts por tag.
- Upload de arquivos **.txt** para criar posts ou tags de forma assíncrona com **Sidekiq**.

## Como Rodar o Projeto

### Pré-requisitos

1. **Ruby** (versão 3.3 ou superior)
2. **Rails** (versão 7.2 ou superior)
3. **PostgreSQL** instalado e configurado
4. **Sidekiq** (para o processamento assíncrono de uploads)

### Passos para Execução

1. **Clone o repositório:**
   ```bash
   git clone https://github.com/seu-usuario/blog-app.git
   cd blog-app

2. **Instale as dependências:**
    ```bash
    bundle install

3. **Configuração do Banco de Dados:**
   - Crie o banco de dados:
      ```bash
     bin/rails db:create
      
   - Execute as migrações:
     ```bash
     bin/rails db:migrate

4. **bin/rails server:**
   ```bash
   bin/rails server

5. **Para rodar o Sidekiq (para processamento assíncrono de uploads):**
   ```bash
    bundle exec sidekiq

5. **Rodar os testes automatizados (caso precise):**
   ```bash
    bundle exec rspec

6. **Comente as linhas 16 e 17 no arquivo config/environments/development.rb, e 10, 11 do config/environments/production.rb:**
   ```bash
    #user_name:       ENV["SMTP_USERNAME"],
    #password:        ENV["SMTP_PASSWORD"],

7. **Apague o arquivo config/credentials.yml.enc e crie o seu credentials.yml.enc:**
   ```bash
    rm config/credentials.yml.enc

# Deploy
A aplicação está hospedada no Fly.io https://blogapp-rails.fly.dev/. Utilizei ele graças aos 5$ de graça que recebemos, na primeira vez que usamos.
