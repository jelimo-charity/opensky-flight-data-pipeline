# load the environment variables from the .env file

from dotenv import load_dotenv
import os

#path to the project root directory
BASE_DIR = os.path.dirname(os.path.dirname(__file__))
#path to env file
dotenv_path = os.path.join(BASE_DIR, '.env')
if os.path.exists(dotenv_path):
    load_dotenv(dotenv_path)



# Get the database connection parameters from environment variables
DB_HOST = os.getenv('DB_HOST')
DB_PORT = os.getenv('DB_PORT')
DB_NAME = os.getenv('DB_NAME')
DB_USER = os.getenv('DB_USER')
DB_PASSWORD = os.getenv('DB_PASSWORD')

# Get the OpenSky API base URL from environment variables
OPENSKY_BASE_URL = os.getenv('opensky_base_url')
CLIENT_ID = os.getenv('clientId')
CLIENT_SECRET = os.getenv('clientSecret')
TOKEN_URL = os.getenv('token_url')


