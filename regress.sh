#!/bin/bash

degree=${1:-2} # default degree is 2
echo "degree=$degree"

# automagically do all of the regressions (at least for the different stages)
# this might run a bit faster if the loop builds a command string for Octave and then only runs Octave once
for i in eggs larvae pupae; do
	#sed -i -r "s/^phasename \= \"[a-zA-Z]+\"$/phasename \= \"$i\"/g" m_regress.m
	echo "m_$i"
	octave -q --eval "m_regress(\"$i\",$degree)"
	#sed -i -r "s/^phasename \= \"[a-zA-Z]+\"$/phasename \= \"$i\"/g" r_regress.m
	echo "r_$i"
	octave -q --eval "r_regress(\"$i\",$degree)"
done

echo "m_adults"
octave -q --eval "m_adults($degree)" # must do the adults stage separately because no death rate: just life expectancy

echo "oviposit_regress"
octave -q --eval "oviposit_regress($degree)" # must do egg-laying separately because I can't think of a good name for it
