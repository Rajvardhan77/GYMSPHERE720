import os
import socket
from sqlalchemy import create_engine, text

# IPv6 literal for db.goblhjtikyuwxgjhitsa.supabase.co
# Derived from previous nslookup: 2406:da1c:f42:ae0b:dda:324a:c709:546e
ipv6_address = "2406:da1c:f42:ae0b:dda:324a:c709:546e"
password = "R%40jvardhan%4025"
url = f"postgresql://postgres:{password}@[{ipv6_address}]:5432/postgres"

print(f"Testing IPv6 Literal: {ipv6_address}...")

try:
    engine = create_engine(url, connect_args={"connect_timeout": 5})
    with engine.connect() as connection:
         connection.execute(text("SELECT 1"))
    print("SUCCESS! IPv6 connection worked.")
except Exception as e:
    print(f"Failed: {e}")
