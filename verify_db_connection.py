import os
import sys
from dotenv import load_dotenv
from sqlalchemy import create_engine, text

# Load env vars explicitly to be sure, though config.py does it too
load_dotenv()

database_url = os.getenv("DATABASE_URL")
print(f"Loaded DATABASE_URL: {database_url}")

if not database_url:
    print("Error: DATABASE_URL is not set.")
    sys.exit(1)

try:
    engine = create_engine(database_url)
    with engine.connect() as connection:
        result = connection.execute(text("SELECT 1"))
        print(f"Connection successful! Result: {result.scalar()}")
except Exception as e:
    print(f"Connection failed: {e}")
    sys.exit(1)
