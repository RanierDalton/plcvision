#!/bin/bash

# os q's são de quiet (silencio) para mostrar menos texto
# e os y's são para não ficar fazendo perguntas no meio dos comandos

# Atualizar a máquina
echo "Atualizando Sistema..."
sudo apt update -qq -y && sudo apt upgrade -qq -y

# Instalar Node.js 
echo "Instalando NodeJS..."
sudo apt install -qq -y nodejs npm

# Instalar pip do Python 
echo "Instalando Pip..."
sudo apt install -qq -y python3-pip

# Instalar bibliotecas Python necessárias
echo "Instalando bibliotecas Python..."
pip install --quiet --no-input psutil==7.0.0 mysql-connector-python==9.2.0

# instalando mysql
echo "Instalando MYSQL Server..."
sudo apt -qq -y install mysql-server
sudo systemctl start mysql.service

# configurando MYSQL
echo "Configurando MYSQL..."
sudo mysql < src/database/modelagem.sql

CREATE USER 'plc_root'@'%' IDENTIFIED BY 'Urubu100';
GRANT ALL PRIVILEGES ON PlcVision.* TO 'plc_root'@'%';
FLUSH PRIVILEGES;

CREATE USER 'insert_user'@'%' IDENTIFIED BY 'Urubu100';
GRANT INSERT ON PlcVision.dados TO 'insert_user'@'%';
GRANT INSERT ON PlcVision.alertas TO 'insert_user'@'%';
FLUSH PRIVILEGES;

CREATE USER 'select_user'@'%' IDENTIFIED BY 'Urubu100#';
GRANT SELECT ON PlcVision.* TO 'select_user'@'%';
FLUSH PRIVILEGES;

# configurar e rodar projeto node
echo "Configurando e inicializando web-data-viz..."
npm i && npm start

# iniciar script python 
echo "Inicializando script de captura..."
python3 ./Scripts/captura_dados.py

# TODO a partir daq vou ter q testar na mão, por enquanto paro por aq