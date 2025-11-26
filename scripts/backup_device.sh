#!/bin/bash

# Script para fazer backup do dispositivo Mi 10T via ADB
# Uso: ./backup_device.sh

set -e

# Cores
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo "=========================================="
echo "Backup do Dispositivo - Mi 10T"
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

DEVICE=$(adb devices | grep "device$" | awk '{print $1}')
MODEL=$(adb shell getprop ro.product.model 2>/dev/null || echo "Unknown")
SERIAL=$(adb shell getprop ro.serialno 2>/dev/null || echo "Unknown")

echo -e "${GREEN}✓${NC} Dispositivo conectado: $MODEL ($SERIAL)"
echo ""

# Criar diretório de backup
BACKUP_DIR="backup_$(date +%Y%m%d_%H%M%S)"
mkdir -p "$BACKUP_DIR"

echo "Diretório de backup: $BACKUP_DIR"
echo ""

# Função para fazer backup de um diretório
backup_directory() {
    local source=$1
    local dest=$2
    
    echo -e "${BLUE}Backup:${NC} $source"
    
    if adb shell "[ -d $source ]" 2>/dev/null; then
        adb pull "$source" "$dest" 2>/dev/null || echo -e "${YELLOW}⚠${NC} Alguns arquivos podem não ter sido copiados"
        echo -e "${GREEN}✓${NC} Concluído"
    else
        echo -e "${YELLOW}⚠${NC} Diretório não existe ou sem permissão"
    fi
    echo ""
}

# Backup de informações do sistema
echo "1. Fazendo backup de informações do sistema..."
adb shell getprop > "$BACKUP_DIR/system_properties.txt" 2>/dev/null || true
echo -e "${GREEN}✓${NC} Propriedades do sistema salvas"
echo ""

# Backup de apps instalados
echo "2. Listando apps instalados..."
adb shell pm list packages -3 > "$BACKUP_DIR/user_apps.txt" 2>/dev/null || true
adb shell pm list packages > "$BACKUP_DIR/all_apps.txt" 2>/dev/null || true
echo -e "${GREEN}✓${NC} Lista de apps salva"
echo ""

# Backup de dados do usuário (requer root ou permissões especiais)
echo "3. Tentando fazer backup de dados do usuário..."
echo -e "${YELLOW}⚠${NC} Alguns diretórios podem requerer root"
echo ""

# Tentar backup de diretórios comuns
DIRECTORIES=(
    "/sdcard/DCIM"
    "/sdcard/Pictures"
    "/sdcard/Download"
    "/sdcard/Documents"
    "/sdcard/Music"
    "/sdcard/Movies"
)

for dir in "${DIRECTORIES[@]}"; do
    backup_directory "$dir" "$BACKUP_DIR/$(basename $dir)"
done

# Backup de configurações (se possível)
echo "4. Tentando backup de configurações..."
if adb shell "[ -d /data/data ]" 2>/dev/null; then
    echo -e "${YELLOW}⚠${NC} Backup completo de /data requer root"
    echo "   Use o app de backup do MIUI ou TWRP para backup completo"
else
    echo -e "${YELLOW}⚠${NC} Sem acesso root, backup limitado"
fi
echo ""

# Criar script de restauração
cat > "$BACKUP_DIR/RESTORE_README.txt" << EOF
BACKUP DO DISPOSITIVO - $(date)

Modelo: $MODEL
Serial: $SERIAL
Data: $(date)

CONTEÚDO DO BACKUP:
- system_properties.txt: Propriedades do sistema
- user_apps.txt: Lista de apps do usuário
- all_apps.txt: Lista de todos os apps
- Diretórios do /sdcard (se disponíveis)

IMPORTANTE:
Este backup NÃO inclui:
- Dados de apps (requer root)
- Configurações completas do sistema
- Dados de apps protegidos

Para backup completo:
1. Use o app de backup do MIUI antes de desbloquear
2. Faça backup no TWRP após instalar recovery
3. Use apps como Titanium Backup (com root)

RESTAURAÇÃO:
- Apps: Instale manualmente da Play Store
- Fotos/Vídeos: Copie de volta para /sdcard
- Configurações: Configure manualmente após instalar ROM
EOF

echo "=========================================="
echo "Backup concluído!"
echo "=========================================="
echo ""
echo "Localização: $BACKUP_DIR"
echo ""
echo -e "${YELLOW}⚠ IMPORTANTE ⚠${NC}"
echo "Este backup é PARCIAL. Para backup completo:"
echo "1. Use o app de backup do MIUI"
echo "2. Faça backup no TWRP (após instalar)"
echo "3. Salve fotos/vídeos no Google Photos ou PC"
echo ""

# Calcular tamanho do backup
if command -v du &> /dev/null; then
    SIZE=$(du -sh "$BACKUP_DIR" | awk '{print $1}')
    echo "Tamanho do backup: $SIZE"
fi
