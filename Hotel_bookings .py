import pandas as pd
df = pd.read_csv("C:/Users/LENOVO/Downloads/hotel bookings/hotel_bookings.csv")
print(df.head())
print(df.columns)

print(df.info())


#fillning null values with 0 using fillna 
df[["company","agent"]] = df[["company","agent"]].fillna(0)
print(df.head())

#checking if there any null values
print(df.isnull().sum())

print(df.dtypes)

#changing datatype of reservation status date

df["reservation_status_date"] = pd.to_datetime(df["reservation_status_date"])

print(df.dtypes)

# MySQL connection

from sqlalchemy import create_engine
from urllib.parse import quote_plus

USER = "root"
PASSWORD = quote_plus("Svbhate@123")
HOST = "localhost"
PORT = "3306"
DATABASE = "hotel_sales"

engine = create_engine(
    f"mysql+pymysql://{USER}:{PASSWORD}@{HOST}:{PORT}/{DATABASE}"
)

# Upload DataFrame to MySQL
df.to_sql(
    name="hotel_data",
    con=engine,
    if_exists="replace",
    index=False
)

print("Data uploaded successfully!")

# Verify
result = pd.read_sql("SELECT * FROM hoteL_data", con=engine)
print(result.head())