
from loaders import Loader
    
def data_loader(event_data, context):
    print("--------#######---------")
    
    filename = event_data["name"]
    bucket_name = event_data["bucket"]

    loader = get_loader(filename,bucket_name)
    try:
        loader.load_csv()
    except AttributeError:
        print("Error in loading csv, no loader found ")
    except Exception as err:
        print(err)

def get_loader(filename, bucket_name):
    region = "asia-south1"
    dataset_id = "movies_data_ajit"
    return Loader(region,dataset_id,filename,bucket_name)
