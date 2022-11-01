# Voice paper

The R code and data needed to replicate results from the article:

```
Voice paper
```

------------------------------------------------

**Abstract**


------------------------------------------------

**The folders contain:**

ANALYSIS:
  - CODE: the code to replicate results
  - DATA: raw data
  - RESULTS: results and figures

------------------------------------------------

**File information and meta data:**

Below are all files in the repository. The first bullet point under the path is a short explanation of the file. Other bullet points are meta data for the columns if relevant.

- README.md
	- overview of repo and all files
- .gitignore
	- which files not to sync to GitHub
- voice_paper.Rproj
	- R Studio Project file; if you open the code from this file all paths are relative to the main folder

- ANALYSIS/DATA/luscinia/all_2021.csv
	- the fundamental frequency traces made in Luscinia for all calls in 2021
	- Individual: not used
	- Song: file-selection.wav, where file is the original wav file name and selection is the selection from the Raven selection table
	- Syllable: not used
	- Phrase: not used
	- Element: identifier for the element, some calls contained fundamental frequencies with short silent periods, this leads to multiple traces/elements
	- Time: time within the clip in milli seconds
	- Fundamental_frequency: the recorded fundamental frequency in Herz
- ANALYSIS/DATA/luscinia/contact_2020.csv
	- the fundamental frequency traces made in Luscinia for most contact calls in 2020
	- Individual: not used
	- Song: file-selection.wav, where file is the original wav file name and selection is the selection from the Raven selection table
	- Syllable: not used
	- Phrase: not used
	- Element: identifier for the element, some calls contained fundamental frequencies with short silent periods, this leads to multiple traces/elements
	- Time: time within the clip in milli seconds
	- Fundamental_frequency: the recorded fundamental frequency in Herz
- ANALYSIS/DATA/luscinia/remaining_2020.csv
	- the fundamental frequency traces made in Luscinia for the remaining calls in 2020
	- Individual: not used
	- Song: file-selection.wav, where file is the original wav file name and selection is the selection from the Raven selection table
	- Syllable: not used
	- Phrase: not used
	- Element: identifier for the element, some calls contained fundamental frequencies with short silent periods, this leads to multiple traces/elements
	- Time: time within the clip in milli seconds
	- Fundamental_frequency: the recorded fundamental frequency in Herz
- ANALYSIS/DATA/luscinia/bad_files_2020.xlsx
	- an overview over which files from 2020 to exclude from the Luscinia traces due to poor quality
	- file_end: the end of the Song column in the Lucinia trace files, used to match and exclude
	- total_useless: if 1 the call was very poor quality, if none the fundamental frequency was poor quality but the 2-4 kHz range was still good
- ANALYSIS/DATA/luscinia/bad_files_2021.xlsx
	- an overview over which files from 2021 to exclude from the Luscinia traces due to poor quality
	- file_end: the end of the Song column in the Lucinia trace files, used to match and exclude
	- total_useless: if 1 the call was very poor quality, if none the fundamental frequency was poor quality but the 2-4 kHz range was still good
- ANALYSIS/DATA/overview recordings/annotations - 2020.csv
	- annotations linked to the selection tables from Raven for 2020, note that these follow a different format compared to the 2021 data
	- annotation_ref: annotation reference in the selection table (from the Annotation column in the selection table files) 
	- uncertain: if uncertain about the ID = 1
	- bird: the ID on the collar of the individual
	- behaviour: which behaviours at vocalisation or just before, can be multiple separated by a comma
	- location: location of the bird during vocalisation
	- other: which other individuals were around, 'none' of the bird was alone if unknown nothing was noted down
	- association: the behaviour of the other birds towards the focal bird
	- notes: other observations
- ANALYSIS/DATA/overview recordings/overview recordings - 2020.csv
	- overview per audio recording
	- file: audio file name without extension
	- selected: whether or not I'm finished with this file
	- discard: 1 if there are no selections for this file
	- situation_recording: notes on what happens in the recording
	- birds: ID's of vocalising birds, incomplete
	- utm: the UTM coordinates of the recording, separated by a space
	- nest: the nest location if recorded at a nest
	- notes: other observations
