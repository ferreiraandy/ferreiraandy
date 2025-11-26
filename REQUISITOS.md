# 📋 Requisitos do Sistema

## 💻 Computador

### Sistema Operacional
- ✅ **Debian 13** (Trixie) - Este guia é otimizado para Debian 13
- ✅ **Windows 10/11** (recomendado para Mi Unlock Tool)
- ✅ **Linux** (Ubuntu, outras distribuições)
- ✅ **macOS** (com algumas limitações)

**Nota**: Para Debian 13, consulte **[DEBIAN_13.md](DEBIAN_13.md)** para instruções específicas.

### Especificações Mínimas
- Processador: Qualquer processador moderno
- RAM: 4GB (8GB recomendado)
- Espaço em disco: 5GB livres
- Porta USB: USB 2.0 ou superior

## 📱 Dispositivo (Mi 10T)

### Modelos Compatíveis
- ✅ **Xiaomi Mi 10T** (apollo)
- ✅ **Xiaomi Mi 10T Pro** (apollopro)

### Requisitos do Dispositivo
- Bateria: **Mínimo 50%** (recomendado 80%+)
- Bootloader: Deve estar desbloqueado
- Storage: Espaço suficiente para ROM (pelo menos 5GB livres)

## 🔧 Software Necessário

### 1. Android SDK Platform Tools (ADB e Fastboot)
**Download**: https://developer.android.com/tools/releases/platform-tools

#### Windows
1. Baixe o ZIP
2. Extraia em uma pasta (ex: `C:\platform-tools`)
3. Adicione ao PATH ou use do diretório

#### Linux (Debian 13)
```bash
# Debian 13 - Instalação via apt
sudo apt update
sudo apt install android-tools-adb android-tools-fastboot

# Ou use o script de instalação automática
./scripts/install_dependencies_debian.sh

# Para instruções detalhadas, consulte: DEBIAN_13.md
```

#### Linux (Outras distribuições)
```bash
# Ubuntu
sudo apt update
sudo apt install android-tools-adb android-tools-fastboot

# Fedora
sudo dnf install android-tools

# Arch Linux
sudo pacman -S android-tools
```

#### macOS
```bash
# Via Homebrew
brew install android-platform-tools

# Ou baixe do site oficial
```

### 2. Mi Unlock Tool (Apenas Windows)
**Download**: https://www.mi.com/unlock/download

⚠️ **Importante**: 
- Funciona melhor no Windows
- Requer conta Mi
- Pode levar 7-15 dias para aprovação

### 3. TWRP Recovery
**Download**: https://twrp.me/xiaomi/xiaomimi10t.html

- Baixe a versão mais recente para **apollo** (Mi 10T)
- Arquivo: `twrp-*-apollo.img`

### 4. ROM Customizada
Escolha uma das ROMs recomendadas em **[ROMS_COMPATIVEL_WALLET.md](ROMS_COMPATIVEL_WALLET.md)**

### 5. Magisk
**Download**: https://github.com/topjohnwu/Magisk/releases

- Baixe: `Magisk-*.apk` (Manager)
- Baixe: `Magisk-*.zip` (para instalar via TWRP)

### 6. GApps (se necessário)
**Download**: https://opengapps.org/

- Escolha: ARM64, Android 14 (ou versão da ROM), Variante recomendada: **Stock** ou **Full**

### 7. Play Integrity Fix
**Download**: https://github.com/chiteroman/PlayIntegrityFix/releases

- Baixe o arquivo `.zip` mais recente
- Instale via Magisk Manager após instalar a ROM

## 🔌 Hardware Necessário

### Cabo USB
- ✅ Cabo USB de boa qualidade
- ✅ USB 2.0 ou superior
- ⚠️ Evite cabos muito longos ou de baixa qualidade

### Porta USB
- ✅ Porta USB 2.0 ou 3.0
- ⚠️ Evite hubs USB (conecte diretamente)

## 📦 Arquivos Necessários (Checklist)

Antes de começar, tenha todos estes arquivos:

- [ ] **TWRP Recovery** (`twrp-*-apollo.img`)
- [ ] **ROM Customizada** (`rom.zip`)
- [ ] **Magisk** (`Magisk-*.zip` e `Magisk-*.apk`)
- [ ] **GApps** (`open_gapps-*.zip`) - se necessário
- [ ] **Play Integrity Fix** (`PlayIntegrityFix-*.zip`)

## 🧪 Verificação de Requisitos

Execute o script de verificação:
```bash
./scripts/check_prerequisites.sh
```

Este script verifica:
- ✅ ADB instalado e funcionando
- ✅ Fastboot instalado e funcionando
- ✅ Dispositivo conectado
- ✅ Depuração USB ativada
- ✅ Nível de bateria adequado
- ✅ Arquivos necessários presentes

## 🚫 Problemas Comuns

### ADB não reconhece o dispositivo
1. Instale drivers USB (Windows)
2. Ative depuração USB no dispositivo
3. Aceite o prompt de autorização no dispositivo
4. Tente outro cabo USB

### Fastboot não funciona
1. Verifique se o dispositivo está em modo fastboot
2. No Debian/Linux, configure regras udev (veja DEBIAN_13.md)
3. Se ainda não funcionar, use temporariamente:
   ```bash
   sudo fastboot devices
   ```
4. Tente outro cabo/porta USB
5. **Debian 13**: Execute `./scripts/install_dependencies_debian.sh` para configurar tudo

### Mi Unlock Tool não funciona
1. Use Windows (funciona melhor)
2. Certifique-se de estar logado na conta Mi correta
3. Aguarde a aprovação (pode levar dias)
4. Tente em outro computador

## 📚 Links Úteis

- [Android Platform Tools](https://developer.android.com/tools/releases/platform-tools)
- [Mi Unlock Tool](https://www.mi.com/unlock)
- [TWRP](https://twrp.me/)
- [Magisk](https://github.com/topjohnwu/Magisk)
- [OpenGApps](https://opengapps.org/)
- [Play Integrity Fix](https://github.com/chiteroman/PlayIntegrityFix)

---

**Certifique-se de ter todos os requisitos antes de começar! ✅**
