###########################################################################
#                                                                      	  #
#  Praat Script: Merge features                                     	  #
#  Copyright (C) 2016  Mónica Domínguez-Bajo - Universitat Pompeu Fabra   #
#																		  #
#    This program is free software: you can redistribute it and/or modify #
#    it under the terms of the GNU General Public License as published by #
#    the Free Software Foundation, either version 3 of the License, or    #
#    (at your option) any later version.                                  #
#                                                                         #
#    This program is distributed in the hope that it will be useful,      #
#    but WITHOUT ANY WARRANTY; without even the implied warranty of       #
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the        #
#    GNU General Public License for more details.                         #
#                                                                         #
#    You should have received a copy of the GNU General Public License    #
#    along with this program.  If not, see http://www.gnu.org/licenses/   #
#                                                                         #
###########################################################################
###### This script merges cloned tiers with the same time segments
###### to feature vectures in a specified tier
###########################################################################
## Requirements: Extended Praat for feature annotation needs to be run 
###########################################################################
## A TextGrid with cloned tier segments needs to be provided
## The script will use the tier name as feature name
## and the interval label as feature value
###########################################################################
clearinfo

form Parameters
	comment Tiers to merge
	real from_tier 4
	real to_tier 10
	comment Annotate features to tier
	real number 1
	text directory
	text basename
endform

Read from file: directory$ + basename$ + ".TextGrid"

check_tier = Is interval tier: number
# Merge interval tiers
if check_tier == 1
	int_tier = Get number of intervals: number
	for i from from_tier to to_tier
		int_i = Get number of intervals: i
		#Check if tiers to merge have the same number of intervals as tier to annotate features
		if int_tier == int_i
			feature$ = Get tier name: i
			for i_lab to int_i
				value$ = Get label of interval: i, i_lab
				Insert feature to interval: number, i_lab, feature$, value$
			endfor
		else
			appendInfoLine: "number of intervals in tier ", i, " does not match to tier ", number
		endif
	endfor
# Merge point tiers
else
	point_tier = Get number of points: number
	for t from from_tier to to_tier
		point_t = Get number of intervals: t
		#Check if tiers to merge have the same number of intervals as tier to annotate features
		if int_tier == point_t
			feature$ = Get tier name: t
			for p_lab to point_t
				value$ = Get label of interval: t, p_lab
				Insert feature to interval: number, p_lab, feature$, value$
			endfor
		else
			appendInfoLine: "number of points in tier ", t, " does not match to tier ", number
		endif
	endfor
endif

for r from from_tier to to_tier
	Remove tier: r
endfor

Write to text file: directory$ + "result.TextGrid"

appendInfoLine: "Features have been annotated to tier ", number