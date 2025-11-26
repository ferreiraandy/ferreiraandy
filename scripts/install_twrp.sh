#!/bin/bash

# Script para instalar TWRP Recovery no Mi 10T
# Uso: ./install_twrp.sh [caminho_do_twrp.img]

set -e

# Cores
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo "=========================================="
echo "Instalação do TWRP Recovery - Mi 10T"
echo "=========================================="
echo ""

# Verificar se fastboot está disponível
if ! command -v fastboot &> /dev/null; then
    echo -e "${RED}✗${NC} Fastboot não está instalado"
    echo "Instale o Android SDK Platform Tools"
    exit 1
fi

# Verificar arquivo TWRP
TWRP_FILE="${1:-twrp-apollo.img}"

if [ ! -f "$TWRP_FILE" ]; then
    echo -e "${RED}✗${NC} Arquivo TWRP não encontrado: $TWRP_FILE"
    echo ""
    echo "Baixe o TWRP para Mi 10T (apollo) em:"
    echo "https://twrp.me/xiaomi/xiaomimi10t.html"
    echo ""
    echo "Uso: ./install_twrp.sh [caminho_do_twrp.img]"
    exit 1
fi

echo -e "${GREEN}✓${NC} Arquivo TWRP encontrado: $TWRP_FILE"
echo ""

# Verificar se dispositivo está conectado
echo "Verificando conexão..."
if adb devices | grep -q "device$"; then
    echo -e "${BLUE}Dispositivo conectado via ADB. Reiniciando em fastboot...${NC}"
    adb reboot bootloader
    sleep 10
elif fastboot devices | grep -q "fastboot"; then
    echo -e "${GREEN}✓${NC} Dispositivo já está em modo fastboot"
else
    echo -e "${RED}✗${NC} Dispositivo não conectado"
    echo ""
    echo "Conecte o dispositivo e:"
    echo "1. Ative a depuração USB, OU"
    echo "2. Entre em modo fastboot (Volume - + Power)"
    exit 1
fi

# Verificar conexão fastboot
if ! fastboot devices | grep -q "fastboot"; then
    echo -e "${RED}✗${NC} Não foi possível conectar em modo fastboot"
    echo "Aguarde mais alguns segundos e tente novamente"
    exit 1
fi

DEVICE=$(fastboot devices | awk '{print $1}')
echo -e "${GREEN}✓${NC} Dispositivo conectado: $DEVICE"
echo ""

# Verificar se bootloader está desbloqueado
echo "Verificando status do bootloader..."
if fastboot getvar unlocked 2>&1 | grep -q "unlocked: yes"; then
    echo -e "${GREEN}✓${NC} Bootloader desbloqueado"
elif fastboot oem device-info 2>&1 | grep -qi "unlocked.*true"; then
    echo -e "${GREEN}✓${NC} Bootloader desbloqueado"
else
    echo -e "${RED}✗${NC} Bootloader está bloqueado!"
    echo "Desbloqueie o bootloader primeiro usando o Mi Unlock Tool"
    fastboot reboot
    exit 1
fi

echo ""
echo -e "${YELLOW}⚠ ATENÇÃO ⚠${NC}"
echo "Este processo irá:"
echo "1. Instalar o TWRP Recovery"
echo "2. Substituir o recovery padrão do MIUI"
echo ""
read -p "Deseja continuar? (s/N): " -n 1 -r
echo ""

if [[ ! $REPLY =~ ^[Ss]$ ]]; then
    echo "Operação cancelada"
    fastboot reboot
    exit 0
fi

echo ""
echo "Instalando TWRP..."
echo ""

# Fazer backup do recovery original (se possível)
echo "1. Fazendo backup do recovery original..."
if fastboot boot "$TWRP_FILE" 2>&1 | grep -q "booting"; then
    echo -e "${GREEN}✓${NC} Teste de boot do TWRP bem-sucedido"
    fastboot reboot bootloader
    sleep 5
fi

# Instalar TWRP
echo ""
echo "2. Instalando TWRP no recovery..."
fastboot flash recovery "$TWRP_FILE"

if [ $? -eq 0 ]; then
    echo -e "${GREEN}✓${NC} TWRP instalado com sucesso!"
    echo ""
    echo -e "${YELLOW}⚠ IMPORTANTE ⚠${NC}"
    echo "Após reiniciar, entre DIRETAMENTE no recovery!"
    echo "Se reiniciar normalmente, o MIUI pode sobrescrever o TWRP"
    echo ""
    echo "Opções:"
    echo "1. Reiniciar em recovery agora (recomendado)"
    echo "2. Reiniciar normalmente (você precisará entrar manualmente)"
    echo ""
    read -p "Escolha (1 ou 2): " -n 1 -r
    echo ""
    
    if [[ $REPLY == "1" ]]; then
        echo "Reiniciando em recovery..."
        fastboot reboot recovery
        echo ""
        echo -e "${GREEN}✓${NC} Dispositivo deve estar no TWRP agora"
        echo "Se não estiver, desligue e pressione Volume + + Power"
    else
        echo "Reiniciando normalmente..."
        fastboot reboot
        echo ""
        echo "Para entrar no TWRP:"
        echo "1. Desligue o dispositivo"
        echo "2. Pressione Volume + + Power"
        echo "3. Quando aparecer o logo, solte Power mas mantenha Volume +"
    fi
else
    echo -e "${RED}✗${NC} Erro ao instalar TWRP"
    fastboot reboot
    exit 1
fi

echo ""
echo "=========================================="
echo "Próximos passos:"
echo "=========================================="
echo "1. No TWRP, faça um wipe completo"
echo "2. Instale a ROM customizada"
echo "3. Instale o Magisk (para Google Wallet)"
echo ""
