# 🐧 Guia Específico para Debian 13

Este guia é específico para instalação de ROM customizada no Mi 10T usando **Debian 13 (Trixie)**.

## 📋 Pré-requisitos do Debian 13

### Verificar Versão do Debian
```bash
cat /etc/debian_version
lsb_release -a
```

### Atualizar Sistema
```bash
sudo apt update
sudo apt upgrade -y
```

## 🔧 Instalação de Dependências

### 1. Instalar ADB e Fastboot

#### Opção A: Via Repositório Debian (Recomendado)
```bash
sudo apt update
sudo apt install -y android-tools-adb android-tools-fastboot
```

#### Opção B: Via Android Platform Tools (Mais Recente)
```bash
# Baixar Android Platform Tools
cd /tmp
wget https://dl.google.com/android/repository/platform-tools-latest-linux.zip
unzip platform-tools-latest-linux.zip

# Mover para diretório do sistema
sudo mv platform-tools /opt/
sudo ln -sf /opt/platform-tools/adb /usr/local/bin/adb
sudo ln -sf /opt/platform-tools/fastboot /usr/local/bin/fastboot

# Verificar instalação
adb version
fastboot --version
```

### 2. Configurar Regras USB (Importante!)

No Debian, você precisa configurar regras udev para acessar o dispositivo sem sudo:

```bash
# Criar arquivo de regras
sudo nano /etc/udev/rules.d/51-android.rules
```

Adicione estas linhas:
```
# Xiaomi devices
SUBSYSTEM=="usb", ATTR{idVendor}=="2717", MODE="0664", GROUP="plugdev"
SUBSYSTEM=="usb", ATTR{idVendor}=="18d1", MODE="0664", GROUP="plugdev"

# Google devices (para fastboot)
SUBSYSTEM=="usb", ATTR{idVendor}=="18d1", MODE="0664", GROUP="plugdev"
```

Aplicar regras:
```bash
# Recarregar regras udev
sudo udevadm control --reload-rules
sudo udevadm trigger

# Adicionar usuário ao grupo plugdev
sudo usermod -aG plugdev $USER

# Reiniciar sessão ou fazer logout/login
```

### 3. Instalar Dependências Adicionais

```bash
# Ferramentas essenciais
sudo apt install -y \
    wget \
    unzip \
    curl \
    git \
    usbutils \
    udev

# Para desenvolvimento (opcional)
sudo apt install -y \
    build-essential \
    python3 \
    python3-pip
```

## 🔌 Configuração USB

### Verificar Dispositivo USB Conectado
```bash
# Listar dispositivos USB
lsusb

# Verificar se o dispositivo aparece
# Procure por "Xiaomi" ou "Qualcomm"
```

### Testar Conexão ADB
```bash
# Conectar dispositivo e ativar depuração USB
adb devices

# Se aparecer "unauthorized", aceite no dispositivo
# Se aparecer "no permissions", configure as regras udev acima
```

### Testar Fastboot
```bash
# Entrar em modo fastboot no dispositivo
# Volume - + Power
fastboot devices

# Se não funcionar, tente com sudo (temporário)
sudo fastboot devices
```

## 🚫 Problemas Específicos do Debian 13

### Problema: "adb: command not found"
**Solução:**
```bash
sudo apt install android-tools-adb
# Ou instale via Platform Tools (veja acima)
```

### Problema: "no permissions" no ADB
**Solução:**
1. Configure regras udev (veja acima)
2. Adicione usuário ao grupo plugdev
3. Reinicie sessão
4. Verifique: `groups` (deve mostrar plugdev)

### Problema: Fastboot requer sudo
**Solução:**
```bash
# Configure regras udev (veja acima)
# Ou use temporariamente: sudo fastboot ...
```

### Problema: Dispositivo não é reconhecido
**Solução:**
```bash
# Verificar se dispositivo está conectado
lsusb

# Verificar regras udev
ls -la /etc/udev/rules.d/51-android.rules

# Recarregar regras
sudo udevadm control --reload-rules
sudo udevadm trigger

# Desconectar e reconectar dispositivo
```

