#purpose: gathering host information from broadcast messages.

@load base/protocols/dhcp
module INTRUDER;

export{
    redef enum Log::ID += {CUSTOM_LOG};

    type info: record{
        typ: string &log;
        mac: string &log;
        hostname: string &log;
    };
}




function print_msg_type(val: count):string {
    local ans: string;
    if(val == 1) ans =  "DISCOVERY";
    else if(val == 2) ans =  "OFFER";
    else if (val == 3) ans =  "REQUEST";
    else if(val == 5)    ans = "ACK";
    else ans = "OTHER";
    return ans;
}

event zeek_init()&priority=5
{
    Log::create_stream(INTRUDER::CUSTOM_LOG,[
        $columns= INTRUDER::info,
        $path="custom_dhcp"
    ]);

    print "zeek: running";
    print "";
    
    #header formatting
    local a="time";
    local b="mac_address";
    local c="hostname";
    print fmt("%-20s %-20s %-20s",a,b,c);
}


event dhcp_message(c:connection,is_orig: bool,msg: DHCP::Msg,options: DHCP::Options){
    local msg_code=msg$m_type;#count
    local msg_type = print_msg_type(msg_code);

    local host: string;
    
    if(options?$host_name){
        #if exist
        if(options$host_name=="")
            host = "unknown";
        else
            host = options$host_name;

    }else{
        #if not
        print "host_name field does not exists";
    }

    local rec:INTRUDER::info = [
       $typ=msg_type,
       $mac=msg$chaddr,
       $hostname=host 

    ];

    Log::write(INTRUDER::CUSTOM_LOG,rec);

    #keep track of time
    local now=network_time();
    local tim=strftime("%I:%M:%S %p",now);

    print fmt("%-20s %-20s %-20s",tim,rec$mac,rec$hostname);

}




event zeek_done(){
    print "";
    print "zeek: stopped";
}
