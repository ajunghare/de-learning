from google.cloud import bigquery


class Loader:

    def __init__(self, table_id, region, dataset_id,filename,bucket_name):
        self.table_id = table_id
        self.region = region
        self.dataset_id = dataset_id
        self.filename = filename
        self.bucket_name = bucket_name

    def load_csv(self):

        client = bigquery.Client()
        project = client.project
        dataset_ref = bigquery.DatasetReference(project, self.dataset_id)

        self.get_table_from_id(client, dataset_ref)
        self.prepare_job_config()

        job = client.load_table_from_uri(
            "gs://{bucket_name}/{filename}".format(
                bucket_name=self.bucket_name, filename=self.filename
            ),
            self.table_ref,
            location=self.region,  # Must match the destination dataset location.
            project=project,
            job_config=self.job_config,
        )  # API request

        job.result()  # Waits for table load to complete.
        print(
            "Loaded {} rows into {}:{}.".format(
                job.output_rows, self.dataset_id, self.table_ref.table_id
            )
        )

    def get_table_from_id(self, client, dataset_ref):
        table_ref = dataset_ref.table(self.table_id)
        table = client.get_table(table_ref)
        print("Table {} contains {} columns.".format(self.table_id, len(table.schema)))
        self.table_ref = table_ref
        self.table = table

    def prepare_job_config(self):
        job_config = bigquery.LoadJobConfig()
        job_config.write_disposition = bigquery.WriteDisposition.WRITE_APPEND
        job_config.schema_update_options = [
            bigquery.SchemaUpdateOption.ALLOW_FIELD_ADDITION
        ]
        schema_list = []
        print("table schema list", self.table.schema)
        for field in self.table.schema:
            if field.name != "load_date":
                schema_list.append(
                    bigquery.SchemaField(
                        name=field.name, field_type=field.field_type, mode=field.mode
                    )
                )

        job_config.schema = schema_list
        job_config.source_format = bigquery.SourceFormat.CSV
        job_config.skip_leading_rows = 1
        self.job_config = job_config


class MoviesLoader(Loader):
    table_id = "movies_raw"
    region = "asia-south1"
    dataset_id = "movies_data_ajit"
    def __init__(self, filename, bucket_name):
        super().__init__(self.table_id, self.region, self.dataset_id, filename, bucket_name)


class RatingsLoader(Loader):
    table_id = "ratings_raw"
    region = "asia-south1"
    dataset_id = "movies_data_ajit"
    def __init__(self, filename, bucket_name):
        super().__init__(self.table_id, self.region, self.dataset_id, filename, bucket_name)
