from sqlalchemy import create_engine
from config import (DB_HOST, DB_PORT, DB_NAME, DB_USER, DB_PASSWORD)

def get_db_engine():
    """
    Create and return a SQLAlchemy engine for the PostgreSQL database.
    """
    # Construct the database URL
    db_url = f"postgresql://{DB_USER}:{DB_PASSWORD}@{DB_HOST}:{DB_PORT}/{DB_NAME}"
    
    # Create the SQLAlchemy engine
    engine = create_engine(db_url)
    
    return engine

