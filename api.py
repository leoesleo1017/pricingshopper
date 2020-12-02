# -*- coding: utf-8 -*-

from flask import Flask
from flask_restful import Resource, Api
from flask_cors import CORS
from main import proceso

app = Flask(__name__)
CORS(app)
api = Api(app)

class Api(Resource):
    
    def get(self,tipocarga,periodo,periodo_ini,periodo_fin,fuente,itemvolumen):      
        p = proceso()
        res = 'error'
        if tipocarga == 'Incremental':
            mes = periodo[0:3]
            ano = periodo[8:10]
            periodo = mes+'_'+str(ano)
            
            if fuente == 'Retail': 
                if itemvolumen == 'Solo item volumen':
                    p.solo_item_volumen()
                else:
                    res = p.proceso_retail_(periodo,itemvolumen)
            elif fuente == 'Scantrack':
                res = p.proceso_scantrack_(periodo)
            
        elif tipocarga == 'Full':            
            res = p.proceso_rango_periodo(periodo_ini,periodo_fin,fuente)
                 
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
        
api.add_resource(Api, '/tipocarga/<tipocarga>/periodo/<periodo>/periodo_ini/<periodo_ini>/periodo_fin/<periodo_fin>/fuente/<fuente>/itemvolumen/<itemvolumen>')


if __name__ == '__main__':
    app.run(host='127.0.0.1', port=8000,debug=True) 
    
    
#http://localhost:8000/tipocarga/Incremental/periodo/jul/periodo_ini/nada/periodo_fin/nada/fuente/Retail/itemvolumen/No   