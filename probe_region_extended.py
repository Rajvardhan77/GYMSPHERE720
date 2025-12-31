import os
from sqlalchemy import create_engine, text

password = "R%40jvardhan%4025"
project_ref = "goblhjtikyuwxgjhitsa"
regions = [
    "aws-0-ap-southeast-2.pooler.supabase.com", # Sydney
    "aws-0-ap-northeast-1.pooler.supabase.com", # Tokyo
    "aws-0-ap-northeast-2.pooler.supabase.com", # Seoul
    "aws-0-eu-west-1.pooler.supabase.com",      # Ireland
    "aws-0-eu-west-2.pooler.supabase.com",      # London
    "aws-0-us-east-2.pooler.supabase.com",      # Ohio
    "aws-0-sa-east-1.pooler.supabase.com",      # Sao Paulo
    "aws-0-ca-central-1.pooler.supabase.com",   # Canada
]

print(f"Project: {project_ref}")

for host in regions:
    url = f"postgresql://postgres.{project_ref}:{password}@{host}:6543/postgres"
    print(f"Testing {host}...", end=" ", flush=True)
    try:
        engine = create_engine(url, connect_args={"connect_timeout": 5})
        with engine.connect() as connection:
             connection.execute(text("SELECT 1"))
        print("\nSUCCESS! This is the correct region.")
        print(f"Correct Host: {host}")
        break
    except Exception as e:
        msg = str(e)
        if "Tenant or user not found" in msg:
            print("Failed (Tenant not found)")
        elif "password authentication failed" in msg:
             print("\nFAILED: Password incorrect, but Region is CORRECT!")
             print(f"Host: {host}")
             break
        elif "could not translate host name" in msg:
            print("Failed (DNS Error)")
        else:
            print(f"Failed ({msg})")
