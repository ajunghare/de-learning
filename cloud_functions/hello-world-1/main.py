import functions_framework.background_event


# Register a CloudEvent function with the Functions Framework
# @functions_framework.background_event
def invoke_on_event(event_data, context):
    # Your code here
    print ("--------#######---------")
    print(f"Event ID: {context.event_id}")
    print(f"Event type: {context.event_type}")
    print("Bucket: {}".format(event_data["bucket"]))
    print("File: {}".format(event_data["name"]))
    print("Metageneration: {}".format(event_data["metageneration"]))
    print("Created: {}".format(event_data["timeCreated"]))
    print("Updated: {}".format(event_data["updated"]))
    print ("--------#######---------")
    filename = event_data["name"]
    if filename.startswith("movies_") and filename.endswith(".csv"):
        #this file could be added to GBQ
        from google.cloud import bigquery as bq
        client = bq.Client()
        dataset_id = "ee-india-se-data.movies_data_ajit"
        dataset = bq.Dataset(dataset_id)
        dataset = client.get_dataset(dataset)

        
