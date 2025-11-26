# 🚀 Guia Rápido - Instalação de ROM no Mi 10T

## ⚡ Início Rápido

### 0. Instalar Dependências (Debian 13)
```bash
# Se estiver no Debian 13, instale dependências primeiro
./scripts/install_dependencies_debian.sh

# Consulte DEBIAN_13.md para detalhes
```

### 1. Verificar Pré-requisitos
```bash
./scripts/check_prerequisites.sh
```

### 2. Verificar Bootloader
```bash
./scripts/check_bootloader.sh
```

### 3. Fazer Backup
```bash
./scripts/backup_device.sh
```

### 4. Instalar TWRP
```bash
./scripts/install_twrp.sh twrp-apollo.img
```

### 5. Instalar ROM (no TWRP)
- Wipe completo
- Instalar ROM
- Instalar Magisk
- Reiniciar

### 6. Configurar Google Wallet
```bash
./scripts/setup_magisk.sh
```

---

## 📋 Checklist Completo

### Antes de Começar
- [ ] Backup completo feito
- [ ] Bootloader desbloqueado
- [ ] TWRP baixado
- [ ] ROM escolhida e baixada
- [ ] Magisk baixado
- [ ] GApps baixado (se necessário)
- [ ] Bateria com pelo menos 50%

### Durante a Instalação
- [ ] TWRP instalado
- [ ] Wipe completo feito
- [ ] ROM instalada
- [ ] GApps instalado (se necessário)
- [ ] Magisk instalado
- [ ] Primeira inicialização bem-sucedida

### Após a Instalação
- [ ] Magisk Manager instalado
- [ ] Zygisk ativado
- [ ] Play Integrity Fix instalado
- [ ] DenyList configurado
- [ ] Play Integrity passando
- [ ] Google Wallet funcionando

---

## 🎯 ROMs Recomendadas

| ROM | Dificuldade | Wallet | Link |
|-----|-------------|--------|------|
| LineageOS 21 | ⭐ Fácil | ✅ | [Download](https://download.lineageos.org/apollo) |
| Pixel Experience | ⭐ Fácil | ✅ | [Download](https://download.pixelexperience.org/apollo) |
| Evolution X | ⭐⭐ Média | ✅ | [Site](https://evolution-x.org/) |
| crDroid | ⭐⭐ Média | ✅ | [Download](https://crdroid.net/apollo) |

**Consulte [ROMS_COMPATIVEL_WALLET.md](ROMS_COMPATIVEL_WALLET.md) para detalhes completos.**

---

## 🔧 Comandos Úteis

### Verificar Dispositivo
```bash
adb devices
fastboot devices
```

### Reiniciar em Modos Especiais
```bash
# Recovery
adb reboot recovery

# Fastboot
adb reboot bootloader

# Download mode (se necessário)
adb reboot download
```

### Verificar Informações
```bash
# Modelo
adb shell getprop ro.product.model

# Android
adb shell getprop ro.build.version.release

# Bootloader
fastboot getvar unlocked
```

### Instalar APK
```bash
adb install app.apk
```

### Fazer Screenshot
```bash
adb shell screencap -p /sdcard/screenshot.png
adb pull /sdcard/screenshot.png
```

---

## ⚠️ Problemas Comuns

### Bootloader não desbloqueia
- Aguarde o tempo necessário (7-15 dias)
- Use a mesma conta Mi
- Tente em outro computador

### TWRP não funciona
- Baixe versão mais recente
- Verifique se bootloader está desbloqueado
- Tente OrangeFox como alternativa

### Google Wallet não funciona
1. Verifique Play Integrity Fix instalado
2. Confirme DenyList configurado
3. Limpe cache do Google Play Services
4. Reinstale o Wallet

### Bootloop
1. Entre no TWRP (Volume + + Power)
2. Restaure backup ou reinstale ROM
3. Se necessário, volte ao MIUI via Mi Flash Tool

---

## 📚 Documentação Completa

- **[README.md](README.md)** - Guia completo passo a passo
- **[ROMS_COMPATIVEL_WALLET.md](ROMS_COMPATIVEL_WALLET.md)** - Lista de ROMs compatíveis
- **Scripts/** - Scripts de automação

---

## 🆘 Suporte

- **XDA Forum**: https://forum.xda-developers.com/c/xiaomi-mi-10t-mi-10t-pro.11547/
- **Telegram**: Busque grupos da ROM escolhida
- **GitHub Issues**: Para problemas com os scripts

---

**Boa sorte com a instalação! 🎉**
