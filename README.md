# Evidence for vocal signatures and voice-prints in a wild parrot

The R code and data needed to replicate results from the article:

```
Smeele, S. Q., Senar, J. C., Aplin, L. M., & McElreath, M. B. (2023). Evidence for vocal signatures and voice-prints in a wild parrot. bioRxiv, 2023-01.
```

------------------------------------------------

**Abstract**

In humans, identity is partly encoded in a voice-print that is carried across multiple vocalisations. Other species of vocal learners also signal vocal identity in calls, for example as shown in the contact call of parrots. However, it remains unclear to what extent other call types in parrots are individually distinct, and whether there is  an analogous voice-print across calls. Here we test if an individual signal is also present in other call types, how stable this signal is, and if parrots exhibit voice-prints across call types. We recorded 5599 vocalisations from 229 individually-marked monk parakeets (*Myiopsitta monachus*) over a two year period in Barcelona, Spain. We find evidence for an individual signal in two out of five call types. We further show that while contact calls are individually distinct, they are more variable within individuals than previously assumed, changing over short time scales. Finally, we provide evidence for voice-prints across multiple call types, with a discriminant function being able to predict caller identity across call types. This suggests that monk parakeets may be able to use vocal cues to recognise conspecifics, even across vocalisation types and without necessarily needing active vocal signals of identity.

------------------------------------------------

**The folders contain:**

ANALYSIS:
  - CODE: the code to replicate results
  - DATA: raw data
  - RESULTS: results and figures

NOTE: Some large data files and results are not available in this repository. They can be downloaded from Edmond after publication. If you are interested in using the data now, you can always contact me on <simeonqs@hotmail.com>.

------------------------------------------------

**File information and meta data:**

Below are all files in the repository. The first bullet point under the path is a short explanation of the file. Other bullet points are meta data for the columns if relevant.

- README.md
	- overview of repo and all files
- license.md 
	- liscense file
- .gitignore
	- which files not to sync to GitHub
- voice_paper.Rproj
	- R Studio Project file; if you open the code from this file all paths are relative to the main folder

- ANALYSIS/DATA/luscinia/all_2021.csv	
	- the fundamental frequency traces made in Luscinia for all calls in 2021, **large data file, only available on Edmond**
	- Individual: not used
	- Song: file-selection.wav, where file is the original wav file name and selection is the selection from the Raven selection table
	- Syllable: not used
	- Phrase: not used
	- Element: identifier for the element, some calls contained fundamental frequencies with short silent periods, this leads to multiple traces/elements
	- Time: time within the clip in milli seconds
	- Fundamental_frequency: the recorded fundamental frequency in Herz
- ANALYSIS/DATA/luscinia/contact_2020.csv
	- the fundamental frequency traces made in Luscinia for most contact calls in 2020, **large data file, only available on Edmond**
	- Individual: not used
	- Song: file-selection.wav, where file is the original wav file name and selection is the selection from the Raven selection table
	- Syllable: not used
	- Phrase: not used
	- Element: identifier for the element, some calls contained fundamental frequencies with short silent periods, this leads to multiple traces/elements
	- Time: time within the clip in milli seconds
	- Fundamental_frequency: the recorded fundamental frequency in Herz
- ANALYSIS/DATA/luscinia/remaining_2020.csv
	- the fundamental frequency traces made in Luscinia for the remaining calls in 2020, **large data file, only available on Edmond**
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
- ANALYSIS/DATA/nesting/nest overview 2020.csv
	- an overview of all nests recorded in 2020
 	- tree: the tree id (numeric)
  	- nest: the nest id within the tree (alphabetic)
  	- n_entries: the number of nest entries within that nest
  	- cluster: the location in the park (named based on clustering of nests)
- ANALYSIS/DATA/nesting/nesting 2020 - manual added.csv
	- overview of nesting location per individual (only used for pDFA analysis)
 	- id: individual id (mostly alphanumeric, but some old ones are purely numeric)
  	- tree_manual: manually decided final tree id (numeric)
  	- final_nest: manually decided final nest id (alphanumeric)
  	- nest_locations: a comma separated vector of recorded nest locations (underscore seperated alphanumeric for tree_nest_entry)
- ANALYSIS/DATA/nesting/nesting 2021 - manual added.csv
  	- overview of nesting location per individual (only used for pDFA analysis)
 	- id: individual id (mostly alphanumeric, but some old ones are purely numeric)
  	- tree_manual: manually decided final tree id (numeric)
  	- nest_manual: manually decided final nest id (space separated alphanumeric)
  	- area: the location in the park (named based on clustering of nests)
  	- nest: a comma separated vector of recorded nest locations (space seperated alphanumeric for tree nest entry)
  	- tree: a comma separated vector of recorded tree locations
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
- ANALYSIS/DATA/sex/data Francisca.csv
	- this file is not shared because the data is from *Dawson Pell (2021)*
 	- ID: individual id
  	- sex: NA, F or M
