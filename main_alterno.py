"""
@author: leonardo.patino
"""
import argparse
import math
import json
import pandas as pd
import numpy as np

from clase.logger import logger
from clase.sql import Sql
#from clase.analisis import Analisis
#from clase.limpieza import Limpieza
#from clase.additional_variables import EnrichmentOps

class Main:    
    def __init__(self): 
        pass
                       
    def get_config(self,bd): #este metodo puede ir en la super clase 
        with open('conexion/'+bd+'.json') as f_in:
            json_str = f_in.read()
            return json.loads(json_str)
            
    def main(self):
        log.Info("********** Ejecución iniciada *********")
        
        #CORE
        folder = 'sql/' 
        drop = False
        
        log.Info("********** Rutinas core ... *****************")
        #m.executeFile(folder + '00_s_min_level.sql') 
        
        lista_rutinas = (
            '00_s_min_level.sql',
            '01_rutina_jerarquiaCategorias.sql',
            '02_rutina_var_adi_negocios.sql',
            '03_rutina_var_adi_rangos.sql',
            '04_subrutina_rango_precio.sql',
            '04_subrutina_rango_precio_individual.sql',
            '04_subrutina_rango_tamano.sql',
            '04_subrutina_rango_tamano_individual.sql',
            '04_rutina_rangos.sql',
            '05_rutina_codificacion.sql',
            '06_subrutina_productos.sql',
            '07_subrutina_maestra_productos.sql',
            '08_subrutina_atributos_mercado.sql',
            '09_rutina_transaccional_ventas.sql',
            '10_rutina_eliminar_tablastemp.sql'            
            )
        
        i = 1
        while i < len(lista_rutinas):    
            try:
                if lista_rutinas[i] != '10_rutina_eliminar_tablastemp.sql':
                    res = m.executeFile(folder + lista_rutinas[i])
                    #print("Ejecutando: ",lista_rutinas[i])
                    #res = 'ok'
                    if res == 'error':
                        log.Error("Proceso suspendido problemas con " + lista_rutinas[i])
                        break
                elif lista_rutinas[i] == '10_rutina_eliminar_tablastemp.sql':
                    if drop:
                        m.executeFile(folder + lista_rutinas[i])
                        #print("Eliminar: ",lista_rutinas[i])
                i += 1        
            except Exception as e:
                log.Error("Problemas con " + lista_rutinas[i] + " " + str(e))
                break 
            
                    
        """
        prueba postgresql
        query = "select * from prueba"
        c = m.execute(query,param=True)
        print(c)
        
        #guardar df en carpeta salidas
        m.listar_sql(query,fichero=True,nombre='Prueba')
        """        
        #cargar un catalogo
        """
        df = pd.read_csv("ficheros/nuevos_productos1.csv",delimiter=';')
        m.insert_sql_masivo(df,name_table = 'sa_maproducto')
        #m.insert_sql(df,name_table = 'ma_producto3')
        """
        
        log.Info("********** Fin Ejecución **************")

                                         
#instancias         
log = logger()
#a = Analisis()
#l = Limpieza()

#i = EnrichmentOps()

programa = Main()

m = Sql(programa.get_config('postgresql_retail'),log)

#df = programa.main()
  
        
    
    
    