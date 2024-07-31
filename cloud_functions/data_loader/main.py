
from loaders import MoviesLoader, RatingsLoader
    
def movies_loader(event_data, context):
    print("--------#######---------")
    
    filename = event_data["name"]
    bucket_name = event_data["bucket"]

    loader = None
    if filename.startswith("movies_") and filename.endswith(".csv"):
        loader = MoviesLoader()
    elif filename.startswith("ratings_") and filename.endswith(".csv"):
        loader = RatingsLoader()
    try:
        loader.load_csv(filename, bucket_name)
    except AttributeError:
        print("Error in loading csv, no loader found ")
    except Exception as err:
        print(err)