- ANALYSIS/DATA/sex/sexing vetgenomics.xlsx
	- file with all sexings done by Vetgenomics
  	- ID: individual ID
  	- sex: f or m
 
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
- ANALYSIS/RESULTS/supplemental figures/composite figure - dtw.pdf
	- composite figure for dtw
- ANALYSIS/RESULTS/supplemental figures/composite figure - mfcccc.pdf
	- composite figure for mf4c
- ANALYSIS/RESULTS/supplemental figures/composite figure - specan.pdf
	- composite figure for specan
	
- ANALYSIS/CODE/00_run_methods/README.md 
	- short explanation of folder
- ANALYSIS/CODE/00_run_methods/00_DATA_create_data_sets.R
	- creates the data sets for next steps
- ANALYSIS/CODE/00_run_methods/01_DTW_run.R
	- runs dynamic time warping
- ANALYSIS/CODE/00_run_methods/02_MFCC_run.R
	- runs mel frequency cepstral coefficients, which is not used in the paper
- ANALYSIS/CODE/00_run_methods/03_SPCC_create_spec_objects.R
	- creates the spectrograms for spcc
- ANALYSIS/CODE/00_run_methods/04_SPCC_run_pixel_comparison.R
	- runs spectrographic cross correlation
- ANALYSIS/CODE/00_run_methods/05_SPECAN_run.R
	- runs spectrographic analysis
- ANALYSIS/CODE/00_run_methods/07_MFCCCC_run.R
	- runs mel frequency cepstral coefficient cross correlation
- ANALYSIS/CODE/01_compare_call_types/01_run_model.R
	- runs the Bayesian models on all analysis and call types
- ANALYSIS/CODE/01_compare_call_types/02_plot_results.R
	- plots the results
- ANALYSIS/CODE/01_compare_call_types/03_test_model.R
	- running tests on model output
- ANALYSIS/CODE/01_compare_call_types/04_test_vis.R
	- testing some visualisations
- ANALYSIS/CODE/02_time_effect/01_run_time.R
	- running the Bayesian models for time within recording
- ANALYSIS/CODE/02_time_effect/02_run_dates.R
	- running the Bayesian models for time between recordings
- ANALYSIS/CODE/02_time_effect/03_plot_results.R
	- plotting the results for both 01 and 02
- ANALYSIS/CODE/02_time_effect/04_plot_pco.R
	- plotting some pco figures to visualise within recording change
- ANALYSIS/CODE/02_time_effect/05_spectrogram_sequence.R
	- plotting spectrograms for step 04
- ANALYSIS/CODE/03_year_comparison/01_run_models.R
	- running Bayesian models for comparison years
- ANALYSIS/CODE/03_year_comparison/02_plot_results.R
	- plotting the results
- ANALYSIS/CODE/04_cross_call_type/00_MFCC_run.R
	- generating data for mfcc
- ANALYSIS/CODE/04_cross_call_type/01_SPECAN_run.R
	- generating data for specan (not used)
- ANALYSIS/CODE/04_cross_call_type/02_run_DFA_full.R
	- running pDFA on full dataset
- ANALYSIS/CODE/04_cross_call_type/03_run_DFA_subset.R
	- running pDFA on subset
- ANALYSIS/CODE/04_cross_call_type/04_run_DFA_permuted.R
	- running permuted within location
- ANALYSIS/CODE/04_cross_call_type/05_random_forest.R
	- running random forest (not used, similar results)
- ANALYSIS/CODE/functions
	- all functions used in other code (for description see inside script)
- ANALYSIS/CODE/luscinia/00_export_clips.R
	- exports clips based on the selections from luscinia (not used)
- ANALYSIS/CODE/luscinia/01_analyse_traces.R
	- analyses the luscinia traces (not used)
- ANALYSIS/CODE/luscinia/02_run_mantel.R
	- runs mantel tests (not used)
- ANALYSIS/CODE/markdown
	- files to generate the supplemental materials, also includes the supplemental pdf
- ANALYSIS/CODE/models
	- Stan models and code to simulate/test models
- ANALYSIS/CODE/test
	- test scripts for methods
- ANALYSIS/CODE/call type classification.R
	- classification keys for call types
- ANALYSIS/CODE/final figures - supplemental.R
	- generates the supplemental figures for the manuscript
- ANALYSIS/CODE/final figures.R
	- generates the final figures for the manuscript
- ANALYSIS/CODE/Luscinia - clips 2020.R
	- script to save missing wavs for analysis in Luscinia
- ANALYSIS/CODE/paths.R
	- paths used in all other scripts
- ANALYSIS/CODE/plot example spectrograms.R
	- plots examples for the supplemental figures
- ANALYSIS/CODE/save wavs all contact.R
	- saves all contact calls for sorting into loud vs soft contact call

NOTE: each code file contains additional information about author, date modified and description. 

------------------------------------------------

**Maintainers and contact:**

Please contact Simeon Q. Smeele, <ssmeele@ab.mpg.de>, if you have any questions or suggestions. 




