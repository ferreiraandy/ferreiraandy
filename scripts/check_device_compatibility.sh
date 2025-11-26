#!/bin/bash

# Script para verificar compatibilidade do dispositivo Mi 10T
# Uso: ./check_device_compatibility.sh

set -e

# Cores
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo "=========================================="
echo "Verificação de Compatibilidade - Mi 10T"
echo "=========================================="
echo ""

# Verificar ADB
if ! command -v adb &> /dev/null; then
    echo -e "${RED}✗${NC} ADB não está instalado"
    exit 1
fi

# Verificar conexão
if ! adb devices | grep -q "device$"; then
    echo -e "${RED}✗${NC} Dispositivo não conectado"
    echo "Conecte o dispositivo e ative a depuração USB"
    exit 1
fi

echo "Coletando informações do dispositivo..."
echo ""

# Função para obter propriedade
get_prop() {
    adb shell getprop "$1" 2>/dev/null || echo "N/A"
}

# Informações básicas
MODEL=$(get_prop ro.product.model)
DEVICE=$(get_prop ro.product.device)
BRAND=$(get_prop ro.product.brand)
MANUFACTURER=$(get_prop ro.product.manufacturer)
BOARD=$(get_prop ro.product.board)

echo "Informações do Dispositivo:"
echo "  Modelo: $MODEL"
echo "  Código: $DEVICE"
echo "  Marca: $BRAND"
echo "  Fabricante: $MANUFACTURER"
echo "  Placa: $BOARD"
echo ""

# Verificar se é Mi 10T
IS_APOLLO=false
if [[ "$DEVICE" == *"apollo"* ]] || [[ "$MODEL" == *"Mi 10T"* ]] || [[ "$MODEL" == *"M2007J3SY"* ]]; then
    IS_APOLLO=true
    echo -e "${GREEN}✓${NC} Dispositivo identificado como Mi 10T (apollo)"
else
    echo -e "${YELLOW}⚠${NC} Dispositivo pode não ser Mi 10T"
    echo "   Código esperado: apollo ou apollopro"
    echo "   Código encontrado: $DEVICE"
fi

echo ""

# Informações do hardware
CPU=$(get_prop ro.product.cpu.abi)
HARDWARE=$(get_prop ro.hardware)
SOC=$(get_prop ro.chipname)

echo "Hardware:"
echo "  CPU: $CPU"
echo "  Hardware: $HARDWARE"
if [ "$SOC" != "N/A" ]; then
    echo "  SoC: $SOC"
fi
echo ""

# Verificar Android
ANDROID_VERSION=$(get_prop ro.build.version.release)
SDK_VERSION=$(get_prop ro.build.version.sdk)
MIUI_VERSION=$(get_prop ro.miui.ui.version.name)
MIUI_CODE=$(get_prop ro.miui.ui.version.code)

echo "Software:"
echo "  Android: $ANDROID_VERSION (SDK $SDK_VERSION)"
if [ "$MIUI_VERSION" != "N/A" ]; then
    echo "  MIUI: $MIUI_VERSION ($MIUI_CODE)"
fi
echo ""

# Verificar bootloader
echo "Status do Bootloader:"
BL_LOCKED=$(get_prop ro.boot.flash.locked)
if [ "$BL_LOCKED" == "0" ] || [ "$BL_LOCKED" == "unlocked" ]; then
    echo -e "${GREEN}✓${NC} Bootloader parece estar desbloqueado"
else
    echo -e "${YELLOW}⚠${NC} Status do bootloader: $BL_LOCKED"
    echo "   Execute ./check_bootloader.sh para verificação completa"
fi
echo ""

# Verificar se já tem ROM customizada
echo "ROM Atual:"
BUILD_TAGS=$(get_prop ro.build.tags)
if [[ "$BUILD_TAGS" == *"release-keys"* ]] && [[ "$MIUI_VERSION" == "N/A" ]]; then
    echo -e "${GREEN}✓${NC} Possível ROM customizada detectada"
elif [ "$MIUI_VERSION" != "N/A" ]; then
    echo -e "${BLUE}ℹ${NC} MIUI original detectado"
else
    echo -e "${YELLOW}⚠${NC} Não foi possível determinar"
fi
echo ""

# Verificar Magisk
echo "Root/Magisk:"
if adb shell "su -c 'echo test'" 2>/dev/null | grep -q "test"; then
    MAGISK_VERSION=$(adb shell "su -c 'magisk -v'" 2>/dev/null || echo "Root disponível")
    echo -e "${GREEN}✓${NC} Root disponível: $MAGISK_VERSION"
else
    echo -e "${YELLOW}⚠${NC} Root não detectado (normal se ainda não instalou Magisk)"
fi
echo ""

# Resumo de compatibilidade
echo "=========================================="
echo "Resumo de Compatibilidade"
echo "=========================================="
echo ""

if [ "$IS_APOLLO" = true ]; then
    echo -e "${GREEN}✓${NC} Dispositivo compatível com ROMs para Mi 10T"
    echo ""
    echo "ROMs recomendadas:"
    echo "  - LineageOS 21 (Android 14)"
    echo "  - Pixel Experience Plus"
    echo "  - Evolution X"
    echo "  - crDroid"
    echo ""
    echo "Recursos do dispositivo:"
    echo "  - Snapdragon 865"
    echo "  - 6GB/8GB RAM"
    echo "  - Suporte a ROMs Android 12-14"
    echo ""
else
    echo -e "${YELLOW}⚠${NC} Verifique se este é realmente um Mi 10T"
    echo "   Algumas ROMs podem não funcionar corretamente"
fi

echo ""
echo "Próximos passos:"
echo "1. Execute ./check_prerequisites.sh"
echo "2. Execute ./check_bootloader.sh"
echo "3. Siga o guia no README.md"
echo ""
