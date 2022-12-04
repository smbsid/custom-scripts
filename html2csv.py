#!/bin/python3
import sys
import pandas as pd

### Python script that converts HTML file taken as input to an output CSV file.
###
### Syntax : python3 html2csv.py inputfile.html outputfile.csv
### Requirements : 
### 	pip3 install pandas
###		pip3 install lxml
###################################################################

inFile = sys.argv[1]
outFile = sys.argv[2]

# Select the only (first) table using indexing [0]
df = pd.read_html(inFile)[0]

# Write DataFrame to CSV - no index required
df.to_csv(outFile, index=False)