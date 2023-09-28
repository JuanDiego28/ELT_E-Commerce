import sqlite3
import pandas as pd

from typing import Dict

from pandas import DataFrame
from sqlalchemy.engine.base import Engine


def load(data_frames: Dict[str, DataFrame], database: Engine):
    """Load the dataframes into the sqlite database.

    Args:
        data_frames (Dict[str, DataFrame]): A dictionary with keys as the table names
        and values as the dataframes.
    """
    with database.begin() as connection:
        for tablename, df_toload in data_frames.items():
            df_toload.to_sql(tablename, connection, if_exists="replace", index=False)
# test 
