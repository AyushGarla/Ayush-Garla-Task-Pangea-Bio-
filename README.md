
1. Extract---
    Extracted the data from the given website using python
2. Transform ---
    Transforming the data accordingly 
    1. cleaning by handling missing values
    2. Removing duplicate data 
    3. Feature Engineering in converting a few categorical values into numerical values to ease the process.
3. Load--
    Loading the data from Python to the database by connecting via python
    1. To PostgreSQL (considered the complete data and performed the necessary query operations)
    2. To Neo4j (Data is very huge, so filtered the data accordingly before loading and performing the query operation)
       -->Problem encountered during Neo4j--> as the data was very big was not able to load the entire data to neo4j, so added a few filters, but the logic for the query was unchanged and done according to the requirement.

