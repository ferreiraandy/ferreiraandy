# 📑 Índice - Guia de Instalação de ROM para Mi 10T

## 📚 Documentação

### 🚀 Para Começar
- **[GUIA_RAPIDO.md](GUIA_RAPIDO.md)** - Guia rápido com comandos essenciais
- **[REQUISITOS.md](REQUISITOS.md)** - Requisitos do sistema e software necessário
- **[README.md](README.md)** - Guia completo passo a passo
- **[ROMS_COMPATIVEL_WALLET.md](ROMS_COMPATIVEL_WALLET.md)** - Lista de ROMs compatíveis com Google Wallet

## 🔧 Scripts de Automação

Todos os scripts estão na pasta `scripts/` e são executáveis.

### Verificação e Preparação
- **`check_prerequisites.sh`** - Verifica pré-requisitos (ADB, Fastboot, conexão)
- **`check_bootloader.sh`** - Verifica status do bootloader
- **`check_device_compatibility.sh`** - Verifica compatibilidade do dispositivo

### Backup e Instalação
- **`backup_device.sh`** - Faz backup do dispositivo via ADB
- **`install_twrp.sh`** - Instala TWRP Recovery automaticamente
- **`install_rom.sh`** - Script principal que guia todo o processo

### Configuração Pós-Instalação
- **`setup_magisk.sh`** - Configura Magisk para Google Wallet

## 📋 Fluxo de Trabalho Recomendado

```
1. check_prerequisites.sh
   ↓
2. check_bootloader.sh
   ↓
3. backup_device.sh
   ↓
4. install_twrp.sh
   ↓
5. Instalar ROM manualmente no TWRP
   ↓
6. setup_magisk.sh
   ↓
7. Configurar Google Wallet
```

Ou use o script principal:
```
./scripts/install_rom.sh
```

## 🎯 ROMs Recomendadas

Consulte **[ROMS_COMPATIVEL_WALLET.md](ROMS_COMPATIVEL_WALLET.md)** para:
- Lista completa de ROMs
- Links de download
- Instruções específicas
- Comparação entre ROMs

### Top 3 Recomendações:
1. **LineageOS 21** - Mais estável
2. **Pixel Experience** - Experiência Pixel
3. **Evolution X** - Muitas customizações

## ⚠️ Avisos Importantes

- ⚠️ Este processo **apaga todos os dados**
- ⚠️ Pode **anular a garantia**
- ⚠️ Há risco de **"brick"** do dispositivo
- ✅ **Sempre faça backup** antes de começar
- ✅ **Leia o guia completo** antes de começar

## 🆘 Suporte

- **XDA Forum**: https://forum.xda-developers.com/c/xiaomi-mi-10t-mi-10t-pro.11547/
- **Telegram**: Busque grupos da ROM escolhida
- **Documentação**: Leia os arquivos .md deste repositório

## 📝 Estrutura do Projeto

```
/workspace/
├── README.md                      # Guia completo
├── GUIA_RAPIDO.md                 # Guia rápido
├── REQUISITOS.md                   # Requisitos do sistema
├── ROMS_COMPATIVEL_WALLET.md      # Lista de ROMs
├── INDEX.md                       # Este arquivo
└── scripts/
    ├── check_prerequisites.sh
    ├── check_bootloader.sh
    ├── check_device_compatibility.sh
    ├── backup_device.sh
    ├── install_twrp.sh
    ├── install_rom.sh
    └── setup_magisk.sh
```

---

**Boa sorte com a instalação! 🎉**
