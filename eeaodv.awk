BEGIN {
	lqi=255
	n=0
	cc=0
}

{
event = $1
time =$3
node_id=$5
packet=$19
pkt_id=$41
pkt_type=$35
expiry_time=$29

if(pkt_type == "AODV"){
	ttl--
	lqi=255
	cc=0
	if(pkt_id=="(REQUEST)"){
		RCV_REQ()
	}
	if(pkt_id=="(REPLY)"){
		RCV_REP()
	}	
}

if(pkt_id == "SENT"){
	pkt_type = "DROP"
	exit
}

else{
	if(ttl == 0){
		pkt_type = "DROP"
		exit		
	}	
}

proc RCV_REQ() {
	if(packet[pkt_id] == "RECEIVED"){
		pkt_type = "DROP"
	}
	if(lqi<seq){
		pkt_type = "MODIFIY"
		lqi=seq
	}
	expiry_time=CURRENT_TIME + ACTIVE_ROUTE_TIMEOUT
}

proc RCV_REP() {
	if(pkt_id!="(REPLY)"){
		pkt_id=RCV_REP()
	}
	if(lqi<seq){
		pkt_type = "MODIFIY"
		lqi=seq
	}
}
}


