#!/bin/bash

# Script para verificar status do bootloader do Mi 10T
# Uso: ./check_bootloader.sh

set -e

echo "=========================================="
echo "Verificação de Status do Bootloader"
echo "=========================================="
echo ""

# Cores
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Verificar se dispositivo está conectado
if ! adb devices | grep -q "device$"; then
    echo -e "${RED}✗${NC} Dispositivo não conectado via ADB"
    echo ""
    echo "Conecte o dispositivo e ative a depuração USB"
    exit 1
fi

echo "Método 1: Verificando via ADB (modo normal)..."
echo ""

# Tentar várias propriedades
PROPS=(
    "ro.boot.flash.locked"
    "ro.boot.verifiedbootstate"
    "ro.boot.veritymode"
    "sys.oem_unlock_allowed"
)

for prop in "${PROPS[@]}"; do
    VALUE=$(adb shell getprop $prop 2>/dev/null || echo "não disponível")
    echo "  $prop: $VALUE"
done

echo ""
echo "Método 2: Verificando via Fastboot..."
echo ""
echo -e "${BLUE}Reiniciando em modo fastboot...${NC}"
echo "Aguarde 10 segundos..."
adb reboot bootloader
sleep 10

# Verificar conexão fastboot
if fastboot devices | grep -q "fastboot"; then
    DEVICE=$(fastboot devices | awk '{print $1}')
    echo -e "${GREEN}✓${NC} Dispositivo em fastboot: $DEVICE"
    echo ""
    
    # Verificar status do bootloader
    echo "Verificando status do bootloader..."
    echo ""
    
    # Tentar obter informações
    if fastboot getvar unlocked 2>&1 | grep -q "unlocked: yes"; then
        echo -e "${GREEN}✓✓✓ BOOTLOADER DESBLOQUEADO ✓✓✓${NC}"
        echo ""
        echo "Você pode prosseguir com a instalação do TWRP!"
        fastboot reboot
        exit 0
    elif fastboot getvar unlocked 2>&1 | grep -q "unlocked: no"; then
        echo -e "${RED}✗✗✗ BOOTLOADER BLOQUEADO ✗✗✗${NC}"
        echo ""
        echo "Você precisa desbloquear o bootloader primeiro:"
        echo "1. Use o Mi Unlock Tool"
        echo "2. Aguarde a aprovação da Xiaomi"
        echo "3. Execute o desbloqueio"
        fastboot reboot
        exit 1
    else
        echo -e "${YELLOW}⚠${NC} Não foi possível determinar o status"
        echo ""
        echo "Tentando método alternativo..."
        
        # Tentar comando oem
        if fastboot oem device-info 2>&1 | grep -qi "unlocked.*true"; then
            echo -e "${GREEN}✓✓✓ BOOTLOADER DESBLOQUEADO ✓✓✓${NC}"
            fastboot reboot
            exit 0
        else
            echo -e "${YELLOW}⚠${NC} Status indeterminado"
            echo "Recomenda-se usar o Mi Unlock Tool para verificar"
        fi
    fi
    
    # Mostrar informações do dispositivo
    echo ""
    echo "Informações do dispositivo:"
    fastboot getvar all 2>&1 | grep -E "(product|version|secure)" | head -10
    
    fastboot reboot
else
    echo -e "${RED}✗${NC} Não foi possível conectar em modo fastboot"
    echo ""
    echo "Tente manualmente:"
    echo "1. Desligue o dispositivo"
    echo "2. Pressione Volume - + Power para entrar em fastboot"
    echo "3. Execute: fastboot devices"
    exit 1
fi