- ANALYSIS/DATA/overview recordings/annotations - 2021.xlsx
	- annotations linked to the selection tables from Raven for 2021, note that these follow a different format compared to the 2020 data
	- file: audio file name with extension
	- selection: the selection number in the selection table
	- bird: the ID on the collar of the individual
	- location: where the focal bird was recorded
	- context: the context of the call, if it was recorded as single vocalisation, few notes or part of a larger sequence
	- call type: what call type the vocalisation belonged to
	- larger sequence: the full sequence that this call is part of (if available)
	- complete sequence: 1 if all calls in the sequence were included in this file
	- sequence_ID: unique integer per sequence
	- uncertain: 1 if uncertain about any of the information
	- others: which other individuals were present
	- association: the behaviour of the other birds towards the focal bird
	- notes: other observations
- ANALYSIS/DATA/overview recordings/context - 2020.xlsx
	- context for each call of 2020 (for 2021 this is part of the annotations)
	- file: the full file name of the associated Raven selection table
	- selection: the selection number of the Raven selection table; 1t4 means selection 1 until and including 4
	- context: the context of the call, if it was recorded as single vocalisation, few notes or part of a larger sequence; if uncertain a ? is added
	- call type: what call type the vocalisation belonged to
	- larger sequence: the full sequence that this call is part of (if available)
	- sequence_ID: unique integer per sequence
	- notes: other observations
- ANALYSIS/DATA/overview recordings/overview recordings - 2021.xlsx
	- overview per audio recording
	- file: audio file name with extension
	- selected: whether or not I'm finished with this file
	- discard: 1 if there are no selections for this file
	- situation_recording: notes on what happens in the recording
	- birds: ID's of vocalising birds, incomplete
	- utm: the UTM coordinates of the recording, separated by a space
	- nest: the nest location if recorded at a nest
	- notes: other observations
- ANALYSIS/DATA/selection tables
	- a folder with the Raven selection tables; the file name is the original wav file name without extension with .Table.1.selections.txt added to the end; note that each selection is listed twice (once for the Waveform 1 and once for the Spetrogram 1) and for analysis one has to be removed
	- Selection: the selection number (can be discontinuous if selections were later removed)
	- View: not used
	- Channel: not used
	- Begin Time (s): begin time of selection within the wav file in seconds
	- End Time (s): end time of selection within the wav file in seconds
	- Low Freq (Hz)	: not used
	- High Freq (Hz): not used
	- Annotation: annotation reference for the annotations of 2020 (multiple selections can have the same annotation), for 2021 this was not used and the selection number was used in combination with the file name to match annotations
	
- ANALYSIS/RESULTS/00_run_methods
	- in this location the results for each method should be stored in separate folders; since files are too large, these cannot be uploaded to GitHub
- ANALYSIS/RESULTS/00_run_methods/all_data.RData
	- RData file with the relevant processed data, following objects will be loaded:
		- data_sets: the names of file + selection for each call type
		- smooth_traces: the smoothed traces from Luscinia
		- st: the merged selection tables 
- ANALYSIS/RESULTS/01_compare_call_types
	- in this location model output should be stored; since files are too large, these cannot be uploaded to GitHub
- ANALYSIS/RESULTS//01_compare_call_types/model results.pdf
	- pdf with all results for model I
- ANALYSIS/RESULTS/02_time_effect
	- in this location model output should be stored; since files are too large, these cannot be uploaded to GitHub
- ANALYSIS/RESULTS/02_time_effect/model results.pdf
	- pdf with all results for model II and model III
- ANALYSIS/RESULTS/03_year_comparison
	- - in this location model output should be stored; since files are too large, these cannot be uploaded to GitHub
- ANALYSIS/RESULTS/03_year_comparison/model results.pdf
	- pdf with all results for model IV
- ANALYSIS/RESULTS/04_cross_call_type/mfcc_out.RData
	- the MFCC results for all calls
- ANALYSIS/RESULTS/04_cross_call_type/results.txt
	- a txt file with all results from the pDFAs
- ANALYSIS/RESULTS/04_cross_call_type/scores.pdf
	- a pdf of the differences in trained and random scores from the pDFAs
- ANALYSIS/RESULTS/figures/final_figure_ind.pdf
	- the final pdf for model I
- ANALYSIS/RESULTS/figures/final_figure_time.pdf
	- the final pdf for model II and III

NOTE: each code file contains additional information about author, date modified and description. 

------------------------------------------------

**Maintainers and contact:**

Please contact Simeon Q. Smeele, <ssmeele@ab.mpg.de>, if you have any questions or suggestions. 




