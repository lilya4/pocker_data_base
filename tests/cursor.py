import psycopg2

def execute_query(query):
    conn = psycopg2.connect(
        host='localhost',
        port=1111,
        user='postgres',
        password='postgres',
        database='pg_db'
    )
    cursor = conn.cursor()
    cursor.execute(query)
    result = cursor.fetchall()
    conn.close()
    return result