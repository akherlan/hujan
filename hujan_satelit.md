# Rekaman Hujan dengan Menggunakan Radar

1. TRMM/GPM (NASA): https://mirador.gsfc.nasa.gov

   The Tropical Rainfall Measuring Mission (TRMM) is a joint endeavor between NASA and Japan's National Space Development Agency. It is designed to monitor and study tropical rainfall and the associated release of energy that helps to power the global atmospheric circulation, shaping both global weather and climate.

   **3B42 daily data** 

   ![TRMM_3B42_Daily_7](/home/chspwn/R/hujan/raw/trmm/TRMM_3B42_Daily_7.png)

   This daily accumulated precipitation product is generated from the research-quality 3-hourly TRMM Multi-Satellite Precipitation Analysis TMPA (3B42). It is produced at the NASA GES DISC, as a value added product. Simple summation of valid retrievals in a grid cell is applied for the data day. The result is given in (mm). The beginning and ending time for every daily granule are listed in the file global attributes, and are taken correspondingly from the first and the last 3-hourly granules participating in the aggregation. Thus the time period covered by one daily granule amounts to 24 hours, which can be inspected in the file global attributes.

   Counts of valid retrievals for the day are provided for every variable, making it possible to compute conditional and unconditional mean precipitation for grid cells where less than 8 retrievals for the day are available.

   Efforts have been made to make the format of this derived product as similar as possible to the new Global Precipitation Measurement CF-compliant file format.

   The information provided here on the TRMM mission, and on the original 3-hr 3B42 product, remain relevant for this derived product. Note, however, this product is in netCDF-4 format.

   **3B42RT daily data**

   ![TRMM_3B42RT_Daily_7](/home/chspwn/R/hujan/raw/trmm/TRMM_3B42RT_Daily_7.png)

   This daily accumulated precipitation product is generated from the Near Real-Time 3-hourly TRMM Multi-Satellite Precipitation Analysis TMPA (3B42RT). It is produced at the NASA GES DISC, as a value added product. Simple summation of valid retrievals in a grid cell is applied for the data day. The result is given in (mm). Although the grid is from 60S to 60N, the high latitudes (beyond 50S/N) near real-time retrievals are considered very unreliable and thus are screened out from the daily accumulations. The beginning and ending time for every daily granule are listed in the file global attributes, and are taken correspondingly from the first and the last 3-hourly granules participating in the aggregation. Thus the time period covered by one daily granule amounts to 24 hours, which can be inspected in the file global attributes.

   Counts of valid retrievals for the day are provided for every variable, making it possible to compute conditional and unconditional mean precipitation for grid cells where less than 8 retrievals for the day are available.

   Efforts have been made to make the format of this derived product as similar as possible to the new Global Precipitation Measurement CF-compliant file format.

   The latency of this derived daily product is about 7 hours after the UTC day is closed. Users should be mindful that the price for the short latency of these data is the reduced quality as compared to the research quality product.

   The information provided here on the TRMM mission, and on the original 3-hr 3B42 product, remain relevant for this derived product. Note, however, this product is in netCDF-4 format.

   (source: https://disc.gsfc.nasa.gov/)

2. PERSIANN: http://chrsdata.eng.uci.edu/

   A near-global 30+ year high-resolution precipitation dataset for long-term studies is now available. PERSIANN-CDR (Precipitation Estimation from Remotely Sensed Information using Artificial Neural Networks - Climate Data Record) developed by the Center for Hydrometeorology and Remote Sensing (CHRS) at the University of California, Irvine (UCI) provides daily rainfall estimates at 0.25 deg for the latitude band 60N-60S over the period of 01/01/1983 to 12/31/2015 (delayed present). PERSIANN-CDR is aimed at addressing the need for a consistent, long-term, high-resolution and global precipitation dataset for studying the changes and trends in daily precipitation, especially extreme precipitation events, due to climate change and natural variability. PERSIANN-CDR is generated from the PERSIANN algorithm using GridSat-B1 infrared data and adjusted using the Global Precipitation Climatology Project (GPCP) monthly product to maintain consistency of the two datasets at 2.5 deg monthly scale throughout the entire record. The PERSIANN-CDR product is available to the public as an operational climate data record via the NOAA NCDC CDR Program website under the Atmospheric CDRs category. 
   www.ncdc.noaa.gov/cdr/operationalcdrs.html

   Data Period: January 1983 - December 2017

   Coverage: 60°S to 60°N

   Resolutions: 0.25° x 0.25°

   Timesteps: daily, monthly, yearly

   FTP Download (full): daily, monthly, yearly

   Latest Update: December 2017


3. CHRIPS: http://chg.geog.ucsb.edu/data/chirps/

   Climate Hazards Group InfraRed Precipitation with Station data (CHIRPS) is a 30+ year quasi-global rainfall dataset. Spanning 50°S-50°N (and all longitudes), starting in 1981 to near-present, CHIRPS incorporates 0.05° resolution satellite imagery with in-situ station data to create gridded rainfall time series for trend analysis and seasonal drought monitoring. As of February 12th, 2015, version 2.0 of CHIRPS is complete and available to the public. For detailed information on CHIRPS, please refer to our paper in Scientific Data.


4. CMORPH: https://climatedataguide.ucar.edu/

   CMORPH (CPC MORPHing technique) produces global precipitation analyses at very high spatial and temporal resolution. This technique uses precipitation estimates that have been derived from low orbiter satellite microwave observations exclusively, and whose features are transported via spatial propagation information that is obtained entirely from geostationary satellite IR data.

   -> NOAA CPC: https://rda.ucar.edu/datasets/ds502.0/



## Lokasi stasiun pengamatan di darat
lat: 
long: 

## Validasi Estimasi Hujan

1. Korelasi Pearson
2. RMSE
3. Bias