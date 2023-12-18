<h2>Spatial Data Visualization</h2>

The coding script produces visualizations of a major city in South Asia. For this exercise, R has been used. The shape files and election dataset has been included in the sample folder.

The first map shows a city’s election constituencies and the total number of candidates standing up for election in each constituency for the year 2020.

For the second map, the area is to be calculated by dividing consituency No.1 into the southern and northern half. A straight line has been drawn passing through the centroid of the constituency 1 and is perpendicular to the geographical north. 
The blue area is the northern half, and the green area is the southern half. 

<h3>Package Installation</h3>
The following are required to be installed before running the script:
<ul>
  <li>Tidyverse</li>
  <li>sf</li>
  <li>rgeos</li>
  <li>virdis</li>
  <li>raster</li>
</ul>

<h3>Results</h3>

Running the script, you can the get the results as follows:


![image](https://github.com/spniroul/spatial_mapping_sample/assets/33347011/457543f8-b357-4d72-80a3-580606dba7d4)




![image](https://github.com/spniroul/spatial_mapping_sample/assets/33347011/5c734576-c249-44e4-8718-eb6af6d69afc)


Northern Area = 73.73 sq.km 

Southern Area = 66.60 sq.km


 
