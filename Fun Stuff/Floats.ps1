[single]$a = .7 
[single]$b = .1
$c = $a + $b
[math]::Round($c,10)

[double]$a = .70000000000000000000000000000000000000000000000 
[double]$b = .10000000000000000000000000000000000000000000000
$c = $a + $b
[math]::Round($c,3)
"{0:N99}" -f $c