import subprocess
import json
from pathlib import Path
import re

public_IPs = subprocess.run(
    ["terraform", "output", "-json", "public_ips"],
    capture_output=True,
    text=True,
    check=True,
)

private_IPs = subprocess.run(
    ["terraform", "output", "-json", "private_ips"],
    capture_output=True,
    text=True,
    check=True,
)

private_ips = json.loads(private_IPs.stdout)
public_ips = json.loads(public_IPs.stdout)

start_marker = "# --- BEGIN ANSIBLE HOSTS ---"
end_marker = "# --- END ANSIBLE HOSTS ---"

# Read the existing /etc/hosts
with open("/etc/hosts", "r") as f:
    hosts_content = f.read()

# Remove old managed block if present
pattern = re.compile(f"{start_marker}.*?{end_marker}", re.DOTALL)
hosts_content = re.sub(pattern, "", hosts_content).strip()

# Build new block
new_block = [start_marker]
for name, ip in public_ips.items():
    new_block.append(f"{ip} {name}")
new_block.append(end_marker)
new_content = "\n".join([hosts_content, "\n".join(new_block)]) + "\n"

# Write new /etc/hosts
with open("/etc/hosts", "w") as f:
    f.write(new_content)

print("✅ /etc/hosts updated successfully.")
