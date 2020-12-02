
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
    def proceso_retail_(self,periodo,itemvol='No',acumVentas=False):  
        programaRetail = ProcesoRatail()
        if itemvol == "Si":
            programaRetail.main(drop=False, mes=periodo, item_volumen=True,acumVentas=acumVentas)
        else:
            programaRetail.main(drop=False, mes=periodo, item_volumen=False,acumVentas=acumVentas)                
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
        
    def proceso_scantrack_(self,periodo,acumVentas=False):   
        programaScantrack = ProcesoScantrack()
        programaScantrack.main(drop=False, mes=periodo,acumVentas=acumVentas)
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

        
        

"""
mes = 'jul_2020'
itemvolumen = 'No'
p = proceso()
res = p.proceso_retail_(mes,itemvolumen)
"""