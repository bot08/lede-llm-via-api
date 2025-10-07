# AI Client on LEDE 17.01 (OpenWrt)

This project demonstrates how to run a simple AI client directly on an OpenWrt/LEDE 17.01 router using **temporary RAM storage**. Tested on a 4/32 router.

---

## Installation

### 1. Configure `opkg` to install packages into RAM

```bash
# Add a temporary installation destination
echo "dest ram /tmp" >> /etc/opkg.conf

# Update package lists
opkg update
```

### 2. Install required packages

```bash
# Install curl and CA certificates into /tmp (RAM)
opkg install -d ram curl ca-certificates

# Verify installation
ls -la /tmp/usr/bin/curl
ls -la /tmp/etc/ssl/certs/ca-certificates.crt
```

### 3. Create the AI script

Create a new file `/tmp/ai.sh` and paste the contents from this repository’s [`ai.sh`](./ai.sh) file.

```bash
cat > /tmp/ai.sh << 'EOF'
# Paste the contents from ai.sh here
EOF

chmod +x /tmp/ai.sh
```

### 4. Usage

Once the script is executable, you can run it directly with a text prompt:

```bash
/tmp/ai.sh "Hello, I'm running on a router!"
/tmp/ai.sh "What is OpenWrt?"
/tmp/ai.sh "Tell me a joke"
```

The script will send the prompt to the AI model via the Gemini API and output the response.

---

## Uninstallation

### Option 1 — Clean up manually (recommended)

```bash
# Remove temporary packages from RAM
rm -rf /tmp/usr /tmp/lib /tmp/bin /tmp/etc/ssl

# Remove the AI script
rm /tmp/ai.sh

# Remove the opkg RAM configuration
sed -i '/dest ram \/tmp/d' /etc/opkg.conf
```

### Option 2 — Reboot the router

```bash
reboot
```