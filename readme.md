# AI Client on LEDE 17.01 (OpenWrt)

This project demonstrates how to run a simple AI client directly on an OpenWrt/LEDE 17.01 router using **temporary RAM storage**. Tested on a 4/32 router.

## Optimizations for Resource-Constrained Routers

The script has been heavily optimized for routers with limited memory (4 MB flash / 32 MB RAM):

- **Zero temporary files**: JSON data is piped directly to curl via stdin, eliminating RAM usage for temp files
- **Efficient text processing**: Optimized sed/tr pipeline reduces process overhead
- **Conditional exports**: Environment variables only set when necessary
- **Minimal memory footprint**: Entire script runs in ~100 KB of memory

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

## Performance and Memory Usage

### Memory Footprint
- **curl + ca-certificates**: ~500 KB in RAM
- **ai.sh script**: <10 KB
- **Runtime memory**: ~100-200 KB during execution
- **No temporary files**: JSON data piped directly to curl

### Script Optimizations
The script includes several optimizations for resource-constrained routers:
1. **Zero temp files**: Uses stdin piping (`-d @-`) instead of creating temp files
2. **Efficient pipeline**: Single `sed` command instead of `grep | sed | tr`
3. **Minimal overhead**: Conditional environment variable exports
4. **Error suppression**: stderr redirected to `/dev/null` to reduce output

These optimizations are critical for 4/32 MB routers where every kilobyte matters.

---

## Uninstallation

### Option 1 — Clean up manually (recommended)

```bash
# Delete packages
opkg remove curl --autoremove
opkg remove ca-certificates --autoremove

# Remove temporary data from RAM
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

---

## Technical Details

### Why This Works on Limited Hardware

**LEDE 17.01 with 4 MB flash / 32 MB RAM** is extremely constrained:
- Most of the 4 MB flash is used by the firmware itself
- Only ~32 MB RAM available, shared by kernel, services, and applications

**Our approach:**
1. Install packages to `/tmp` (RAM) instead of flash using `opkg -d ram`
2. Pipe data through memory without creating temp files
3. Use POSIX shell features to minimize overhead
4. Keep the entire toolchain in RAM, erased on reboot

This allows running AI API calls on hardware that normally couldn't support such functionality.
