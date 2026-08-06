# OpenSky dbt Project

This project contains the **dbt (Data Build Tool)** transformations for the OpenSky Flight Data Pipeline. It transforms raw aircraft state vector data from the Bronze layer into clean, enriched, analytics-ready Silver models.

The project follows analytics engineering best practices by implementing modular SQL transformations, automated data quality tests, documentation, and model lineage.

---

## Project Structure

```
models/
└── silver/
    ├── stg_state_vectors.sql
    ├── silver_state_vectors.sql
    ├── silver_aircraft_performance.sql
    ├── silver_aircraft_location.sql
    ├── silver_aircraft_status.sql
    ├── silver_aircraft_latest.sql
    ├── silver_snapshot_summary.sql
    ├── country_statistics.sql
    ├── airborne_flights.sql
    └── airport_surface_activity.sql
```

---

## Silver Layer Models

- **stg_state_vectors** – Cleans and standardizes the raw OpenSky aircraft state vectors.
- **silver_state_vectors** – Enriches aircraft data with derived metrics such as speed conversions, altitude conversions, movement classifications, and flight status.
- **silver_aircraft_performance** – Aircraft performance metrics including speed, altitude, climb/descent rate, and heading.
- **silver_aircraft_location** – Geographic coordinates and positional information for mapping and trajectory analysis.
- **silver_aircraft_status** – Operational aircraft status, movement classification, squawk code, and flight indicators.
- **silver_aircraft_latest** – Latest available snapshot for every aircraft.
- **silver_snapshot_summary** – Fleet-level summary statistics for each snapshot.
- **country_statistics** – Country-level aircraft activity and summary metrics.
- **airborne_flights** – Aircraft currently in flight.
- **airport_surface_activity** – Aircraft currently on the ground.

---

## Features

- Modular SQL transformations
- Layered data architecture
- Automated data quality testing
- Interactive documentation
- Model lineage visualization
- Reusable transformations using Jinja
- PostgreSQL support

---

## Running the Project

Install project dependencies:

```bash
dbt deps
```

Compile the project:

```bash
dbt compile
```

Build all models:

```bash
dbt run
```

Run data quality tests:

```bash
dbt test
```

Generate documentation:

```bash
dbt docs generate
```

View documentation locally:

```bash
dbt docs serve
```

---

## Documentation

The project includes:

- Model documentation
- Column descriptions
- Data quality tests
- Source definitions
- Interactive lineage graph

After generating documentation, open:

```
http://localhost:8080
```

to explore the project interactively.

---

## Technologies

- dbt Core
- PostgreSQL
- SQL
- Jinja
- Git

---

## Learn More

- https://docs.getdbt.com/
- https://docs.getdbt.com/docs/introduction
- https://docs.getdbt.com/docs/build/sql-models
- https://docs.getdbt.com/docs/build/tests
- https://docs.getdbt.com/docs/build/documentation

---

## Repository

This dbt project is part of the **OpenSky Flight Data Pipeline**, which demonstrates how raw aviation data can be transformed into clean, analytics-ready datasets using modern data engineering practices.