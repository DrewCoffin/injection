import math as m

def subcovel(omega, L):
	rj = 71492 #km
	secday = 3600.*24
	con = rj/secday    
	v = omega*con*L
	return v

o = input("Frequency? (rad/day) ")
L = input("Jovian radius? ")

print "Speed is ", subcovel(o, L), " km/s"

