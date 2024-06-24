import os
from pykeepass import create_database

# Set the path for the KeePass database
db_path = r"c:\code\secrets\dummy_secrets.kdbx"

# Create the directory if it doesn't exist
os.makedirs(os.path.dirname(db_path), exist_ok=True)

# Create a new KeePass database with a master password
master_password = "your_master_password_here"
kp = create_database(db_path, password=master_password)

# Add a dummy secret
kp.add_entry(kp.root_group, title="Dummy Secret", username="dummy_user", password="dummy_password")

# Save the database
kp.save()

print(f"KeePass database created and saved at: {db_path}")