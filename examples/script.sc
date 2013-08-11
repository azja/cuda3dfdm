set terminal png
set output "result.png"
set pm3d map
unset xtics
unset ytics
set size square
#set title "Rozkład temperatury w blaszce umieszczonej w T=30C przytkniętej do lodu \n Z jednej strony modulowanej sygnałem sinusoidalnym" offset 0,2
splot "maybe.dat" u 2:3:4

