# ROMs Compatíveis com Google Wallet para Mi 10T

## 📱 ROMs Oficialmente Suportadas

### 1. LineageOS 21 (Android 14)
**Status**: ✅ Recomendado  
**Suporte a Wallet**: ✅ Sim (com Magisk + Play Integrity Fix)

- **Download**: https://download.lineageos.org/apollo
- **Fórum XDA**: https://forum.xda-developers.com/t/rom-official-apollo-apollopro-lineageos-21-0.4652000/
- **Telegram**: Busque por "LineageOS apollo"
- **Características**:
  - Atualizações semanais
  - Base AOSP limpa
  - Boa performance
  - Suporte oficial

**Instalação do Wallet**:
1. Instale Magisk
2. Instale Play Integrity Fix
3. Configure DenyList
4. Wallet funcionará normalmente

---

### 2. Pixel Experience Plus (Android 14)
**Status**: ✅ Recomendado  
**Suporte a Wallet**: ✅ Sim (com Magisk)

- **Download**: https://download.pixelexperience.org/apollo
- **Fórum XDA**: Busque "Pixel Experience apollo"
- **Características**:
  - Interface idêntica ao Google Pixel
  - Recursos do Pixel (Now Playing, etc.)
  - Atualizações mensais
  - GApps incluído

**Instalação do Wallet**:
- Geralmente funciona sem configuração adicional
- Se necessário, instale Play Integrity Fix

---

### 3. Evolution X (Android 14)
**Status**: ✅ Recomendado  
**Suporte a Wallet**: ✅ Sim

- **Download**: https://evolution-x.org/
- **Fórum XDA**: Busque "Evolution X apollo"
- **Características**:
  - Muitas customizações
  - Interface moderna
  - Base AOSP
  - Atualizações frequentes

**Instalação do Wallet**:
1. Instale Magisk
2. Instale Play Integrity Fix
3. Configure normalmente

---

### 4. crDroid (Android 14)
**Status**: ✅ Recomendado  
**Suporte a Wallet**: ✅ Sim

- **Download**: https://crdroid.net/apollo
- **Fórum XDA**: Busque "crDroid apollo"
- **Características**:
  - Baseado em LineageOS
  - Muitas opções de customização
  - Performance otimizada
  - Atualizações semanais

**Instalação do Wallet**:
- Similar ao LineageOS
- Requer Magisk + Play Integrity Fix

---

### 5. ArrowOS (Android 14)
**Status**: ✅ Bom  
**Suporte a Wallet**: ✅ Sim

- **Download**: https://arrowos.net/download/apollo
- **Características**:
  - Foco em performance
  - Interface limpa
  - Boa bateria

---

### 6. Project Elixir (Android 14)
**Status**: ✅ Bom  
**Suporte a Wallet**: ✅ Sim

- **Download**: https://projectelixiros.com/
- **Características**:
  - Interface customizada
  - Muitas features
  - Atualizações regulares

---

## ⚠️ ROMs que PODEM ter problemas com Wallet

### 1. ROMs não certificadas
- Algumas ROMs não passam no Play Integrity por padrão
- Solução: Sempre instale Play Integrity Fix

### 2. ROMs antigas (Android 11-12)
- Podem ter problemas com versões mais novas do Wallet
- Recomendação: Use ROMs baseadas em Android 13+

### 3. ROMs com root integrado
- Algumas ROMs vêm com root, o que pode causar problemas
- Solução: Use Magisk com DenyList configurado

---

## 🔧 Configuração Necessária para Google Wallet

### Passo 1: Instalar Magisk
1. Baixe o [Magisk](https://github.com/topjohnwu/Magisk/releases)
2. Instale via TWRP
3. Instale o Magisk Manager APK

### Passo 2: Configurar Zygisk
1. Abra Magisk Manager
2. Settings → Zygisk: **ON**
3. Reinicie o dispositivo

### Passo 3: Instalar Play Integrity Fix
1. Baixe: https://github.com/chiteroman/PlayIntegrityFix/releases
2. Instale via Magisk Manager (Modules → Install from storage)
3. Reinicie

### Passo 4: Configurar DenyList
1. Magisk Manager → Settings → Configure DenyList
2. Marque:
   - ✅ Google Play Services
   - ✅ Google Play Store
   - ✅ Google Wallet
   - ✅ Google Pay

### Passo 5: Verificar
1. Instale "Play Integrity API Checker" da Play Store
2. Deve mostrar: **Device Integrity: PASS**
3. Se passar, o Wallet funcionará

---

## 📊 Comparação Rápida

| ROM | Android | Wallet | Atualizações | Dificuldade |
|-----|---------|--------|--------------|-------------|
| LineageOS 21 | 14 | ✅ | Semanal | Fácil |
| Pixel Experience | 14 | ✅ | Mensal | Fácil |
| Evolution X | 14 | ✅ | Frequente | Média |
| crDroid | 14 | ✅ | Semanal | Média |
| ArrowOS | 14 | ✅ | Semanal | Fácil |

---

## 🎯 Recomendação Final

**Para melhor compatibilidade com Google Wallet**:
1. **LineageOS 21** - Mais estável e suportada
2. **Pixel Experience** - Se quiser experiência Pixel
3. **Evolution X** - Se quiser muitas customizações

**Todas funcionam com Wallet após configurar Magisk corretamente!**

---

## 📚 Links Úteis

- [Play Integrity Fix](https://github.com/chiteroman/PlayIntegrityFix)
- [Magisk](https://github.com/topjohnwu/Magisk)
- [XDA Mi 10T Forum](https://forum.xda-developers.com/c/xiaomi-mi-10t-mi-10t-pro.11547/)
- [LineageOS Wiki](https://wiki.lineageos.org/devices/apollo/)

---

**Última atualização**: 2024
