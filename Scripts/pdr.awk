#packet Delivery Ratio
BEGIN {
	sendPkt =0
	recvPkt=0
	forwardPkt=0
}

{
packet=$18
event = $1
if(event =="s" || packet == "AGT") {
	sendPkt++;
}

if(event =="r" || packet == "AGT") {
	recvPkt++;
}
}

END {
	printf ("The sent packets are %d \n", recvPkt);
	printf ("The received packets are %d \n", sendPkt);
	printf ("Packet Delivery Ratio is %f \n", ((sendPkt)/recvPkt));

	
}
