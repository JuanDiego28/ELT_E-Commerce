from typing import Dict

import requests
from pandas import DataFrame, read_csv, read_json, to_datetime
import requests
import pandas as pd
import time
from requests.exceptions import HTTPError
from http import HTTPStatus
import sys


def get_public_holidays(public_holidays_url: str, year: str) -> DataFrame:
    """Get the public holidays for the given year for Brazil.

    Args:
        public_holidays_url (str): url to the public holidays.
        year (str): The year to get the public holidays for.

    Raises:
        SystemExit: If the request fails.

    Returns:
        DataFrame: A dataframe with the public holidays.
    """
    # adapt from various ranges of years: 2017 and 2016-2018
    if "-" in year:
        vct_years = [
            i
            for i in range(
                int(year.strip().split("-")[0]), int(year.strip().split("-")[1]) + 1
            )
        ]
    else:
        vct_years = [int(year.strip())]

    df_publicholidays = pd.DataFrame()

    retry_codes = [
        HTTPStatus.TOO_MANY_REQUESTS,
        HTTPStatus.INTERNAL_SERVER_ERROR,
        HTTPStatus.BAD_GATEWAY,
        HTTPStatus.SERVICE_UNAVAILABLE,
        HTTPStatus.GATEWAY_TIMEOUT,
    ]

    # get the data from the API
    for this_year in vct_years:
        url_year = f"{public_holidays_url}/{str(this_year)}/BR"
        max_tries = 4
        for retries in range(max_tries):
            try:
                response = requests.get(url_year, timeout=15)  # get data from api
                response.raise_for_status()
            except HTTPError as exc:
                if exc.response.status_code in retry_codes:
                    print(
                        f"ERROR=Method failed. Retrying ... # {exc.response.status_code} {retries}"
                    )
                    time.sleep(
                        2 * (2 ** (retries))
                    )  # retry happens after time as a exponent of 2
                    continue
            except requests.exceptions.Timeout:
                print(f"Time out error, retrying ... # {retries}")
            except requests.exceptions.RequestException as e:
                # catastrophic error
                print(f"Request exception: {e}")
                raise SystemExit(e)
            except Exception as e:
                print(f"Request exception: {e}")
                sys.exit(e)
        df_publichol_year = pd.DataFrame(response.json())  # convert to dataframe
        df_publichol_year = df_publichol_year.drop(
            columns=["types", "counties"]
        )  # delete undesired columns
        df_publichol_year["date"] = pd.to_datetime(
            df_publichol_year["date"], format="%Y-%m-%d"
        )  # convert column date into datetime

        df_publicholidays = pd.concat(
            [df_publicholidays, df_publichol_year], ignore_index=True
        )

    return df_publicholidays


def extract(
    csv_folder: str, csv_table_mapping: Dict[str, str], public_holidays_url: str
) -> Dict[str, DataFrame]:
    """Extract the data from the csv files and load them into the dataframes.
    Args:
        csv_folder (str): The path to the csv's folder.
        csv_table_mapping (Dict[str, str]): The mapping of the csv file names to the
        table names.
        public_holidays_url (str): The url to the public holidays.
    Returns:
        Dict[str, DataFrame]: A dictionary with keys as the table names and values as
        the dataframes.
    """
    dataframes = {
        table_name: read_csv(f"{csv_folder}/{csv_file}")
        for csv_file, table_name in csv_table_mapping.items()
    }
    #test
    holidays = get_public_holidays(public_holidays_url, "2017")

    dataframes["public_holidays"] = holidays

    return dataframes

