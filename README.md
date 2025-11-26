# Guia Completo: Instalar ROM Customizada no Xiaomi Mi 10T com Google Wallet

## 📱 Sobre o Dispositivo
- **Modelo**: Xiaomi Mi 10T / Mi 10T Pro
- **Codinome**: apollo / apollopro
- **SoC**: Snapdragon 865
- **Android Original**: MIUI (baseado em Android)

## ⚠️ AVISOS IMPORTANTES

1. **Este processo apaga TODOS os dados do dispositivo**
2. **Pode anular a garantia do dispositivo**
3. **Há risco de "brick" (deixar o dispositivo inutilizável)**
4. **Faça backup completo antes de começar**
5. **Você é responsável por qualquer dano ao dispositivo**

## 📋 Pré-requisitos

### Hardware Necessário
- Computador com Windows/Linux/Mac
- Cabo USB de boa qualidade
- Bateria do Mi 10T com pelo menos 50% de carga

### Software Necessário
- [Mi Unlock Tool](https://www.mi.com/unlock) (para desbloquear bootloader)
- [ADB e Fastboot](https://developer.android.com/tools/releases/platform-tools)
- [TWRP Recovery](https://twrp.me/xiaomi/xiaomimi10t.html) (recovery customizado)
- ROM customizada compatível
- [Magisk](https://github.com/topjohnwu/Magisk) (para root e passar SafetyNet)

## 🎯 ROMs Recomendadas com Suporte a Google Wallet

Para uma lista completa e detalhada de ROMs compatíveis, consulte: **[ROMS_COMPATIVEL_WALLET.md](ROMS_COMPATIVEL_WALLET.md)**

### ROMs Principais:

1. **LineageOS 21** - Mais estável e suportada oficialmente
2. **Pixel Experience Plus** - Experiência Pixel completa
3. **Evolution X** - Muitas customizações
4. **crDroid** - Baseado em LineageOS com extras

Todas funcionam com Google Wallet após configurar o Magisk corretamente!

## 📝 Passo a Passo Completo

### FASE 1: Preparação e Backup

#### 1.1 Habilitar Opções de Desenvolvedor
1. Vá em **Configurações** → **Sobre o telefone**
2. Toque 7 vezes em **Versão MIUI**
3. Volte para **Configurações** → **Configurações adicionais** → **Opções do desenvolvedor**
4. Ative:
   - ✅ **Depuração USB**
   - ✅ **Bloqueio OEM** (se disponível)
   - ✅ **Instalar via USB**

#### 1.2 Fazer Backup Completo
```bash
# Execute o script de backup
./scripts/backup_device.sh
```

Ou manualmente:
- Use o app de backup do MIUI
- Faça backup de fotos, vídeos e documentos no Google Drive
- Anote todas as senhas e configurações importantes

### FASE 2: Desbloqueio do Bootloader

#### 2.1 Solicitar Permissão de Desbloqueio
1. Acesse: https://www.mi.com/unlock
2. Faça login com sua conta Mi
3. Solicite permissão para desbloquear
4. **Aguarde 7-15 dias** para aprovação (pode ser instantâneo em alguns casos)

#### 2.2 Instalar Mi Unlock Tool
1. Baixe o [Mi Unlock Tool](https://www.mi.com/unlock/download)
2. Instale no Windows (ou use versão Linux se disponível)
3. Faça login com a mesma conta Mi

#### 2.3 Desbloquear Bootloader
1. Conecte o Mi 10T ao PC via USB
2. Abra o Mi Unlock Tool
3. Siga as instruções na tela
4. **ATENÇÃO**: Isso apagará todos os dados!

```bash
# Verificar se o bootloader está desbloqueado
./scripts/check_bootloader.sh
```

### FASE 3: Instalar TWRP Recovery

#### 3.1 Baixar TWRP
1. Baixe a versão mais recente do TWRP para Mi 10T (apollo)
2. Link: https://twrp.me/xiaomi/xiaomimi10t.html

#### 3.2 Instalar TWRP via Fastboot
```bash
# Execute o script de instalação do TWRP
./scripts/install_twrp.sh
```

Ou manualmente:
```bash
# Reiniciar em modo fastboot
adb reboot bootloader

# Verificar conexão
fastboot devices

# Instalar TWRP
fastboot flash recovery twrp-apollo.img

# Reiniciar em recovery (IMPORTANTE: não reinicie normalmente!)
fastboot reboot recovery
```

⚠️ **IMPORTANTE**: Após instalar TWRP, reinicie diretamente no recovery. Se reiniciar normalmente, o MIUI pode sobrescrever o TWRP.

### FASE 4: Instalar ROM Customizada

#### 4.1 Preparar Arquivos
1. Baixe a ROM customizada escolhida
2. Baixe o [GApps](https://opengapps.org/) (se necessário)
3. Baixe o [Magisk](https://github.com/topjohnwu/Magisk/releases) (para Google Wallet)

#### 4.2 Transferir Arquivos para o Dispositivo
```bash
# Usar ADB para transferir arquivos
adb push rom.zip /sdcard/
adb push gapps.zip /sdcard/
adb push magisk.zip /sdcard/
```

#### 4.3 Fazer Wipe no TWRP
1. No TWRP, vá em **Wipe**
2. Selecione **Format Data** (digite "yes" para confirmar)
3. Volte e selecione **Advanced Wipe**
4. Marque:
   - ✅ **Dalvik / ART Cache**
   - ✅ **System**
   - ✅ **Data**
   - ✅ **Cache**
5. Deslize para fazer wipe

#### 4.4 Instalar ROM
1. No TWRP, vá em **Install**
2. Selecione o arquivo da ROM (rom.zip)
3. Deslize para instalar
4. Aguarde a instalação completar

#### 4.5 Instalar GApps (se necessário)
1. Ainda no TWRP, vá em **Install**
2. Selecione o arquivo GApps
3. Deslize para instalar

#### 4.6 Instalar Magisk
1. No TWRP, vá em **Install**
2. Selecione o arquivo Magisk
3. Deslize para instalar
4. **NÃO reinicie ainda!**

#### 4.7 Reiniciar
1. Vá em **Reboot** → **System**
2. A primeira inicialização pode levar 5-10 minutos

### FASE 5: Configurar Google Wallet

#### 5.1 Instalar Magisk (se não instalou antes)
1. Baixe o [Magisk Manager](https://github.com/topjohnwu/Magisk/releases)
2. Instale o APK no dispositivo

#### 5.2 Configurar Magisk para passar SafetyNet
1. Abra o Magisk Manager
2. Vá em **Settings** → Ative **Zygisk**
3. Reinicie o dispositivo
4. Instale módulos necessários:
   - **Play Integrity Fix** (substitui o antigo Universal SafetyNet Fix)
   - **Shamiko** (para ocultar root de apps específicos)

#### 5.3 Configurar DenyList
1. No Magisk Manager, vá em **Settings** → **Configure DenyList**
2. Marque:
   - ✅ **Google Play Services**
   - ✅ **Google Play Store**
   - ✅ **Google Wallet**
   - ✅ **Google Pay**

#### 5.4 Verificar SafetyNet/Play Integrity
```bash
# Usar app YASNAC ou Play Integrity API Checker
# Deve mostrar: "PASS" em ambos os testes
```

#### 5.5 Configurar Google Wallet
1. Abra o Google Wallet
2. Adicione seus cartões
3. Teste o pagamento

## 🔧 Scripts de Automação

Este repositório inclui scripts para automatizar partes do processo:

- `scripts/check_prerequisites.sh` - Verifica pré-requisitos
- `scripts/check_bootloader.sh` - Verifica status do bootloader
- `scripts/install_twrp.sh` - Instala TWRP automaticamente
- `scripts/backup_device.sh` - Faz backup via ADB
- `scripts/setup_magisk.sh` - Configura Magisk para Google Wallet

## 🐛 Solução de Problemas

### Bootloader não desbloqueia
- Verifique se aguardou o tempo necessário
- Certifique-se de usar a mesma conta Mi
- Tente em outro computador

### TWRP não funciona
- Baixe a versão mais recente
- Tente versão alternativa (OrangeFox, etc.)
- Verifique se o bootloader está realmente desbloqueado

### Google Wallet não funciona
- Verifique se o Play Integrity Fix está instalado
- Certifique-se de que os apps estão no DenyList
- Limpe cache do Google Play Services
- Algumas ROMs podem precisar de configurações adicionais

### Bootloop (dispositivo não inicia)
- Entre no recovery (TWRP)
- Restaure backup ou reinstale a ROM
- Se necessário, volte ao MIUI original via Mi Flash Tool

## 📚 Recursos Adicionais

- [XDA Forum - Mi 10T](https://forum.xda-developers.com/c/xiaomi-mi-10t-mi-10t-pro.11547/)
- [LineageOS Wiki - Apollo](https://wiki.lineageos.org/devices/apollo/)
- [Magisk GitHub](https://github.com/topjohnwu/Magisk)
- [Play Integrity Fix](https://github.com/chiteroman/PlayIntegrityFix)

## ⚖️ Disclaimer Legal

Este guia é fornecido apenas para fins educacionais. O uso de ROMs customizadas pode:
- Anular a garantia do dispositivo
- Violar termos de serviço de alguns apps
- Causar problemas de segurança

Use por sua conta e risco.

## 📞 Suporte

Para problemas específicos:
1. Consulte os fóruns XDA do seu dispositivo
2. Verifique o Telegram do desenvolvedor da ROM
3. Leia a documentação oficial da ROM escolhida

---

**Última atualização**: 2024
**Versão do guia**: 1.0
