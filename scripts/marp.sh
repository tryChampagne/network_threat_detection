#!/bin/bash

# Define the path to your local OUI CSV
CSV_PATH="$HOME/Downloads/oui.csv"  # Change this to where your CSV is located

# Output header
echo -e "IP Address\t\tMAC Address\t\tVendor"
#echo "---------------------------------------------------------------"

# Function to lookup vendor from the OUI CSV
lookup_vendor() {
    # Extract the first 3 octets (OUI) from the MAC address
    oui_prefix=$(echo "$1" | cut -d':' -f1-3 | tr '[:lower:]' '[:upper:]')

    # Search the OUI CSV for the matching OUI prefix and extract the vendor name
    vendor=$(grep -i "^$oui_prefix," "$CSV_PATH" | cut -d',' -f2)
    
    # If no match is found, set vendor to "Unknown Vendor"
    if [ -z "$vendor" ]; then
        vendor="Unknown Vendor"
    fi

    echo "$vendor"
}

# Process the ARP table and look up vendors
arp -e | awk 'NR>1 {print $1, $3}' | while read ip mac; do
    # Get vendor using lookup function
    vendor=$(lookup_vendor "$mac")
    
    # Print the IP, MAC, and vendor info in a tabular format
    printf "%-20s %-20s %s\n" "$ip" "$mac" "$vendor"
done
