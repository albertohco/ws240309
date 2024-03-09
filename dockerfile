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


#FROM python:3.12
#RUN pip install poetry
#COPY . /src
#WORKDIR /src
#RUN poetry install
#EXPOSE 8501
#ENTRYPOINT ["poetry","run", "streamlit", "run", "app/app.py", "--server.port=8501", "--server.address=0.0.0.0"]
