#!/bin/bash

# automagically do all of the regressions (at least for the different stages)
for i in eggs larvae pupae; do
	sed -i -r "s/^phasename \= \"[a-zA-Z]+\"$/phasename \= \"$i\"/g" m_regress.m
	octave m_regress.m
	sed -i -r "s/^phasename \= \"[a-zA-Z]+\"$/phasename \= \"$i\"/g" r_regress.m
	octave r_regress.m
done

