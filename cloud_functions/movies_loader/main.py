from google.cloud import bigquery

def movies_loader(event_data, context):
    print("--------#######---------")
    filename = event_data["name"]
    bucket_name = event_data["bucket"]
    if filename.startswith("movies_") and filename.endswith(".csv"):

        client = bigquery.Client()
        project = client.project
        dataset_id = "movies_data_ajit"
        dataset_ref = bigquery.DatasetReference(project, dataset_id)

        table_id = "movies_raw"
        table_ref = dataset_ref.table(table_id)
        table = client.get_table(table_ref)
        print("Table {} contains {} columns.".format(table_id, len(table.schema)))

        job_config = bigquery.LoadJobConfig()
        job_config.write_disposition = bigquery.WriteDisposition.WRITE_APPEND
        job_config.schema_update_options = [
            bigquery.SchemaUpdateOption.ALLOW_FIELD_ADDITION
        ]
        schema_list = []
        print("table schema list", table.schema)
        for field in table.schema:
            if field.name != "load_date":
                schema_list.append(bigquery.SchemaField(name=field.name, field_type=field.field_type, mode=field.mode))

        job_config.schema = schema_list
        job_config.source_format = bigquery.SourceFormat.CSV
        job_config.skip_leading_rows = 1
        job = client.load_table_from_uri(
            "gs://{bucket_name}/{filename}".format(bucket_name=bucket_name,filename=filename),
            table_ref,
            location="asia-south1",  # Must match the destination dataset location.
            project=project,
            job_config=job_config,
        )  # API request
        job.result()  # Waits for table load to complete.
        print(
            "Loaded {} rows into {}:{}.".format(
                job.output_rows, dataset_id, table_ref.table_id
            )
        )
