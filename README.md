- all state vectors
- own state vectors
- flights in time interval
- flights by aircraft
- arrivals by airport
- departures by airport
- track by aircraft


Key Features
Real-time data ingestion from the OpenSky Network API.
Raw data storage by saving every API response as JSON (Bronze layer).
Data cleaning and validation using Python and Pandas.
PostgreSQL database for storing structured flight data (Silver layer).
Data modeling with dbt to create analytics-ready tables and views (Gold layer).
Workflow orchestration using Apache Airflow to automate the pipeline.
Interactive dashboard in Power BI or Metabase for flight analytics.
Incremental loading to avoid duplicate data and improve efficiency.
Containerized development using Docker and Docker Compose.
Version control with Git and GitHub.

Use Python for:
Calling the OpenSky API
Saving raw JSON files
Loading data into PostgreSQL
Scheduling/orchestration

Use SQL for:
Cleaning data
Removing duplicates
Handling null values
Data validation
Creating views
Building fact and dimension tables
Aggregations
Window functions
Common Table Expressions (CTEs)
Performance optimization (indexes)

opensky-flight-data-pipeline/
│
├── airflow/          # Airflow DAGs and configuration
├── dbt/              # dbt project (bronze, silver, gold models)
├── docs/             # Architecture diagrams and screenshots
├── scripts/          # Python ingestion and database connection
├── sql/              # DDL, indexes, views, analysis queries
├── tests/            # Python and dbt tests
│
├── .env
├── .gitignore
├── docker-compose.yml
├── requirements.txt
├── README.md
└── LICENSE

python -m venv venv
source venv/scripts/activate
pip install requests pandas sqlalchemy psycopg2-binary python-dotenv
pip freeze > requirements.txt  -- to save them