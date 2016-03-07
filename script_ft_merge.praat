############################################################
    ## This script merge features from tiers containing intervals or points 
    ## in the same time position to a new tier
    ## duplicating a reference tier 
############################################################
############################################################


clearinfo

form Merging features from different tiers
	sentence Directory /home/upf/Escritorio/test_praat/feat06/
	comment Insert the filename without extension
	sentence Textgrid_name es013_002z
	comment What is your reference tier? (Insert tier number)
	real Tier_number 3
	comment Name of the new tier where features will be merged to
	text New_Tier_name mergedFeatures
endform


# shorten variables
refTier = tier_number
mergedFeat$ = new_Tier_name$

## open the specified TextGrid

Read from file: directory$ + textgrid_name$ + ".TextGrid"

## Loop for reference interval tier

arrayLength = 0
tierisInt = Is interval tier: refTier
if tierisInt == 1
	numInt = Get number of intervals: refTier
	## Store reference time in array format
	for currInt to numInt
		starts[currInt] =  Get starting point: refTier, currInt
		ends[currInt] = Get end point: refTier, currInt
		arrayLength += 1
	endfor

## Duplicate reference tier and look for intervals at the same time reference
	Duplicate tier: refTier, 1, mergedFeat$
	totalTiers = Get number of tiers

	for count to arrayLength
		current2 = 2
		for current2 to totalTiers
			if current2 != refTier+1
				tierisInt = Is interval tier: current2
				if tierisInt == 1
					cInterval = Get low interval at time: current2, ends[count]
					tmpStart =  Get starting point: current2, cInterval
					tmpEnd = Get end point: current2, cInterval
					if tmpStart == starts[count] && tmpEnd == ends[count]
					## Write features to the new tier
						numFeat = Get number of features in interval: current2, cInterval
						for i to numFeat
							label$ = Get label of feature in interval: current2, cInterval, i
							value$ = Get feature from interval: current2, cInterval, label$
							Insert feature to interval: 1, count, label$, value$
						endfor
					endif
				endif
			endif
		endfor
	endfor

## Loop for reference point tier

else
	numInt = Get number of points: refTier
	## Store reference time in array format
	for currInt to numInt
		poinTime[currInt] =  Get time of point: refTier, currInt
		arrayLength += 1
	endfor

## Duplicate reference tier and look for points at the same time reference
	Duplicate tier: refTier, 1, mergedFeat$
	totalTiers = Get number of tiers

	for count to arrayLength
		current2 = 2
		for current2 to totalTiers
			if current2 != refTier+1
				tierisInt = Is interval tier: current2
				if tierisInt == 0
					cPoint = Get low index from time: current2, poinTime[count]
					tmpPoint =  Get time of point: current2, cPoint
					if tmpPoint == poinTime[count]
					## Write features to the new tier
						numFeat = Get number of features in point: current2, cPoint
						for i to numFeat
							label$ = Get label of feature in point: current2, cPoint, i
							value$ = Get feature from point: current2, cPoint, label$
							Insert feature to point: 1, count, label$, value$
						endfor
					endif
				endif
			endif
		endfor
	endfor
endif
Write to text file: directory$ + textgrid_name$ + ".TextGrid"  
appendInfoLine: mergedFeat$ + " tier has been created" + newline$ + "Features have been merged successfully!"