## 📱 Mi Unlock Tool no Debian

⚠️ **Importante**: O Mi Unlock Tool oficial só funciona no Windows.

### Alternativas:

#### Opção 1: Usar Windows (Recomendado)
- Use uma máquina Windows para desbloquear
- Ou use Windows em VM (pode não funcionar bem)

#### Opção 2: Desbloquear via Fastboot (Avançado)
Alguns dispositivos podem ser desbloqueados diretamente via fastboot, mas isso requer:
- Bootloader já parcialmente desbloqueado
- Conhecimento avançado
- **Não recomendado para iniciantes**

#### Opção 3: Usar Serviço de Desbloqueio
- Alguns serviços online podem ajudar
- **Use por sua conta e risco**

## 🔧 Script de Instalação Automática

Execute o script de instalação de dependências:

```bash
./scripts/install_dependencies_debian.sh
```

Este script irá:
- Instalar ADB e Fastboot
- Configurar regras udev
- Adicionar usuário ao grupo plugdev
- Verificar instalação

## 📝 Checklist para Debian 13

Antes de começar:

- [ ] Debian 13 instalado e atualizado
- [ ] ADB e Fastboot instalados
- [ ] Regras udev configuradas
- [ ] Usuário no grupo plugdev
- [ ] Dispositivo reconhecido via `adb devices`
- [ ] Fastboot funcionando (com ou sem sudo)
- [ ] Bootloader desbloqueado (pode precisar Windows)
- [ ] TWRP baixado
- [ ] ROM escolhida e baixada
- [ ] Magisk baixado

## 🚀 Fluxo de Trabalho no Debian 13

### 1. Preparação
```bash
# Instalar dependências
./scripts/install_dependencies_debian.sh

# Verificar pré-requisitos
./scripts/check_prerequisites.sh
```

### 2. Verificação
```bash
# Verificar dispositivo
./scripts/check_device_compatibility.sh

# Verificar bootloader
./scripts/check_bootloader.sh
```

### 3. Backup
```bash
# Fazer backup
./scripts/backup_device.sh
```

### 4. Instalação
```bash
# Instalar TWRP
./scripts/install_twrp.sh twrp-apollo.img

# Instalar ROM (no TWRP)
# Siga instruções no README.md
```

### 5. Configuração
```bash
# Configurar Magisk
./scripts/setup_magisk.sh
```

## 🔍 Comandos Úteis no Debian

### Verificar Permissões USB
```bash
# Ver grupos do usuário
groups

# Verificar regras udev
cat /etc/udev/rules.d/51-android.rules

# Ver dispositivos USB
lsusb -v | grep -i xiaomi
```

### Debug de Problemas
```bash
# Ver logs do udev
sudo journalctl -u systemd-udevd

# Ver informações do dispositivo
lsusb -v -d 2717:*

# Testar ADB com verbose
adb -d devices -l
```

## 📚 Recursos Adicionais

- [Debian Wiki - Android Development](https://wiki.debian.org/Android)
- [Android Developers - Setup](https://developer.android.com/studio/run/device)
- [XDA - Linux ADB Setup](https://www.xda-developers.com/install-adb-windows-macos-linux/)

## ⚠️ Notas Importantes

1. **Mi Unlock Tool**: Ainda requer Windows. Você pode:
   - Usar outra máquina Windows
   - Usar Windows em dual boot
   - Usar VM (pode não funcionar)

2. **Permissões**: Sempre configure as regras udev para evitar usar sudo

3. **Atualizações**: Mantenha o Debian atualizado:
   ```bash
   sudo apt update && sudo apt upgrade
   ```

4. **Backup**: Sempre faça backup antes de modificar o dispositivo

---

**Boa sorte com a instalação no Debian 13! 🐧**
