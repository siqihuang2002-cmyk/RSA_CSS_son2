# Rhythm Pattern Analysis

Analysis of rhythmic patterns from musical onset data using interval ratios, HDBSCAN clustering, and pattern-duration visualization in R.

## Table of Contents
- [Installation](#installation)
- [Usage](#usage)
- [Contributing](#contributing)
- [License](#license)

## Installation

Install the required R packages:

```r
install.packages("dbscan")
install.packages("ggtern")
install.packages("ggplot2")
install.packages("tidyverse")
install.packages("dplyr")
```

## Usage

### Input Data

The script expects a CSV file with a column named `Clave` containing onset times in seconds:

```r
da <- read.csv("~/Downloads/CSS_Song2_Onsets_Selected.csv")
```

To use a different file or column name, update:

```r
da <- read.csv("your/path/to/file.csv")
clave_onset <- da$YourColumnName
```

### Key Parameters

| Parameter | Default | Description |
|-----------|---------|-------------|
| BPM | `68` | Change in `sixteen = 60/68/4` to match your song |
| `minPts` (dyadic) | `10` | Minimum cluster size for 2-interval patterns |
| `minPts` (triadic) | `5` | Minimum cluster size for 3-interval patterns |
| `count >= 90` | `90` | Transition frequency threshold for 2D plot arrows |
| `count >= 10` | `10` | Transition frequency threshold for ternary plot arrows |

### Output

Running the script produces two plots:

**`p1` — 2D Pattern-Duration Plot**
- x-axis: rhythm ratio (0 to 1)
- y-axis: cycle duration in 16th note units
- Grey arrows: all consecutive pattern transitions
- Colored points: HDBSCAN clusters
- Black arrows: high-frequency transitions

<img width="661" height="507" alt="fig1_2D" src="https://github.com/user-attachments/assets/51afe03b-f132-4498-ab94-efa215815591" />

**`p_tern` — Ternary Pattern-Duration Plot**
- Three axes: Interval 1, Interval 2, Interval 3
- Color encodes cycle duration
- Black arrows: high-frequency transitions between clusters
- 
<img width="661" height="507" alt="fig2_Ternary" src="https://github.com/user-attachments/assets/4006554d-133c-4867-bc5d-7135b98239b2" />

## Contributing

Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.

## License

[MIT](https://choosealicense.com/licenses/mit/)
