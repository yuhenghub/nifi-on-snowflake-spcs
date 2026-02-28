"""NiFi Demo Dashboard - Streamlit App"""

import streamlit as st
from snowflake.snowpark.context import get_active_session

st.set_page_config(
    page_title="NiFi SPCS Demo",
    page_icon="🚀",
    layout="wide"
)

session = get_active_session()

st.title("🚀 Apache NiFi on SPCS - Demo Dashboard")

# Sidebar
st.sidebar.title("Navigation")
page = st.sidebar.radio("Go to", [
    "📊 Overview",
    "🔍 Data Explorer",
    "⚙️ Services"
])

if page == "📊 Overview":
    st.header("Data Overview")
    
    col1, col2, col3, col4 = st.columns(4)
    
    # Get counts
    try:
        orders_count = session.sql("SELECT COUNT(*) FROM KAFKA_ORDERS").collect()[0][0]
    except:
        orders_count = 0
    try:
        events_count = session.sql("SELECT COUNT(*) FROM KAFKA_EVENTS").collect()[0][0]
    except:
        events_count = 0
    try:
        customers_count = session.sql("SELECT COUNT(*) FROM MYSQL_CUSTOMERS").collect()[0][0]
    except:
        customers_count = 0
    try:
        products_count = session.sql("SELECT COUNT(*) FROM MYSQL_PRODUCTS").collect()[0][0]
    except:
        products_count = 0
    
    col1.metric("Kafka Orders", f"{orders_count:,}")
    col2.metric("Kafka Events", f"{events_count:,}")
    col3.metric("MySQL Customers", f"{customers_count:,}")
    col4.metric("MySQL Products", f"{products_count:,}")
    
    st.subheader("Recent Orders")
    try:
        df = session.sql("""
            SELECT ORDER_ID, CUSTOMER_ID, ORDER_DATE, TOTAL_AMOUNT, STATUS 
            FROM KAFKA_ORDERS 
            ORDER BY INGESTION_TIME DESC 
            LIMIT 10
        """).to_pandas()
        st.dataframe(df, use_container_width=True)
    except Exception as e:
        st.info("No orders data yet. Deploy Kafka demo to see data.")

elif page == "🔍 Data Explorer":
    st.header("Data Explorer")
    
    table = st.selectbox("Select Table", [
        "KAFKA_ORDERS",
        "KAFKA_EVENTS", 
        "MYSQL_CUSTOMERS",
        "MYSQL_PRODUCTS"
    ])
    
    limit = st.slider("Rows to show", 10, 100, 50)
    
    try:
        df = session.sql(f"SELECT * FROM {table} LIMIT {limit}").to_pandas()
        st.dataframe(df, use_container_width=True)
        st.caption(f"Showing {len(df)} rows from {table}")
    except Exception as e:
        st.error(f"Table not found: {table}")

elif page == "⚙️ Services":
    st.header("SPCS Services")
    
    services = ["NIFI_SERVICE", "KAFKA_SERVICE", "MYSQL_SERVICE", "DATA_GENERATOR_SERVICE"]
    
    for svc in services:
        try:
            status = session.sql(f"SELECT SYSTEM$GET_SERVICE_STATUS('{svc}')").collect()[0][0]
            if "READY" in status.upper():
                st.success(f"✅ {svc}: Running")
            else:
                st.warning(f"⏳ {svc}: {status[:50]}...")
        except:
            st.info(f"❌ {svc}: Not deployed")
