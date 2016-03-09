############################################################
    ## This script splits features from a reference tier and interval 
    ## to different tiers named as the feature
    ## at the same position of the interval 
    ## assigning the value of the feature as interval label
############################################################
############################################################

form Merging features from different tiers
	sentence Directory /home/upf/Escritorio/marmi_praat/
	comment Insert the filename without extension
	sentence Textgrid_name ex_01
	comment What is your reference tier? (Insert tier number)
	real Tier_number 1
	comment Position of the reference interval
	real Interval_position 2
endform

clearinfo

# shorten variables
refTier = tier_number
intNumber = interval_position

# Look for the reference tier and interval and create tiers for each feature

Read from file: directory$ + textgrid_name$ + ".TextGrid"

numFeat = Get number of features in interval: refTier, intNumber
startInt = Get starting point: refTier, intNumber
endInt = Get end point: refTier, intNumber
for i to numFeat
	tierName$ = "feature" + string$ (i)
	numTiers = Get number of tiers
	Insert interval tier: numTiers+1, tierName$
	head$ = Get head of interval: refTier, intNumber
	label$ = Get label of feature in interval: refTier, intNumber, i
	value$ = Get feature from interval: refTier, intNumber, label$
	Insert boundary: numTiers+1, startInt
	Insert boundary: numTiers+1, endInt
	Set interval head text: numTiers+1, 2, value$
endfor
Write to text file: directory$ + textgrid_name$ + ".TextGrid"  
appendInfoLine: "Features have been splitted to different tiers" + newline$ + "and " + textgrid_name$ + " has been replaced."