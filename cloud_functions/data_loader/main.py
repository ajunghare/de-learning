
from loaders import MoviesLoader, RatingsLoader
    
def data_loader(event_data, context):
    print("--------#######---------")
    
    filename = event_data["name"]
    bucket_name = event_data["bucket"]

    loader = get_loader(filename,filename,bucket_name)
    try:
        loader.load_csv()
    except AttributeError:
        print("Error in loading csv, no loader found ")
    except Exception as err:
        print(err)

def get_loader(filename,bucket_name):
    if filename.startswith("movies_") and filename.endswith(".csv"):
        return MoviesLoader(filename,bucket_name)
    elif filename.startswith("ratings_") and filename.endswith(".csv"):
        return RatingsLoader(filename,bucket_name)
    return None