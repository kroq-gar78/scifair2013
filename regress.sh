#!/bin/bash

degree=2
echo "degree=$degree"

# automagically do all of the regressions (at least for the different stages)
for i in eggs larvae pupae; do
	#sed -i -r "s/^phasename \= \"[a-zA-Z]+\"$/phasename \= \"$i\"/g" m_regress.m
	echo "m_$i"
	octave -q --eval "m_regress(\"$i\",$degree)"
	#sed -i -r "s/^phasename \= \"[a-zA-Z]+\"$/phasename \= \"$i\"/g" r_regress.m
	echo "r_$i"
	octave -q --eval "r_regress(\"$i\",$degree)"
done

