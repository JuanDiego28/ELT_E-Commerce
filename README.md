## Project Description: E-commerce Data Analysis

## Business Problem

In this personal project, I undertook an in-depth analysis of a Brazilian E-commerce dataset spanning the years 2016 to 2018. My primary focus was on two key areas: Revenue and Delivery. The project aimed to unravel insights into the company's performance, specifically addressing the following aspects:

### Yearly revenue analysis
Identification of popular and less popular product categories
Regional revenue distribution
Delivery performance analysis, including delivery time trends and adherence to estimated delivery dates.

## About the Data

I utilized data from two primary sources:

Olist Store Dataset: This dataset comprises real commercial data, anonymized to maintain privacy. It encompasses records of 100,000 orders from various marketplaces in Brazil. The dataset provides a comprehensive view of orders, including order status, pricing, payment details, freight performance, customer locations, product attributes, and customer reviews. The schema of the database can be found in the images/data_schema.png file. To access the dataset, please download it here, extract the dataset folder from the .zip file, and place it in the root project folder as specified in the ASSIGNMENT.md under the Project Structure section.

Public API: I leveraged the date.nager.at public API to gather information about Brazil's Public Holidays. This data was correlated with various delivery metrics to gain insights.

## Technical Details

Given the diverse sources and formats of data, and the need for periodic reporting, I designed and implemented a robust data pipeline (ELT) to automate the process and produce insightful results. The key technologies used in this project include:

Python: As the primary programming language.
Pandas: For data manipulation and analysis of CSV files.
Requests: For querying the public holidays API.
SQLite: As the database engine.
SQL: For data storage, manipulation, and retrieval within our Data Warehouse.
Matplotlib and Seaborn: For creating informative visualizations.
Jupyter Notebooks: For an interactive and explanatory report.
This project allowed me to explore and analyze real-world data, showcasing my skills in data engineering, analysis, and visualization.

