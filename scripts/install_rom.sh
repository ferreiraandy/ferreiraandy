#!/bin/bash

# Script principal para instalar ROM customizada no Mi 10T
# Uso: ./install_rom.sh

set -e

# Cores
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

echo "=========================================="
echo "Instalação de ROM Customizada - Mi 10T"
echo "=========================================="
echo ""

# Verificar se está no diretório correto
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR/.."

echo "Este script irá guiá-lo através do processo de instalação."
echo ""
echo -e "${YELLOW}⚠ ATENÇÃO ⚠${NC}"
echo "Este processo irá:"
echo "  - Apagar TODOS os dados do dispositivo"
echo "  - Instalar uma ROM customizada"
echo "  - Requerer bootloader desbloqueado"
echo ""
read -p "Deseja continuar? (s/N): " -n 1 -r
echo ""

if [[ ! $REPLY =~ ^[Ss]$ ]]; then
    echo "Operação cancelada"
    exit 0
fi

echo ""
echo "=========================================="
echo "FASE 1: Verificação de Pré-requisitos"
echo "=========================================="
echo ""

# Executar verificação de pré-requisitos
if [ -f "scripts/check_prerequisites.sh" ]; then
    bash scripts/check_prerequisites.sh
    if [ $? -ne 0 ]; then
        echo ""
        echo -e "${RED}Corrija os erros antes de continuar${NC}"
        exit 1
    fi
else
    echo -e "${YELLOW}⚠${NC} Script de verificação não encontrado"
    echo "Continuando manualmente..."
fi

echo ""
read -p "Pressione Enter para continuar..."
echo ""

echo "=========================================="
echo "FASE 2: Verificação do Bootloader"
echo "=========================================="
echo ""

if [ -f "scripts/check_bootloader.sh" ]; then
    echo "Verificando status do bootloader..."
    bash scripts/check_bootloader.sh
    BL_STATUS=$?
    
    if [ $BL_STATUS -ne 0 ]; then
        echo ""
        echo -e "${RED}Bootloader não está desbloqueado!${NC}"
        echo ""
        echo "Você precisa desbloquear o bootloader primeiro:"
        echo "1. Use o Mi Unlock Tool"
        echo "2. Aguarde a aprovação"
        echo "3. Execute o desbloqueio"
        echo ""
        echo "Depois, execute este script novamente."
        exit 1
    fi
else
    echo -e "${YELLOW}⚠${NC} Script de verificação não encontrado"
    read -p "O bootloader está desbloqueado? (s/N): " -n 1 -r
    echo ""
    if [[ ! $REPLY =~ ^[Ss]$ ]]; then
        echo "Desbloqueie o bootloader primeiro!"
        exit 1
    fi
fi

echo ""
read -p "Pressione Enter para continuar..."
echo ""

echo "=========================================="
echo "FASE 3: Backup (Recomendado)"
echo "=========================================="
echo ""

read -p "Deseja fazer backup agora? (S/n): " -n 1 -r
echo ""

if [[ ! $REPLY =~ ^[Nn]$ ]]; then
    if [ -f "scripts/backup_device.sh" ]; then
        bash scripts/backup_device.sh
    else
        echo -e "${YELLOW}⚠${NC} Script de backup não encontrado"
        echo "Faça backup manualmente antes de continuar!"
    fi
else
    echo -e "${YELLOW}⚠${NC} Backup pulado (não recomendado)"
fi

echo ""
read -p "Pressione Enter para continuar..."
echo ""

echo "=========================================="
echo "FASE 4: Instalação do TWRP"
echo "=========================================="
echo ""

echo "Você precisa ter o arquivo TWRP baixado."
echo "Baixe em: https://twrp.me/xiaomi/xiaomimi10t.html"
echo ""

read -p "Digite o caminho do arquivo TWRP (ou Enter para pular): " TWRP_PATH

if [ -n "$TWRP_PATH" ] && [ -f "$TWRP_PATH" ]; then
    if [ -f "scripts/install_twrp.sh" ]; then
        bash scripts/install_twrp.sh "$TWRP_PATH"
    else
        echo -e "${YELLOW}⚠${NC} Script de instalação não encontrado"
        echo "Instale o TWRP manualmente"
    fi
else
    echo -e "${YELLOW}⚠${NC} Arquivo TWRP não encontrado ou caminho inválido"
    echo "Instale o TWRP manualmente antes de continuar"
fi

echo ""
echo "=========================================="
echo "FASE 5: Instalação da ROM"
echo "=========================================="
echo ""

echo -e "${CYAN}Instruções para instalação no TWRP:${NC}"
echo ""
echo "1. No TWRP, vá em Wipe → Format Data (digite 'yes')"
echo "2. Volte e vá em Advanced Wipe"
echo "3. Marque: Dalvik, System, Data, Cache"
echo "4. Deslize para fazer wipe"
echo ""
echo "5. Vá em Install"
echo "6. Selecione o arquivo da ROM"
echo "7. Deslize para instalar"
echo ""
echo "8. Instale o GApps (se necessário)"
echo "9. Instale o Magisk (para Google Wallet)"
echo ""
echo "10. Reinicie o sistema"
echo ""

echo "Arquivos necessários:"
echo "  - ROM customizada (rom.zip)"
echo "  - GApps (se a ROM não incluir)"
echo "  - Magisk (magisk.zip)"
echo ""

read -p "Pressione Enter quando terminar a instalação no TWRP..."
echo ""

echo "=========================================="
echo "FASE 6: Configuração do Google Wallet"
echo "=========================================="
echo ""

echo "Após a primeira inicialização:"
echo ""
echo "1. Instale o Magisk Manager APK"
echo "2. Execute: ./scripts/setup_magisk.sh"
echo "3. Ou configure manualmente seguindo o README.md"
echo ""

echo "=========================================="
echo "Instalação Concluída!"
echo "=========================================="
echo ""
echo "Próximos passos:"
echo "1. Configure o dispositivo normalmente"
echo "2. Instale o Magisk Manager"
echo "3. Configure o Magisk para Google Wallet"
echo "4. Adicione seus cartões no Google Wallet"
echo ""
echo "Para mais informações, consulte:"
echo "  - README.md (guia completo)"
echo "  - ROMS_COMPATIVEL_WALLET.md (ROMs recomendadas)"
echo ""
