#################################################
####
### This Script shows the annotation capabilities of the Feature Function in the Extension for Praat v.6.0.11
### 
### it calculates the silent and voiced intervals in the sound and annotates relevant features to a general tier
### and at each interval in the silence tier it annotates different selected features 
### distinguishing between silent and voiced parts.
### TextGrids are saved onto the same directory specified for soundfiles
### Sound and TextGrid files remain open in the object window
####
#################################################
clearinfo

form Annotating features from silent/voiced segments
  real Minimum_pause_duration_(s) 0.2
  comment Label_for_silent_segments:
  text silLabel SIL 
  comment Label_for_voiced_segments:
  text voicedLabel voiced
  comment Tiername_to_store_general_features:
  text tierLabel all
  sentence directory /home/upf/Escritorio/test_praat/feat04/
endform

######################
## Shortened variables
minpause = minimum_pause_duration


####################################
## Open all soundfiles in the specified directory

Create Strings as file list: "list", directory$ + "/*.wav"
numberOfFiles = Get number of strings
for ifile to numberOfFiles
   selectObject: "Strings list"
   fileName$ = Get string: ifile
   Read from file: directory$ + fileName$
   appendInfoLine: "Processing file " + fileName$
   soundname$ = selected$("Sound")
   soundid = selected("Sound")

## Compute total duration
   originaldur = Get total duration
   totDur$ = fixed$ (originaldur, 2)

 # Compute intensity
   To Intensity: 50, 0, "yes"
   intid = selected("Intensity")
   start = Get time from frame number: 1
   nframes = Get number of frames
   end = Get time from frame number: nframes

   # estimate noise floor
   minint = Get minimum: 0, 0, "Parabolic"
   minInt$ = fixed$ (minint, 0)
   # estimate noise max
   maxint = Get maximum: 0, 0, "Parabolic"
   maxInt$ = fixed$ (maxint, 0)
   #get .99 quantile to get maximum (without influence of non-speech sound bursts)
   max99int = Get quantile: 0, 0, 0.99

   # estimate Intensity threshold
   silencedb = - 20
   threshold = max99int + silencedb
   threshold2 = maxint - max99int
   threshold3 = silencedb - threshold2
   if threshold < minint
       threshold = minint
   endif

  # Mark pauses (silences) and speakingtime
   To TextGrid (silences): threshold3, minpause, 0.1, silLabel$, voicedLabel$

  ### Write Features

   # Create a general tier to store reference features for the whole sound
   selectObject: "TextGrid " + soundname$
   Insert interval tier: 1, tierLabel$
   # Annotates the general tier  with extracted info for silence generation
   Insert feature to interval: 1, 1, "minInt", minInt$
   Insert feature to interval: 1, 1, "maxInt", maxInt$
   Insert feature to interval: 1, 1, "Dur", totDur$

########################################
   ## Loop on silence tier intervals and label features:
   ## duration of silences
   ## mean intensity of voiced segments
################################################

   selectObject: "TextGrid " + soundname$
   totalSilInt = Get number of intervals: 2
   for iInt to totalSilInt
     start = Get starting point: 2, iInt
     end = Get end point: 2, iInt
     sildur = end - start
     intName$ = Get label of interval: 2, iInt
     if intName$ == silLabel$
       silDur$ = fixed$ (sildur, 2)
       Insert feature to interval: 2, iInt, "Dur", silDur$
     elsif intName$ == voicedLabel$
       #meanF0 = Get pitch
       #meanF0$ = fixed$ (meanF0)
       #Insert feature to interval: 2, iInt, "meanInt", meanInt$
       selectObject: "Intensity " + soundname$
       meanInt = Get mean: start, end, "dB"
       meanInt$ = fixed$ (meanInt, 0)
       selectObject: "TextGrid " + soundname$
       Insert feature to interval: 2, iInt, "meanInt", meanInt$
       #voicedDur =
     endif
   endfor
   Write to text file: directory$ + soundname$ + ".TextGrid"
   selectObject: "Intensity " + soundname$
   Remove
endfor

selectObject: "Strings list"
Remove
