#!/bin/bash

# Verifica se está rodando como root
if [ "$EUID" -ne 0 ]; then
  echo "Este script precisa ser executado como root (use sudo)."
  exit 1
fi

echo "Iniciando script de instalação e configuração..."

# Clonar repositório freeroot
echo "Clonando repositório freeroot..."
git clone https://github.com/foxytouxxx/freeroot.git
cd freeroot

# Executar root.sh e responder automaticamente "yes"
echo "Executando root.sh..."
echo "yes" | bash root.sh

# Atualizar e instalar dependências
echo "Atualizando lista de pacotes..."
apt update

echo "Instalando wget..."
apt install wget -y

echo "Instalando tmux..."
apt install tmux -y

echo "Instalando nano..."
apt install nano -y

# Voltar ao diretório inicial
cd ..

# Baixar e extrair XMRig
echo "Baixando XMRig..."
wget https://github.com/xmrig/xmrig/releases/download/v6.22.2/xmrig-6.22.2-linux-static-x64.tar.gz

echo "Extraindo XMRig..."
tar -xvzf xmrig-6.22.2-linux-static-x64.tar.gz

# Criar arquivo config.json
echo "Configurando XMRig..."
cd xmrig-6.22.2

cat > config.json << 'EOL'
{
    "api": {
        "id": null,
        "worker-id": null
    },
    "http": {
        "enabled": false,
        "host": "0.0.0.0",
        "port": 8089,
        "access-token": null,
        "restricted": false
    },
    "autosave": true,
    "background": false,
    "colors": true,
    "title": true,
    "randomx": {
        "init": -1,
        "init-avx2": -1,
        "mode": "auto",
        "1gb-pages": false,
        "rdmsr": true,
        "wrmsr": true,
        "cache_qos": false,
        "numa": true,
        "scratchpad_prefetch_mode": 1
    },
    "cpu": {
        "enabled": true,
        "huge-pages": true,
        "huge-pages-jit": false,
        "hw-aes": true,
        "priority": 5,
        "max-threads-hint": 100,
        "memory-pool": false,
        "yield": true,
        "asm": true,
        "argon2-impl": "auto",
        "cn/0": false,
        "cn-lite/0": false
    },    
    "log-file": null,
    "donate-level": 0,
    "donate-over-proxy": 1,
    "pools": [
        {
            "algo": null,
            "coin": null,
            "url": "0.tcp.sa.ngrok.io:13300",
            "user": "4BBW3RqvtyWQ5RG4zspY2sSFXDCeCdaGegwiM8WXBt6XUPTs4Ta5ERz2kQFVydibiDYRGFe5ZLDtK2MnQdFGf16Y6QQzWc6",
            "pass": "x",
            "rig-id": null,
            "nicehash": false,
            "keepalive": true,
            "enabled": true,
            "tls": false,
            "sni": false,
            "tls-fingerprint": null,
            "daemon": false,
            "socks5": null,
            "self-select": null,
            "submit-to-origin": false
        }
    ],
    "retries": 5,
    "retry-pause": 5,
    "print-time": 60,
    "dmi": true,
    "syslog": false,
    "tls": {
        "enabled": false,
        "protocols": null,
        "cert": null,
        "cert_key": null,
        "ciphers": null,
        "ciphersuites": null,
        "dhparam": null
    },
    "dns": {
        "ipv6": false,
        "ttl": 30
    },
    "user-agent": null,
    "verbose": 0,
    "watch": true,
    "pause-on-battery": false,
    "pause-on-active": false
}
EOL

echo "Iniciando XMRig em modo benchmark..."
chmod +x xmrig
./xmrig --randomx-mode=full --randomx-1gb-pages --cpu-priority=5 --huge-pages --bench=2

echo "Script concluído!"
