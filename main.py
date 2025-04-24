import pandas as pd
import sqlalchemy as sal
import kaggle
import zipfile
import mariadb
def main():
    #Extração:
    #kaggle datasets download ankitbansal06/retail-orders -f orders.csv
    #zip_ref = zipfile.ZipFile('orders.csv.zip') 
    #zip_ref.extractall()
    #zip_ref.close()

    #Transformação:

    df = pd.read_csv('orders.csv', na_values=['Not Available','unknown']) #tira os nulls
    # print(df['Ship Mode'].unique()) p achar valores que podem ser tratados como null, dentro do ship mode
    df.columns = df.columns.str.lower()
    df.columns =df.columns.str.replace(' ', '_')
    
    df['discount'] = df['list_price']*df['discount_percent']*0.01 #desconto = (10*5)/100 -> 50/100 -> 1/2 -> 0.5
    df['sale_price'] = df['list_price'] - df['discount'] #preço de venda = 10 (original) - 0.5 (desconto)
    df['profit'] = df['sale_price'] - df['cost_price'] #lucro = 9.5 (venda) - 8 (custo)
    df['order_date'] = pd.to_datetime(df['order_date'], format='%Y-%m-%d')
    df.drop(columns=['list_price', 'cost_price', 'discount_percent'], inplace=True) #remover pq são redundantes, já é possível saber com as colunas novas, inplace pra funcionar
    
    #Load:

    username = "xxx"
    password = "xxx"
    host = "127.0.0.1"
    port = 3306
    database_name = "projpedidos"  
    table_name = "pedidos_dataframe"
    try:
        engine = sal.create_engine(f'mariadb+mariadbconnector://{username}:{password}@{host}:{port}/{database_name}')
        conn = engine.connect()
        df.to_sql(table_name, con=conn, index=False, if_exists='append') 
        print(f"DataFrame successfully appended to table '{table_name}'.")
    except sal.exc.SQLAlchemyError as e:
        print(f"An SQLAlchemy error occurred: {e}")
    except Exception as e:
        print(f"An unexpected error occurred: {e}")    
    #aqui da load no dataframe e manda ele p banco, define nome, conecta com o conector (não cursor), index false p não carregar aquele número redundante do lado de order_id e com replace, se existir, substitui!
    #com append, sobrepõe sem criar uma nova!, por isso que, foi possível criar a tabela com os comandos sql no heidisql que vou deixar no arquivo
    finally:
        if conn:
            conn.close()
            print("Database connection closed.")
        if engine:
            engine.dispose()
            print("Database engine disposed.")

if __name__ == '__main__':
    main()