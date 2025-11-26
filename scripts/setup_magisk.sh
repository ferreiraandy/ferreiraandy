#!/bin/bash

# Script para configurar Magisk e módulos para Google Wallet
# Uso: ./setup_magisk.sh

set -e

# Cores
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo "=========================================="
echo "Configuração do Magisk para Google Wallet"
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

echo -e "${GREEN}✓${NC} Dispositivo conectado"
echo ""

# Verificar se Magisk está instalado
echo "Verificando instalação do Magisk..."
MAGISK_VERSION=$(adb shell "su -c 'magisk -v'" 2>/dev/null || echo "")

if [ -z "$MAGISK_VERSION" ]; then
    echo -e "${RED}✗${NC} Magisk não está instalado ou root não está ativo"
    echo ""
    echo "Instale o Magisk primeiro:"
    echo "1. Baixe o Magisk.apk e instale"
    echo "2. Baixe o Magisk.zip e instale via TWRP"
    echo "3. Execute este script novamente"
    exit 1
fi

echo -e "${GREEN}✓${NC} Magisk instalado: versão $MAGISK_VERSION"
echo ""

# Verificar Zygisk
echo "Verificando Zygisk..."
ZYGISK=$(adb shell "su -c 'getprop ro.zygote'" 2>/dev/null || echo "")

echo "Configurando Magisk para Google Wallet..."
echo ""

# Criar script de configuração
cat > /tmp/magisk_setup.sh << 'EOF'
#!/system/bin/sh

# Habilitar Zygisk (se ainda não estiver)
magisk --sqlite "UPDATE settings SET value=1 WHERE key='zygisk'"

# Configurar DenyList
echo "Configurando DenyList..."

# Apps que devem estar no DenyList
APPS=(
    "com.google.android.gms"
    "com.android.vending"
    "com.google.android.apps.walletnfcrel"
    "com.google.android.gms.pay"
)

for app in "${APPS[@]}"; do
    magisk --sqlite "INSERT OR REPLACE INTO denylist (package_name, process) VALUES ('$app', '$app')"
done

echo "DenyList configurado"
EOF

echo "1. Habilitando Zygisk..."
adb push /tmp/magisk_setup.sh /data/local/tmp/ 2>/dev/null || true
adb shell "su -c 'chmod 755 /data/local/tmp/magisk_setup.sh && /data/local/tmp/magisk_setup.sh'" || {
    echo -e "${YELLOW}⚠${NC} Não foi possível executar via ADB"
    echo "Configure manualmente no Magisk Manager:"
    echo "  - Settings → Zygisk: ON"
    echo "  - Settings → Configure DenyList"
}

echo ""
echo "=========================================="
echo "Configuração Manual Necessária"
echo "=========================================="
echo ""
echo "No dispositivo, abra o Magisk Manager e:"
echo ""
echo "1. Vá em Settings → Zygisk"
echo "   - Ative o Zygisk"
echo "   - Reinicie o dispositivo"
echo ""
echo "2. Após reiniciar, vá em Settings → Configure DenyList"
echo "   - Marque os seguintes apps:"
echo "     ✓ Google Play Services (com.google.android.gms)"
echo "     ✓ Google Play Store (com.android.vending)"
echo "     ✓ Google Wallet (com.google.android.apps.walletnfcrel)"
echo "     ✓ Google Pay (com.google.android.gms.pay)"
echo ""
echo "3. Instale os módulos necessários:"
echo "   - Play Integrity Fix (substitui Universal SafetyNet Fix)"
echo "     Download: https://github.com/chiteroman/PlayIntegrityFix"
echo ""
echo "   - Shamiko (opcional, para ocultar root melhor)"
echo "     Download: https://github.com/LSPosed/LSPosed.github.io/releases"
echo ""
echo "4. Reinicie o dispositivo"
echo ""
echo "5. Verifique o Play Integrity:"
echo "   - Instale o app 'Play Integrity API Checker'"
echo "   - Deve mostrar: Device Integrity: PASS"
echo ""
echo "6. Configure o Google Wallet:"
echo "   - Abra o Google Wallet"
echo "   - Adicione seus cartões"
echo "   - Teste o pagamento"
echo ""

# Limpar arquivo temporário
rm -f /tmp/magisk_setup.sh

echo "=========================================="
echo "Links Úteis"
echo "=========================================="
echo ""
echo "Play Integrity Fix:"
echo "https://github.com/chiteroman/PlayIntegrityFix"
echo ""
echo "Magisk Modules:"
echo "https://github.com/topjohnwu/Magisk"
echo ""
echo "Verificador de Play Integrity:"
echo "https://play.google.com/store/apps/details?id=gr.nikolasspyr.integritycheck"
echo ""
