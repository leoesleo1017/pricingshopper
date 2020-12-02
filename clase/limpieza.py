# -*- coding: utf-8 -*-
"""
Created on Tue Oct  1 09:01:00 2019

@author: leonardo.patino
"""

from clase.logger import logger

class Limpieza():
    def __init__(self):
        self.log = logger()
        
    def quitar_nan(self,df):
        #quitar duplicados a todo el df
        df = df.fillna(0)
    
    def quitarnull(self,df):
        df = df.isnull().sum(axis = 0) 
        return df
    
    def diagnostico_univariado(self,var,n_des_a=3,n_des_b=2,metodo='des'):
        try:        
            """
            Método que entrega un porcentaje de datos atipicos utilizando dos metodos
            n_des_a: numero de desviaciones hacia arriba
            n_des_b: numero de desviaciones hacia abajo.
            """
            if metodo == 'des':
                # método:  n desviaciones estándar de la media. 
                est_max = var.describe()[1] + (var.describe()[2] * n_des_a)
                est_min = var.describe()[1] - (var.describe()[2] * n_des_b)
            elif metodo == 'cuantil':
                # método: cuantiles
                est_max = var.quantile(0.99) 
                est_min = var.quantile(0.01)        
            ati_alto = round((len(var[var>=est_max]) / len(var) * 100),2)
            ati_bajo = round((len(var[var<=est_min]) / len(var) * 100),2)
            self.log.Info("Diagnostico Univariado generado") 
            return ati_alto,ati_bajo
        except Exception as e:
            self.log.Error("Error al carlcular el diagnostico Error: " + str(e))
            
    def buscar_cuantitativos(self,df):
        """
        Método que busca los formatos int64 y float64 de un dataframe 
        y devuelve una lista con esas variables.
        """
        try:    
            i = 0
            n = df.shape[1]
            lista = []
            while i < n:    
                if str(df.dtypes[i]) == 'int64' or str(df.dtypes[i]) == 'float64':
                    print(df.columns[i])
                    lista.append(df.columns[i])        
                i = i + 1
            self.log.Info("Busqueda de cuantitativos generado")     
            return lista 
        except Exception as e:
            self.log.Error("Error al buscar cuantitativos Error: " + str(e))
            
    def buscar_cualitativos(self,df):
        """
        Método que busca los formatos object de un dataframe 
        y devuelve una lista con esas variables.
        """
        try:    
            i = 0
            n = df.shape[1]
            lista = []
            while i < n:    
                if str(df.dtypes[i]) == 'object':
                    print(df.columns[i])
                    lista.append(df.columns[i])        
                i = i + 1
            self.log.Info("Busqueda de cualitativos generado")     
            return lista 
        except Exception as e:
            self.log.Error("Error al buscar cualitativos Error: " + str(e))
    
    def diagnostico_df(self,df,n_des_a=False,n_des_b=False,metodo=False):
        """
        Método que recibe un dataframe y devuelve un % de tener atípicos por
        cada variable.
        """
        try:
            lista = self.buscar_cuantitativos(df)
            i = 0
            n = len(lista)
            d_lista = []
            while i < n:
                if n_des_a == False or n_des_b == False or metodo == False:
                    r = self.diagnostico_univariado(df[lista[i]])
                else:
                    r = self.diagnostico_univariado(df[lista[i]],n_des_a,n_des_b,metodo)
                e = lista[i],"Atípico hacia arriba %",r[0],"Atípico hacia abajo %",r[1]
                d_lista.append(e)
                i = i + 1  
            self.log.Info("Diagnostico dataframe generado")      
            return d_lista
        except Exception as e:
            self.log.Error("Error al calcular diagnostico Error: " + str(e))
      
    def vali_formatos(self,var):
        """
        Método que recibe una variable cualitativa y devuelve 
        un % de ser una variable cuantitativa.
        """
        try:            
            a = 0
            i = 0
            n = len(var)
            while i < n:
                try:
                    int(var[i])
                except Exception as e:
                    pass
                else:
                    a = a + 1
                i = i + 1    
            res = round((a/n) * 100,2,)," de ser una variable cuantitativa"
            self.log.Info("Validación de formatos generado")  
            return res 
        except Exception as e:
            self.log.Error("Error al validar los formatos: " + str(e))
    
    def inconsistencia_formatos(self,df):
        """
        Método que recibe un dataframe y devuelve una ista con un %
        de ser una variable cuantitativa por cada columna.
        """
        try:
            lista = self.buscar_cualitativos(df)
            i = 0
            n = len(lista)
            d_lista = []
            while i < n:
                r = self.vali_formatos(df[lista[i]])
                m = "Variable: ",lista[i],r
                d_lista.append(m)
                i = i + 1
            self.log.Info("Inconsistencia de formatos generado")  
            return d_lista
        except Exception as e:
            self.log.Error("Error al validar los formatos: " + str(e))
        
        def quitar_atipicos_univariado(self,var,n_des_a=3,n_des_b=2,metodo='des'):
            """
            Método que busca los atípicos según el metodo y los reemplaza por 
            la media del vector.
            """
            try:
                if metodo == 'des':
                    # método:  n desviaciones estándar de la media. 
                    est_max = var.describe()[1] + (var.describe()[2] * n_des_a)
                    est_min = var.describe()[1] - (var.describe()[2] * n_des_b)
                elif metodo == 'cuantil':
                    # método: cuantiles
                    est_max = var.quantile(0.99) 
                    est_min = var.quantile(0.01)        
                ati_alto = round((len(var[var>=est_max]) / len(var) * 100),2)
                ati_bajo = round((len(var[var<=est_min]) / len(var) * 100),2)
                
                self.log.Info("Se ha quitado los atípicos")
                return
            except Exception as e:
                self.log.Error("Error al quitar atípicos: " + str(e))    
            

"""        
email = leo@gmail
if "@" not in email:
    print()
"""    


"""
en base a un % de ser una variable cuantitativa convertir de str a in y quitar los demás
en base a un % reemplazar los atipicos con la mediana
probar con otro df los metodos
resumen de nan
resumen de datos 
"""