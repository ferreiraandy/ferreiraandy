#!/bin/bash

# Script para verificar pré-requisitos antes de instalar ROM customizada
# Uso: ./check_prerequisites.sh

set -e

echo "=========================================="
echo "Verificação de Pré-requisitos - Mi 10T"
echo "=========================================="
echo ""

# Cores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

ERRORS=0
WARNINGS=0

# Função para verificar comando
check_command() {
    if command -v $1 &> /dev/null; then
        echo -e "${GREEN}✓${NC} $1 está instalado"
        return 0
    else
        echo -e "${RED}✗${NC} $1 NÃO está instalado"
        return 1
    fi
}

# Verificar ADB
echo "1. Verificando ADB..."
if check_command adb; then
    ADB_VERSION=$(adb version | head -n 1)
    echo "   Versão: $ADB_VERSION"
else
    echo -e "${YELLOW}   Instale o Android SDK Platform Tools${NC}"
    echo "   https://developer.android.com/tools/releases/platform-tools"
    ((ERRORS++))
fi

# Verificar Fastboot
echo ""
echo "2. Verificando Fastboot..."
if check_command fastboot; then
    FASTBOOT_VERSION=$(fastboot --version | head -n 1)
    echo "   Versão: $FASTBOOT_VERSION"
else
    echo -e "${YELLOW}   Instale o Android SDK Platform Tools${NC}"
    ((ERRORS++))
fi

# Verificar conexão do dispositivo
echo ""
echo "3. Verificando conexão do dispositivo..."
if adb devices | grep -q "device$"; then
    DEVICE=$(adb devices | grep "device$" | awk '{print $1}')
    echo -e "${GREEN}✓${NC} Dispositivo conectado: $DEVICE"
    
    # Verificar modelo
    MODEL=$(adb shell getprop ro.product.model 2>/dev/null || echo "Desconhecido")
    DEVICE_NAME=$(adb shell getprop ro.product.device 2>/dev/null || echo "Desconhecido")
    
    echo "   Modelo: $MODEL"
    echo "   Código: $DEVICE_NAME"
    
    if [[ "$DEVICE_NAME" == *"apollo"* ]]; then
        echo -e "${GREEN}✓${NC} Dispositivo compatível (Mi 10T)"
    else
        echo -e "${YELLOW}⚠${NC} Dispositivo pode não ser Mi 10T"
        ((WARNINGS++))
    fi
    
    # Verificar depuração USB
    USB_DEBUG=$(adb shell getprop sys.usb.config 2>/dev/null || echo "")
    if [[ "$USB_DEBUG" == *"adb"* ]]; then
        echo -e "${GREEN}✓${NC} Depuração USB ativada"
    else
        echo -e "${RED}✗${NC} Depuração USB não detectada"
        echo "   Ative em: Configurações → Opções do desenvolvedor → Depuração USB"
        ((ERRORS++))
    fi
    
    # Verificar nível de bateria
    BATTERY=$(adb shell dumpsys battery | grep level | awk '{print $2}' 2>/dev/null || echo "0")
    if [ "$BATTERY" -ge 50 ]; then
        echo -e "${GREEN}✓${NC} Bateria: ${BATTERY}% (suficiente)"
    else
        echo -e "${YELLOW}⚠${NC} Bateria: ${BATTERY}% (recomenda-se pelo menos 50%)"
        ((WARNINGS++))
    fi
else
    echo -e "${RED}✗${NC} Nenhum dispositivo conectado"
    echo "   Conecte o dispositivo via USB e ative a depuração USB"
    ((ERRORS++))
fi

# Verificar bootloader
echo ""
echo "4. Verificando status do bootloader..."
if fastboot devices &> /dev/null; then
    echo -e "${YELLOW}⚠${NC} Execute este script com o dispositivo em modo normal (não fastboot)"
else
    # Tentar verificar via ADB
    BL_STATE=$(adb shell getprop ro.boot.flash.locked 2>/dev/null || echo "unknown")
    if [ "$BL_STATE" == "0" ] || [ "$BL_STATE" == "unlocked" ]; then
        echo -e "${GREEN}✓${NC} Bootloader parece estar desbloqueado"
    else
        echo -e "${YELLOW}⚠${NC} Status do bootloader não confirmado"
        echo "   Execute: ./check_bootloader.sh para verificar"
        ((WARNINGS++))
    fi
fi

# Verificar arquivos necessários
echo ""
echo "5. Verificando arquivos necessários..."
REQUIRED_FILES=("twrp-apollo.img" "rom.zip" "magisk.zip")
MISSING_FILES=0

for file in "${REQUIRED_FILES[@]}"; do
    if [ -f "$file" ] || [ -f "../$file" ] || [ -f "./$file" ]; then
        echo -e "${GREEN}✓${NC} $file encontrado"
    else
        echo -e "${YELLOW}⚠${NC} $file não encontrado (baixe antes de continuar)"
        ((MISSING_FILES++))
    fi
done

if [ $MISSING_FILES -gt 0 ]; then
    ((WARNINGS++))
fi

# Resumo
echo ""
echo "=========================================="
echo "Resumo"
echo "=========================================="

if [ $ERRORS -eq 0 ] && [ $WARNINGS -eq 0 ]; then
    echo -e "${GREEN}✓ Todos os pré-requisitos estão OK!${NC}"
    echo "Você pode prosseguir com a instalação."
    exit 0
elif [ $ERRORS -eq 0 ]; then
    echo -e "${YELLOW}⚠ Alguns avisos, mas pode prosseguir${NC}"
    echo "Avisos: $WARNINGS"
    exit 0
else
    echo -e "${RED}✗ Erros encontrados: $ERRORS${NC}"
    echo "Avisos: $WARNINGS"
    echo "Corrija os erros antes de continuar."
    exit 1
fi
