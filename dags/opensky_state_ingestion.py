import sys
sys.path.insert(0, '/opt/airflow')
from airflow import DAG
from airflow.operators.python import PythonOperator

from datetime import datetime, timedelta

from pipelines.state_vector_pipeline import ingest_state_vectors


default_args = {
    "owner": "charity",
    "retries": 2,
    "retry_delay": timedelta(minutes=1),
}

with DAG(
    dag_id="opensky_state_ingestion",
    default_args=default_args,
    start_date=datetime(2026, 7, 21),
    schedule="*/5 * * * *",   # every 5 minutes
    catchup=False,
    tags=["opensky", "bronze"],
) as dag:

    ingest = PythonOperator(
        task_id="ingest_state_vectors",
        python_callable=ingest_state_vectors,
    )

    ingest