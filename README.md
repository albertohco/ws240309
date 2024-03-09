# Workshop Lucianao Galvão 09/03/2024

1.  subir o docker com o python Hello Word!!

    1. Fazer o projeto app.py

       ```python
       import streamlit as st

       def hello_world():
          return "Hello, World! Show de Bola"

       def main():
          st.write(hello_world())

       if __name__ == "__main__":
          main()
       ```

    2. Escrever o readme ensinando como instalar

    3. Criar um arquivo Dockerfile

       ```Dockerfile
       # Use uma imagem base do Python
       FROM python:3.11.5
       # Define o diretório de trabalho dentro do contêiner
       WORKDIR /app
       # Copia os arquivos do diretório atual para o diretório de trabalho no contêiner
       COPY . /app
       # Instala as dependências do aplicativo
       RUN pip install --no-cache-dir -r requirements.txt
       # configura a porta
       EXPOSE 8501
       # Comando para executar o aplicativo quando o contêiner for iniciado
       ENTRYPOINT ["streamlit", "run", "app.py", "--server.port=8501", "--server.address=0.0.0.0"]
       ```

    4. Rodar local

       ```bash
       docker build -t imagem-teste
       ```

       ```bash
       docker run -d -p 8501:8501 --name container-teste imagem-teste
       ```

2.  subir o docker compose usando (Postgres + PgAdmin )

    Importante destacar que o Docker Compose é um serviço do próprio Docker voltado à criação e execução conjunta dos múltiplos containers de uma solução. Tal capacidade contribui para facilitar o deployment de um projeto em diferentes ambientes.

    Na listagem a seguir está o conteúdo do arquivo docker-compose.yml que permitirá a criação do ambiente citado (PostgreSQL + pgAdmin 4). Os testes descritos neste artigo acontecerão no Ubuntu Desktop 18.04:

    - O serviço teste-postgres-compose se refere à instância do PostgreSQL a ser criada para acesso na porta 15432;
    - Já o serviço teste-pgadmin-compose corresponde ao container que permitirá a execução do pgAdmin 4 (imagem dpage/pgadmin4) na porta 16543;
    - Nas seções environment de teste-pgadmin-compose e teste-postgres-compose foram definidas configurações (variáveis de ambientes) necessárias para a geração dos 2 containers;
    - As imagens referenciadas serão baixadas caso ainda não existam no ambiente a partir do qual o Docker Compose foi executado;
    - Foi especificado ainda um volume para teste-postgres-compose, indicando assim o diretório no Ubuntu Desktop em que serão gravados os arquivos de dados (/home/renatogroffe/Desenvolvimento/Docker-Compose/PostgreSQL);
    - Por meio da network postgres-compose-network acontecerá a comunicação entre os containers teste-pgadmin-compose e teste-postgres-compose.

    1. Criar um arquivo chamado docker-compose.yml

       ```bash
       version: "3"

       services:
           teste-postgres-compose:
               image: postgres
               environment:
                   POSTGRES_PASSWORD: "local"
               ports:
                   - "15432:5432"
               volumes:
                   - /PostgreSQL:/var/lib/postgresql/data
               networks:
                   - postgres-compose-network

           teste-pgadmin-compose:
               image: dpage/pgadmin4
               environment:
                   PGADMIN_DEFAULT_EMAIL: "local@teste.com"
                   PGADMIN_DEFAULT_PASSWORD: "local"
               ports:
                   - "16543:80"
               depends_on:
                   - teste-postgres-compose
               networks:
                   - postgres-compose-network

       networks:
           postgres-compose-network:
               driver: bridge
       ```

    2. Rodar os comandos no terminal

       ```bash
       docker-compose up -d
       ```

       ```bash
       docker network ls
       ```

       ```bash
       docker-compose ps
       ```

    3. Testando o ambiente

       Um teste de acesso via browser ao pgAdmin 4 (http://localhost:16543) exibirá a tela inicial desta solução:

       Fornecendo as credenciais de acesso que estavam no arquivo docker-compose.yml aparecerá então o painel de gerenciamento do pgAdmin 4:

       Ao criar a conexão para acesso à instância do PostgreSQL levar em conta as seguintes considerações:

       - Em Host name/address informar o nome do container que corresponde à instância do PostgreSQL(teste-postgres-compose);
       - Em Port definir o valor 5432 (porta default de acesso ao container e disponível a partir da rede postgres-compose-network; não informar a porta em que o PostgreSQL foi mapeado no host);
       - No atributo Username será informado o usuário default do PostgreSQL (postgres), bem como a senha correspondente em Password.

3.  subir o docker compose completo (Postgres + PgAdmin + Python App)

    1. Criar um arquivo chamado docker-compose.yml

    ```bash
    version: "3"
    services:
        teste-postgres-compose:
            image: postgres
            environment:
                POSTGRES_PASSWORD: "local"
            ports:
                - "15432:5432"
            volumes:
                - postgres_data:/var/lib/postgresql/data
            networks:
                - postgres-compose-network

         teste-pgadmin-compose:
             image: dpage/pgadmin4
             environment:
                 PGADMIN_DEFAULT_EMAIL: "local@teste.com"
                 PGADMIN_DEFAULT_PASSWORD: "local"
             ports:
                 - "16543:80"
             depends_on:
                 - teste-postgres-compose
             networks:
                 - postgres-compose-network

         python_app:
             build:
                 context: .
             container_name: python_app_container
             ports:
                 - "8501:8501"
             depends_on:
                 - teste-postgres-compose
             networks:
                 - postgres-compose-network

    networks:
    postgres-compose-network:
    driver: bridge

    volumes:
    postgres_data:

    ```

    2. Rodar os comandos no terminal

    ```bash
      docker-compose up -d
    ```

    ```bash
    docker network ls
    ```

    ```bash
    docker-compose ps
    ```

    3. Testando o ambiente

       Um teste de acesso via browser ao pgAdmin 4 (http://localhost:16543) exibirá a tela inicial desta solução:

       Fornecendo as credenciais de acesso que estavam no arquivo docker-compose.yml aparecerá então o painel de gerenciamento do pgAdmin 4:

       Ao criar a conexão para acesso à instância do PostgreSQL levar em conta as seguintes considerações:

       - Em Host name/address informar o nome do container que corresponde à instância do PostgreSQL(teste-postgres-compose);
       - Em Port definir o valor 5432 (porta default de acesso ao container e disponível a partir da rede postgres-compose-network; não informar a porta em que o PostgreSQL foi mapeado no host);
       - No atributo Username será informado o usuário default do PostgreSQL (postgres), bem como a senha correspondente em Password.

       Por ultimo abrir o app em (http://localhost:8501)
