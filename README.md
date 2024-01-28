# Spatial Imbalance Analysis

This repository contains R scripts for analyzing spatial imbalances between drivers and orders. The analysis focuses on hourly and regional imbalances, providing insights into areas with excess or insufficient drivers compared to the number of orders.

## Prerequisites
Make sure you have the following R packages installed before running the scripts:
- st
- sf
- data.table
- dplyr
- ggplot2

```R
install.packages("st")
install.packages("sf")
install.packages("data.table")
install.packages("dplyr")
install.packages("ggplot2")
```

## Usage

1. **Data Loading:**
    - Ensure you have the required CSV files, namely `1DayTracesData.csv`, `1DayOrderData.csv`, and `Community.kml`. 
    - Adjust file paths in the scripts accordingly.
    - Due to confidentiality reasons, the actual spatial data has not been loaded into this public repository.
    -  Please replace the file paths in the scripts with the actual paths to your CSV files before running the analysis.
    -  If you have any questions or need assistance, feel free to reach out.

2. **Run the Scripts:**
    - Execute the R scripts (`analyze_traces.R` and `analyze_orders.R`) to process the spatial data.

3. **Imbalance Analysis:**
    - The scripts filter data based on temporal conditions and perform spatial joins to calculate imbalances.
    - Results are stored in `tracesKML.csv` and `orderKML.csv`.

4. **Hourly Imbalance Analysis:**
    - Combine traces and orders data to analyze hourly imbalances.
    - Results are presented in `Hourly_imbalance` and visualized using `ggplot2`.

## Note
- Make sure to replace file paths in the scripts with the actual paths to your CSV files.
- Adjust the script logic as needed for your specific data and analysis requirements.

Feel free to explore and modify the scripts to suit your needs. If you encounter any issues or have questions, please reach out for assistance.
