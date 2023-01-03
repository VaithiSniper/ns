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
set n5 [$ns node]
set n6 [$ns node]
#label nodes
$n1 label "Ping1"
$n2 label "Ping2"
$n3 label "Ping3"
$n4 label "Ping4"
$n5 label "Ping5"
$n6 label "Router"
#create links
$ns duplex-link $n1 $n6 1Mb 10ms DropTail
$ns duplex-link $n2 $n6 1Mb 10ms DropTail
$ns duplex-link $n3 $n6 1Mb 10ms DropTail
$ns duplex-link $n4 $n6 1Mb 10ms DropTail
$ns duplex-link $n5 $n6 1Mb 10ms DropTail
#set queue params
$ns queue-limit $n1 $n6 5
$ns queue-limit $n2 $n6 2
$ns queue-limit $n3 $n6 5
$ns queue-limit $n4 $n6 2
$ns queue-limit $n5 $n6 5
#recv proc for Ping agent
Agent/Ping instproc recv {from rtt} {
	$self instvar node_
	puts "node [$node_ id] recvd ping from $from with rtt of $rtt ms"
}
#create and setup agents
set p1 [new Agent/Ping]
set p2 [new Agent/Ping]
set p3 [new Agent/Ping]
set p4 [new Agent/Ping]
set p5 [new Agent/Ping]
$ns attach-agent $n1 $p1
$ns attach-agent $n2 $p2
$ns attach-agent $n3 $p3
$ns attach-agent $n4 $p4
$ns attach-agent $n5 $p5
#create and assign colors
$ns color 1 Blue
$ns color 2 Yellow
$ns color 3 Green
$ns color 4 Black
$ns color 5 Red
$p1 set class_ 1
$p2 set class_ 2
$p3 set class_ 3
$p4 set class_ 4
$p5 set class_ 5
#connect the agents
$ns connect $p2 $p4
#send proc
proc sendPacket {} {
	global ns p2 p4
	set intervalTime 0.001
	set now [$ns now]
	$ns at [expr $now + $intervalTime] "$p2 send"
	$ns at [expr $now + $intervalTime] "$p4 send"
	$ns at [expr $now + $intervalTime] "sendPacket"
}
#finish proc n wind up
proc finish {} {
	global ns nt nf
	$ns flush-trace
	close $nt
	close $nf
	exec nam prog1.nam &
	exit 0
}
$ns at 0.1 "sendPacket"
$ns at 10.0 "finish"
$ns run
