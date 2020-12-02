# -*- coding: utf-8 -*-
"""
Created on Thu Oct 15 14:34:46 2020

@author: CAP04
"""

# -*- coding: utf-8 -*-  
from flask import Flask
from flask_restful import Resource, Api
from flask_cors import CORS
from clase.sql import Sql
from clase.logger import logger
from conf.get_config import Get_config

app = Flask(__name__)
CORS(app)
api = Api(app)

class Api(Resource):
    
    def get(self,param):      
        log = logger()
        conexion = Get_config()
        m = Sql(conexion.get_config('postgresql_scantrack'),log)
        
        query = "SELECT * FROM public.conf_logs ORDER BY log ASC"
        c_logs = m.execute(query,param=True)    
        
        query = """
                SELECT replace(REPLACE(substr(LOG,30,100),'*',''),' ','') as log
                FROM public.conf_logs
                WHERE LOG LIKE '%Rutinas core%'
                OR LOG LIKE '%Agregar Variables Adicionales%'
                OR LOG LIKE '%Actualizar Codificaciones%'
                OR LOG LIKE '%Ficheros Codificaciones%'
                OR LOG LIKE '%transaccional ventas%'
                OR LOG LIKE '%Volumen Generado%'
                OR LOG LIKE '%Registros%'
                ORDER BY log DESC 
                """
        m_logs = m.execute(query,param=True)  

        json_logs = [
                    {"log"               :c_logs},
                    {"mlog"              :m_logs}
                    ]         
        
        return json_logs
        
api.add_resource(Api, '/param/<param>')


if __name__ == '__main__':
    app.run(host='127.0.0.1', port=8080,debug=True) 
    
    
#http://localhost:8000/fecha_ini/2020-12-01/fecha_fin/2020-12-02/secuencia/leito/date/5-433-45-6       