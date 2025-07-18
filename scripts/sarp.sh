echo -e "IP Address\t\tMAC Address\t\tVendor"
echo "---------------------------------------------------------------"

arp -e | awk 'NR>1 {print $1, $3}' | while read ip mac; do
    # Get vendor using macvendors API
    vendor=$(curl -s https://api.macvendors.com/$mac)
    printf "%-20s %-20s %s\n" "$ip" "$mac" "$vendor"
done
