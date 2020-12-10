# -*- coding: utf-8 -*-

from flask import Flask
from flask_restful import Resource, Api
from flask_cors import CORS
from main import proceso

app = Flask(__name__)
CORS(app)
api = Api(app)

class Api(Resource):
    
    def get(self,tipocarga,periodo,periodo_ini,periodo_fin,fuente,itemvolumen,categoria):      
        p = proceso()
        res = 'error'
        if tipocarga == 'Incremental':
            mes = periodo[0:3]
            ano = periodo[8:10]
            periodo = mes+'_'+str(ano)
            
            if fuente == 'Retail': 
                if itemvolumen == 'Solo item volumen':
                    res = p.solo_item_volumen()
                    print("Retail - solo_item_volumen*********************************************************")
                else:
                    res = p.proceso_retail_(periodo,itemvolumen)
                    print("proceso_retail_ *********************************************************")
            elif fuente == 'Scantrack':
                res = p.proceso_scantrack_(periodo)
                print("Scantrack - Incremental*********************************************************")
            
        elif tipocarga == 'Full - Categoria':
            if fuente == 'Retail':
                res = p.proceso_retail_(periodo,itemvolumen,categoria=categoria)
                print("retail - full categoria*********************************************************")
            elif fuente == 'Scantrack':
                res = p.proceso_scantrack_(periodo,categoria=categoria)
                print("Scantrack - full categoria*********************************************************")
        elif tipocarga == 'Full - Periodo':            
            res = p.proceso_rango_periodo(periodo_ini,periodo_fin,fuente)
            print("proceso_rango_periodo - full Periodo*********************************************************")
                 
        """
        json = [{"tipocarga"         :tipocarga},
                {"periodo"           :periodo},
                {"periodo_ini"       :periodo_ini},
                {"periodo_fin"       :periodo_fin},
                {"fuente"            :fuente},
                {"itemvolumen"       :itemvolumen},
                {"respuesta"         :res}
                ]
        """
        json = [
                {"respuesta"         :res}
                ]
        
        return json
        
api.add_resource(Api, '/tipocarga/<tipocarga>/periodo/<periodo>/periodo_ini/<periodo_ini>/periodo_fin/<periodo_fin>/fuente/<fuente>/itemvolumen/<itemvolumen>/categoria/<categoria>')


if __name__ == '__main__':
    app.run(host='127.0.0.1', port=8000,debug=True) 
    
    
#http://localhost:8000/tipocarga/Incremental/periodo/jul/periodo_ini/nada/periodo_fin/nada/fuente/Retail/itemvolumen/No   