BEGIN {
	lqi=255
	n=0
	cc[25]={0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}
}

{
event = $1
time =$3
node_id=$5
packet=$19
pkt_id=$41
pkt_type=$35
queue_forward=$22

if(pkt_type == "AODV"){
	ttl--
	lqi=255
	cc=0
	if(pkt_id=="(REQUEST)"){
		if(queue_forward==0)
			RCV_REQ()
		else
			delay 0.08
			cc++
	}
	if(pkt_id=="(REPLY)"){
		if(queue_forward==0)
			RCV_REP()
		else
			delay 0.05
	}	
}
mu=0
for(int i=0;i<25;i++){
	mu+=cc[i]
}
mu=mu/25
zscore=0
for(int i=0;i<25;i++){
	zscore=(cc[pkt_id]-mu)/5.56
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
	if(zscore>2.27)
		set delay 0.05
}
}


