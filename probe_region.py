import os
from sqlalchemy import create_engine, text

password = "R%40jvardhan%4025"
project_ref = "goblhjtikyuwxgjhitsa"
regions = [
    "aws-0-ap-south-1.pooler.supabase.com",
    "aws-0-ap-southeast-1.pooler.supabase.com",
    "aws-0-us-east-1.pooler.supabase.com",
    "aws-0-eu-central-1.pooler.supabase.com",
    "aws-0-us-west-1.pooler.supabase.com"
]

for host in regions:
    url = f"postgresql://postgres.{project_ref}:{password}@{host}:6543/postgres"
    print(f"Testing {host}...", end=" ", flush=True)
    try:
        engine = create_engine(url, connect_args={"connect_timeout": 5})
        with engine.connect() as connection:
             connection.execute(text("SELECT 1"))
        print("SUCCESS! This is the correct region.")
        print(f"Correct Host: {host}")
        break  # Found it
    except Exception as e:
        msg = str(e)
        if "Tenant or user not found" in msg:
            print("Failed (Tenant not found)")
        elif "could not translate host name" in msg:
            print("Failed (DNS Error)")
        else:
            # Maybe timeout or other error
            print(f"Failed ({type(e).__name__})")
