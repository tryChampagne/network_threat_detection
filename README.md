## Purpose:
    to detect network attack/threats using zeek.

## Prerequisites:
    tools:
        system: Linux
        zeek version  : 8.0.0-dev.204
        
    basic understanding of:
        zeek scripts
        pcap files
        bash script

### Side work:
    gathering LAN Devices information.
        information could be their 'Hostname'.
        
    getting more from arp using oui database.
        oui :organization unique identifier OR  vendors of NIC card.
        for guessing the LAN device Operating System.


## How to use it?
    step1:
        having met the requirements ,run 'hello_world.zeek' script as follow:
            sudo zeek -C -i wlan0 hello_world.zeek
            
        hopefully it gives output similar to below
        <screenshot to be added>
        which indicates our zeek setup is neet and clean.

    step2:
        we have 3 zeek scripts ,which focuses on 
            -ddos attack [dns_ddos.zeek]
            -ssh brute force attack [ssh_brute.zeek]
            -syn flood attack   [syn_flood.zeek]
            
        now in order to detect an attack first we need to simulate it(assuming you are not already under such attacks).
        zeek will do this work for us ,we just need to replay a precaptured network traffic that is malicious and this traffic is come under format called pcap files.
        so now simply run:
            sudo zeek -C -r ../pcaps/syn_flood.pcap syn_flood.zeek [for custom log directory use -e flag this is optional ,without custom log directory zeek will simply dump all genrated log in current directory that is /scripts]
            one can observe that in 'notice.log' file some alert messages are present.
            same goes for rest 2 attacks.

    



