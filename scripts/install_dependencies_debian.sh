#!/bin/bash

# Script para instalar dependências no Debian 13
# Uso: ./install_dependencies_debian.sh

set -e

# Cores
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo "=========================================="
echo "Instalação de Dependências - Debian 13"
echo "=========================================="
echo ""

# Verificar se é Debian
if [ ! -f /etc/debian_version ]; then
    echo -e "${RED}✗${NC} Este script é para Debian"
    exit 1
fi

DEBIAN_VERSION=$(cat /etc/debian_version)
echo -e "${GREEN}✓${NC} Debian detectado: $DEBIAN_VERSION"
echo ""

# Verificar se é root
if [ "$EUID" -eq 0 ]; then
    echo -e "${RED}✗${NC} Não execute como root. Use sudo quando necessário."
    exit 1
fi

# Atualizar sistema
echo "1. Atualizando lista de pacotes..."
sudo apt update
echo -e "${GREEN}✓${NC} Concluído"
echo ""

# Instalar ADB e Fastboot
echo "2. Instalando ADB e Fastboot..."
if command -v adb &> /dev/null && command -v fastboot &> /dev/null; then
    echo -e "${YELLOW}⚠${NC} ADB e Fastboot já estão instalados"
    adb version | head -n 1
    fastboot --version | head -n 1
else
    echo "Instalando via apt..."
    sudo apt install -y android-tools-adb android-tools-fastboot
    
    if command -v adb &> /dev/null && command -v fastboot &> /dev/null; then
        echo -e "${GREEN}✓${NC} ADB e Fastboot instalados"
        adb version | head -n 1
        fastboot --version | head -n 1
    else
        echo -e "${RED}✗${NC} Erro ao instalar ADB/Fastboot"
        echo "Tente instalar manualmente ou use Platform Tools"
        exit 1
    fi
fi
echo ""

# Instalar dependências adicionais
echo "3. Instalando dependências adicionais..."
sudo apt install -y \
    wget \
    unzip \
    curl \
    git \
    usbutils \
    udev \
    || echo -e "${YELLOW}⚠${NC} Alguns pacotes podem não estar disponíveis"
echo -e "${GREEN}✓${NC} Dependências instaladas"
echo ""

# Configurar regras udev
echo "4. Configurando regras USB (udev)..."
UDEV_RULES_FILE="/etc/udev/rules.d/51-android.rules"

if [ -f "$UDEV_RULES_FILE" ]; then
    echo -e "${YELLOW}⚠${NC} Arquivo de regras já existe: $UDEV_RULES_FILE"
    read -p "Deseja sobrescrever? (s/N): " -n 1 -r
    echo ""
    if [[ ! $REPLY =~ ^[Ss]$ ]]; then
        echo "Pulando configuração de regras udev"
    else
        CREATE_RULES=true
    fi
else
    CREATE_RULES=true
fi

if [ "$CREATE_RULES" = true ]; then
    echo "Criando regras udev..."
    sudo tee "$UDEV_RULES_FILE" > /dev/null << 'EOF'
# Regras USB para dispositivos Android
# Xiaomi devices
SUBSYSTEM=="usb", ATTR{idVendor}=="2717", MODE="0664", GROUP="plugdev"
# Google devices (para fastboot e ADB)
SUBSYSTEM=="usb", ATTR{idVendor}=="18d1", MODE="0664", GROUP="plugdev"
# Qualcomm devices
SUBSYSTEM=="usb", ATTR{idVendor}=="05c6", MODE="0664", GROUP="plugdev"
EOF
    
    echo -e "${GREEN}✓${NC} Regras udev criadas"
    
    # Aplicar regras
    echo "Aplicando regras..."
    sudo udevadm control --reload-rules
    sudo udevadm trigger
    echo -e "${GREEN}✓${NC} Regras aplicadas"
fi
echo ""

# Adicionar usuário ao grupo plugdev
echo "5. Configurando grupo plugdev..."
CURRENT_USER=$(whoami)

if groups | grep -q plugdev; then
    echo -e "${GREEN}✓${NC} Usuário $CURRENT_USER já está no grupo plugdev"
else
    echo "Adicionando usuário ao grupo plugdev..."
    sudo usermod -aG plugdev "$CURRENT_USER"
    echo -e "${GREEN}✓${NC} Usuário adicionado ao grupo plugdev"
    echo -e "${YELLOW}⚠${NC} Você precisa fazer logout/login para aplicar as mudanças"
    echo "   Ou execute: newgrp plugdev"
fi
echo ""

# Verificar instalação
echo "6. Verificando instalação..."
echo ""

ERRORS=0

# Verificar ADB
if command -v adb &> /dev/null; then
    echo -e "${GREEN}✓${NC} ADB: $(which adb)"
    adb version | head -n 1
else
    echo -e "${RED}✗${NC} ADB não encontrado"
    ((ERRORS++))
fi

# Verificar Fastboot
if command -v fastboot &> /dev/null; then
    echo -e "${GREEN}✓${NC} Fastboot: $(which fastboot)"
    fastboot --version | head -n 1
else
    echo -e "${RED}✗${NC} Fastboot não encontrado"
    ((ERRORS++))
fi

# Verificar regras udev
if [ -f "$UDEV_RULES_FILE" ]; then
    echo -e "${GREEN}✓${NC} Regras udev: $UDEV_RULES_FILE"
else
    echo -e "${YELLOW}⚠${NC} Regras udev não encontradas"
fi

# Verificar grupo
if groups | grep -q plugdev; then
    echo -e "${GREEN}✓${NC} Usuário no grupo plugdev"
else
    echo -e "${YELLOW}⚠${NC} Usuário não está no grupo plugdev (faça logout/login)"
fi

echo ""

# Resumo
echo "=========================================="
echo "Resumo"
echo "=========================================="

if [ $ERRORS -eq 0 ]; then
    echo -e "${GREEN}✓ Instalação concluída com sucesso!${NC}"
    echo ""
    echo "Próximos passos:"
    echo "1. Faça logout/login para aplicar mudanças de grupo"
    echo "2. Conecte o dispositivo e teste: adb devices"
    echo "3. Execute: ./scripts/check_prerequisites.sh"
else
    echo -e "${RED}✗ Erros encontrados: $ERRORS${NC}"
    echo "Corrija os erros antes de continuar"
    exit 1
fi

echo ""
