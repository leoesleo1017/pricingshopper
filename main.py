
# -*- coding: utf-8 -*-
"""
Created on Mon Sep 21 12:55:07 2020

@author: CAP04
"""
from datetime import datetime
#from datetime import timedelta
from dateutil.relativedelta import relativedelta
from proceso_retail import ProcesoRatail
from proceso_scantrack  import ProcesoScantrack 

class proceso:    
    def proceso_retail_(self,periodo,itemvol='No',acumVentas=False,categoria=None):  
        programaRetail = ProcesoRatail()        
        if itemvol == "Si" and categoria is None:
            periodoOasis = periodo[-2:] + '20-' + self.val_Cero(str(self.format_mes_num(periodo[0:3]))) + '-01'
            programaRetail.main(drop=False, mes=periodo, periodoOasis=periodoOasis, item_volumen=True, categoria=categoria, acumVentas=acumVentas)
        else:
            programaRetail.main(drop=False, mes=periodo, item_volumen=False, categoria=categoria, acumVentas=acumVentas)                
        #res = programaRetail.actualizarcodificaciones()
        #res = programaRetail.reglas_varadinegocios()
        #res = programaRetail.actualizarvariablesadicionales()
        #res = programaRetail.guardartransaccionalventas()
        #res = programaRetail.ficheroscodificaciones()
        return "ok"    
    
    def solo_item_volumen(self):
        programaRetail = ProcesoRatail()
        res = programaRetail.itemvolumen(item_volumen=True)
        return res
        
    def proceso_scantrack_(self,periodo,acumVentas=False,categoria=None):   
        programaScantrack = ProcesoScantrack()
        programaScantrack.main(drop=False, mes=periodo,categoria=categoria,acumVentas=acumVentas)
        #programaScantrack.actualizarcodificaciones()
        #programaScantrack.reglas_varadinegocios()
        return "ok"
    
    def proceso_rango_periodo(self,periodo_ini,periodo_fin,fuente):
        fecha_ini = datetime.now().date() - relativedelta(months=60)
        v_fechas = []
        i = 0
        while i < 60:
            fecha = fecha_ini + relativedelta(months=i)
            v_fechas.append(fecha)
            i += 1 
        fecha_ini = datetime(int(periodo_ini[6:10]), self.format_mes_num(periodo_ini[0:3]), 1)
        fecha_fin = datetime(int(periodo_fin[6:10]), self.format_mes_num(periodo_fin[0:3]), 1)       
        rango = []        
        for i in range(len(v_fechas)):
            if v_fechas[i] >= fecha_ini.date() and v_fechas[i] <= fecha_fin.date():
                rango.append(v_fechas[i]) 
        print("El rango es : ",rango)        
        if fuente == 'Retail':
            for i in range(len(rango)):                
                tabla = str(self.format_mes_str(rango[i].month)) + '_' + str(rango[i].year)[2:4]             
                self.proceso_retail_(tabla,acumVentas=True)
                print(tabla)
            return "ok" 
        elif fuente == 'Scantrack':
            for i in range(len(rango)):                
                tabla = str(self.format_mes_str(rango[i].month)) + '_' + str(rango[i].year)[2:4]
                self.proceso_scantrack_(tabla,acumVentas=True)
                print(tabla)
            return "ok" 
            
        return "error"        
                
           
    def format_mes_num(self,mes):
        if mes == 'ene':
            salida = 1
        elif mes == 'feb':
            salida = 2
        elif mes == 'mar':
            salida = 3
        elif mes == 'abr':
            salida = 4
        elif mes == 'may':
            salida = 5
        elif mes == 'jun':
            salida = 6
        elif mes == 'jul':
            salida = 7
        elif mes == 'ago':
            salida = 8
        elif mes == 'sep':
            salida = 9
        elif mes == 'oct':
            salida = 10
        elif mes == 'nov':
            salida = 11
        elif mes == 'dic':
            salida = 12
        return salida    
    
    def format_mes_str(self,mes):
        if mes == 1:
            salida = 'ene'
        elif mes == 2:
            salida = 'feb'
        elif mes == 3:
            salida = 'mar'
        elif mes == 4:
            salida = 'abr'
        elif mes == 5:
            salida = 'may'
        elif mes == 6:
            salida = 'jun'
        elif mes == 7:
            salida = 'jul'
        elif mes == 8:
            salida = 'ago'
        elif mes == 9:
            salida = 'sep'
        elif mes == 10:
            salida = 'oct'
        elif mes == 11:
            salida = 'nov'
        elif mes == 12:
            salida = 'dic'
        return salida 

    def val_Cero(self,param):
        """
        valida si el mes es de 1 a 9 para adicionar el cero
        """
        if len(param) == 1:
            param = "0" + param
        return param
        

""" TEST RETAIL
periodo = 'jul_20'
itemvolumen = 'No'
p = proceso()
periodoOasis = periodo[-2:] + '20-' + p.val_Cero(str(p.format_mes_num(periodo[0:3]))) + '-01'
acumVentas = False
categoria = 'CAFE MOLIDO'

#validar solo carga oasis
programaRetail = ProcesoRatail()
res_oasis = programaRetail.insumoOasisconexion('nielsen_retail_' + periodo,periodoOasis)
print(res_oasis)

programaRetail = ProcesoRatail()
programaRetail.main(drop=False, mes=periodo, periodoOasis=periodoOasis, item_volumen=False, categoria=categoria, acumVentas=acumVentas)

"""

""" TEST SCANTRACK  #hay que formatear los campos de scantrack 
periodo = 'jul_20'
ano = '2020'
grupo = '5'
periodoOasis = {'ano' : ano, 'grupo' : grupo}  
categoria = 'CAFE MOLIDO'

p = proceso()
acumVentas = False  

#validar solo carga oasis
programaScantrack = ProcesoScantrack()
programaScantrack.main(drop=False, mes=periodo, periodoOasis=periodoOasis, categoria=categoria, acumVentas=acumVentas)
"""