#!/bin/bash

# Variáveis
VM_NAME="nome_da_vm"       # Substitua pelo nome da sua VM no VirtualBox
SNAPSHOT_NAME="nome_do_snapshot"   # Substitua pelo nome do snapshot a ser restaurado
REPO_URL="https://github.com/alandim/repositorio.git" # Substitua pela URL do seu repositório no GitHub

# Restaura o snapshot no VirtualBox
echo "Restaurando o snapshot no VirtualBox..."
VBoxManage snapshot "$VM_NAME" restore "$SNAPSHOT_NAME"

# Inicializa a VM
echo "Iniciando a VM..."
VBoxManage startvm "$VM_NAME" --type headless

# Aguarda a VM inicializar completamente (opcional, ajuste conforme necessário)
sleep 30

# Atualiza o servidor
echo "Atualizando o servidor..."
apt-get update -y
apt-get upgrade -y
apt-get install apache2 -y
apt-get install unzip -y

# Baixa e copia os arquivos da aplicação
echo "Baixando e copiando os arquivos da aplicação..."
cd /tmp
wget https://github.com/alandim/linux-site-dio/archive/refs/heads/main.zip
unzip main.zip
cd linux-site-dio-main
cp -R * /var/www/html/

# Reinicia o Apache para garantir que as alterações sejam aplicadas
echo "Reiniciando o Apache..."
systemctl restart apache2

# Configura o Git (caso ainda não esteja configurado)
echo "Configurando o Git..."
git config --global user.name "Andre Landim"  # Substitua por seu nome de usuário do GitHub
git config --global user.email "andrelandim_4@hotmail.com"  # Substitua pelo seu email do GitHub

# Clona o repositório (se ainda não estiver clonado)
if [ ! -d "repositorio" ]; then
  echo "Clonando o repositório..."
  git clone "$REPO_URL"
fi

# Copia o script para o repositório
cd repositorio
cp /caminho/para/o/seu/script.sh .  # Substitua pelo caminho do seu script

# Adiciona, comita e envia o script para o repositório
echo "Subindo o script para o repositório no GitHub..."
git add script.sh
git commit -m "Adicionando script de provisionamento"
git push origin main  # Substitua pela branch correta, se necessário

echo "Provisionamento concluído com sucesso!"
