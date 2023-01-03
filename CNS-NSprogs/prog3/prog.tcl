set ns [new Simulator]

set nt [open lab.tr w]
$ns trace-all $nt

set nf [open lab.nam w]
$ns namtrace-all $nf

set winfile [open winfile w]

proc finish {} {
    global ns nt nf
    $ns flush-trace
    close $nt
    close $nf
    exec nam lab.nam &
    exit 0
}

#create nodes
set n0 [$ns node]
set n1 [$ns node]
set n2 [$ns node]
set n3 [$ns node]
set n4 [$ns node]
set n5 [$ns node]

#setup links
$ns duplex-link $n0 $n2 2Mb 10ms DropTail 
$ns duplex-link $n1 $n2 2Mb 10ms DropTail
$ns simplex-link $n2 $n3 0.5Mb 100ms DropTail
$ns simplex-link $n3 $n2 0.5Mb 100ms DropTail
#setup queue
$ns queue-limit $n2 $n3 20
#setup orientation
$ns duplex-link-op $n0 $n2 orient right-down
$ns duplex-link-op $n1 $n2 orient right-up
$ns simplex-link-op $n2 $n3 orient right
$ns simplex-link-op $n3 $n2 orient left

#setup tcp agents and config
set tcp0 [new Agent/TCP]
set ftp [new Application/FTP]
$ns attach-agent $n0 $tcp0
$ftp attach-agent $tcp0
set sink0 [new Agent/TCPSink]
$ns attach-agent $n4 $sink0
$ns connect $tcp0 $sink0
$tcp0 set packetSize_ 552
$tcp0 set fid_ 1

#setup tcp agents and config
set tcp1 [new Agent/TCP]
set telnet [new Application/Telnet]
$ns attach-agent $n1 $tcp1
$telnet attach-agent $tcp1
set sink1 [new Agent/TCPSink]
$ns attach-agent $n5 $sink1
$ns connect $tcp1 $sink1
$tcp0 set packetSize_ 552
$tcp0 set fid_ 2

#config graph file n funcs
set outfile0 [open labcongestion0.xg w]
puts $outfile0 "TitleText : Congestion Window for TCP source 0"
puts $outfile0 "XUnitText : Simulation Time (ms)"
puts $outfile0 "YUnitText : Congestion Window Size"
set outfile1 [open labcongestion1.xg w]
puts $outfile1 "TitleText : Congestion Window for TCP source 1"
puts $outfile1 "XUnitText : Simulation Time (ms)"
puts $outfile1 "YUnitText : Congestion Window Size"

proc plotter {tcpsrc outfile} {
    global ns
    set time 0.1
    set now [$ns now]
    set cwnd [$tcpsrc set cwnd_]
    puts $outfile "$now $cwnd"
    $ns at [expr $now + $time] "plotter $tcpsrc $outfile"
}

$ns at 0.1 "plotter $tcp0 $winfile"
$ns at 0.1 "plotter $tcp0 $outfile0"
$ns at 0.1 "plotter $tcp0 $outfile1"

$ns at 0.3 "$ftp start"
$ns at 0.3 "$telnet start"

$ns at 5 "$ftp stop"
$ns at 5 "$telnet stop"
$ns at 6 "finish"




