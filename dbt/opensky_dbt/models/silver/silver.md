# Silver Layer

The Silver layer transforms the raw OpenSky state vector data into clean, standardized, and analytics-ready datasets. It applies data quality checks, enriches records with derived metrics, and organizes the data into models that support different analytical use cases.

## Models

### stg_state_vectors.sql
Cleans and standardizes the raw OpenSky state vector data by trimming text fields, casting columns to appropriate data types, handling null values, and removing duplicate records. This model serves as the foundation for all downstream Silver models.

### silver_state_vectors.sql
Creates the primary enriched aircraft snapshot dataset by adding derived metrics such as speed conversions, altitude conversions, flight status, heading, and other calculated attributes.

### silver_aircraft_performance.sql
Provides aircraft performance metrics, including speed, altitude, climb/descent rate, and heading, making it suitable for performance and flight behavior analysis.

### silver_aircraft_location.sql
Stores cleaned geographic and positional information, including coordinates, country, and position timestamps, to support mapping, trajectory visualization, and spatial analysis.

### silver_aircraft_status.sql
Captures each aircraft's operational state, including whether it is airborne or on the ground, movement classification, squawk code, and other operational indicators.

### silver_aircraft_latest.sql
Maintains only the most recent snapshot for each aircraft, providing the latest known position and operational status for real-time monitoring and dashboards.

### silver_snapshot_summary.sql
Summarizes each snapshot by calculating fleet-level metrics such as total aircraft, airborne and grounded aircraft counts, average speed, average altitude, and the number of reporting countries.

### country_statistics.sql
Aggregates aircraft activity by origin country, including aircraft counts, average speed, average altitude, and airborne versus grounded totals.

### airborne_flights.sql
Contains only aircraft that are currently airborne, providing a streamlined dataset for flight-specific analysis and reporting.

### airport_surface_activity.sql
Contains only aircraft that are currently on the ground, supporting airport surface movement, ground operations, and congestion analysis.