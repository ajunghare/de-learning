from airflow import DAG
# from airflow.operators

import os
from datetime import datetime
from pathlib import Path
from airflow.utils.dates import days_ago
from airflow.decorators import task
from airflow.models.dag import DAG
from airflow.providers.google.cloud.sensors.gcs import ts_function, GCSObjectUpdateSensor
from airflow.providers.google.cloud.operators.bigquery import BigQueryGetDataOperator
from airflow.providers.google.cloud.transfers.gcs_to_bigquery import GCSToBigQueryOperator
from pprint import pprint
from airflow.operators.python import PythonOperator
from datetime import timedelta


from airflow.providers.google.cloud.sensors import cloud_storage_transfer_service
DAG_ID = "load_movies"
ENV_ID = os.environ.get("SYSTEM_TESTS_ENV_ID")
PROJECT_ID = "ee-india-se-data"
BUCKET_NAME = "se-data-landing-ajit"
FILE_NAME = "movies_all.csv"
# PATH_TO_SAVED_FILE = "/Users/aj383k/airflow/downloads/movies_all.csv"
TABLE_ID = "movies_raw"
DATASET_ID = "movies_data_ajit"

def my_ts_function(context):
    """
    this function calculates interval required w.r.t load_date from table
    """
    try:
        return datetime(context['ti'].xcom_pull(task_ids='get_latest_load_date'))
    except:
        return ts_function(context)
    # return context["params"]["movies_latest_load_date"]
    
def print_context(ds, **kwargs):
    pprint(kwargs)
    print(ds)
    return 'Whatever you return gets printed in the logs'

with DAG(
    DAG_ID,
    start_date=datetime(202, 1, 1),
    catchup=False,
    tags=["gcs", "se-DE-journey"],
    default_args={"start_date": days_ago(1)},
    schedule_interval="10 * * * *",
) as dag:
    #   check if new file is added
    #   1. get movies_latest_load_date = max(last_date) from movies_raw and add to context
    #       BigQueryGetDataOperator
    #   2. cget create_date of file
    #       .GCSObjectUpdateSensor with ts_func with movies_latest_load_date
    #   3. Add condition for download_file, if create_date>movies_latest_load_date
    #   4. Load file to movies_raw 
    #       GCSToBigQueryOperator
    #   5. wait for data transfer to complete 
    #       BigQueryDataTransferServiceTransferRunSensor
    
    get_latest_load_date = BigQueryGetDataOperator(
        task_id="get_latest_load_date",
        dataset_id=DATASET_ID,
        table_id=TABLE_ID,
        table_project_id=PROJECT_ID,
        max_results=1,
        selected_fields="LOAD_DATE",
        gcp_conn_id='google-ee-se-data-conn',
    )
    
    is_file_updated = GCSObjectUpdateSensor(
        task_id="is_file_updated",
        bucket=BUCKET_NAME,
        object=FILE_NAME,
        ts_func=my_ts_function,
        # timeout=timedelta(seconds=3),
        google_cloud_conn_id='google-ee-se-data-conn',
    )
    
    load_csv = GCSToBigQueryOperator(
        task_id='load_csv',
        bucket=BUCKET_NAME,
        source_objects=['{}'.format(FILE_NAME)],
        destination_project_dataset_table=f"{DATASET_ID}.{TABLE_ID}",
        autodetect=True,
        max_bad_records=30,
        # schema_fields=[
        #     {'name': 'name', 'type': 'STRING', 'mode': 'NULLABLE'},
        #     {'name': 'post_abbr', 'type': 'STRING', 'mode': 'NULLABLE'},
        # ],
        write_disposition='WRITE_TRUNCATE',
        gcp_conn_id='google-ee-se-data-conn',
    )
    
    py_task = PythonOperator(
        task_id = "py_task",
        provide_context=True,
        python_callable=print_context
    )
    
    # download_file = GCSToLocalFilesystemOperator(
    #     task_id="download_file",
    #     gcp_conn_id='google-ee-se-data-conn',
    #     object_name=FILE_NAME,
    #     bucket=BUCKET_NAME,
    #     filename=PATH_TO_SAVED_FILE,
    # )
    
    get_latest_load_date >> is_file_updated >> load_csv
