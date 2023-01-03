#create sim obj
set ns [new Simulator]
#open files 
set nt [open prog1.tr w]
set nf [open prog1.nam w]
$ns trace-all $nt
$ns namtrace-all $nf
#create nodes
set n1 [$ns node]
set n2 [$ns node]
set n3 [$ns node]
set n4 [$ns node]
#label nodes
$n1 label "Source/udp1"
$n2 label "Source/udp2"
$n3 label "Router"
$n4 label "Sink/null"
#create links
$ns duplex-link $n1 $n3 10Mb 300ms DropTail
$ns duplex-link $n2 $n3 10Mb 300ms DropTail
$ns duplex-link $n3 $n4 100Kb 300ms DropTail
#set queue params
$ns queue-limit $n1 $n3 10
$ns queue-limit $n2 $n3 10
$ns queue-limit $n3 $n4 10
#create and setup agents
set udp1 [new Agent/UDP]
set udp2 [new Agent/UDP]
set nullsink [new Agent/Null]
$ns attach-agent $n1 $udp1
$ns attach-agent $n2 $udp2
$ns attach-agent $n4 $nullsink
set cbr1 [new Application/Traffic/CBR]
set cbr2 [new Application/Traffic/CBR]
$cbr1 attach-agent $udp1
$cbr2 attach-agent $udp2
#create and assign colors
$ns color 1 Blue
$ns color 2 Yellow
$udp1 set class_ 1
$udp2 set class_ 2
#connect the agents
$ns connect $udp1 $nullsink
$ns connect $udp2 $nullsink
#set packet size and interval for cbr1
$cbr1 set packetSize_ 500Mb
$cbr1 set interval_ 0.005
#set packet size and interval for cbr1 only
$cbr2 set packetSize_ 500Mb
$cbr2 set interval_ 0.005
#finish proc n wind up
proc finish {} {
	global ns nt nf
	$ns flush-trace
	close $nt
	close $nf
	exec nam prog1.nam &
	exit 0
}
$ns at 0.1 "$cbr1 start"
$ns at 0.1 "$cbr2 start"
$ns at 10.0 "finish"
$ns run
