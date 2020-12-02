"""
Created on Mon Feb 10 10:51:34 2020

@author: leonardo.patino
"""
import mysql.connector # MySQL
import psycopg2 #postgresql

class Sql_alterno():
    
    def __init__(self,cache):
        self.debug=False
        self.cache = cache
        
        self.motor               = self.cache["database_motor"]
        self.database_username   = self.cache["database_username"]
        self.database_password   = self.cache["database_password"]
        self.database_ip         = self.cache["database_ip"]
        self.database_name       = self.cache["database_name"]
        self.database_driver     = self.cache["database_driver"]
        self.database_options    = self.cache["database_options"]
        
                     
    def conection(self):
        if self.motor == 'mysql':
            return mysql.connector.connect(
                      host=self.database_ip, 
                      user=self.database_username,
                      passwd=self.database_password,
                      database=self.database_name,
                    )
        elif self.motor == 'postgresql':
            return psycopg2.connect(
                      host=self.database_ip,                      
                      user=self.database_username,
                      password=self.database_password,
                      database=self.database_name,
                      options='-c search_path=' + self.database_options,
                    )  
        
       
    def execute(self,query,param=None):
        """Ejecuta una instrucción en específico, si param es 'none' sin devolución 
           de resultados de lo contrario devuelve las filas recuperadas"""
        try:
            conection = self.conection()
            cur = conection.cursor()
            cur.execute(query)                      
            if param is None:
                conection.commit()            
                conection.close()
                return "ejecución ok"
            else:              
                res = cur.fetchall() #método, que recupera todas las filas de la última instrucción ejecutada.
                conection.close()
                return res
        except Exception as e:
            print("Problemas para ejecutar en sql ",e)
            return "error"
            

