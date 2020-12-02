# -*- coding: utf-8 -*-
"""
Created on Tue Oct  1 09:01:00 2019

@author: leonardo.patino
"""

import matplotlib.pyplot as plt
import pandas as pd
import numpy as np
from scipy import stats # importando scipy.stats
import scipy.stats as sp  
import seaborn as sns
from clase.logger import logger
import matplotlib.pyplot as plt # importando matplotlib
import seaborn as sns # importando seaborn
from matplotlib.patches import Polygon
    
class Analisis():
    def __init__(self):
        self.log = logger()
    
    #multivariado_cuantitativo
    def matriz_correlacion(self,df):
        try:
            corr_seaborn = df.corr()
            sns.heatmap(corr_seaborn, 
            xticklabels=corr_seaborn.columns.values,
            yticklabels=corr_seaborn.columns.values)
            
            self.log.Info("Matriz de correlación calculada correctamente")  
        except Exception as e:
            self.log.Error("Problemas para hacer la matriz_correlacion " + str(e))
               
    def sesgo_caracteristicas(self,df):
        sns.pairplot(df)
        self.log.Info("sesgo caracteristicas calculada correctamente")
        return "sesgo caracteristicas calculada correctamente"
    
    def multi_cuanti(self,var1,var2):
        np.cov(var1,var2)       #covarianza
        np.corrcoef(var1,var2)  #correlacion
            
    #multivariado_cualitativo
    def tbl_frec_multivariado(self,df,index,columns):
        try:            
            # Tabla de contingencia doble entrada        
            a = pd.crosstab(index=index,columns=columns, margins=True)
            
            # tabla de contingencia en porcentajes relativos segun clase
            b = pd.crosstab(index=index, columns=columns
                       ).apply(lambda r: r/r.sum() *100,axis=0)
            
            # tabla de contingencia en porcentajes relativos total
            c = pd.crosstab(index=index, columns=columns,
                margins=True).apply(lambda r: r/len(df) *100,
                                    axis=1)
            
            self.log.Info("Tabla de contingencia doble entrada calculada correctamente")                
            return a,b,c
        except Exception as e:
            self.log.Error("Problemas para construir la tabla de frecuencia multivariado " + str(e))
                 
    #graficos multivariado_cualitativo
    def frec_barras_multivariado(self,index,columns):
        try: 
            # Gráfico de barras de frecuencia segun variable
            pd.crosstab(index=index,
                        columns=columns).apply(lambda r: r/r.sum() *100,
                                                          axis=1).plot(kind='bar')
            # Gráfico de barras de frecuencia segun variable acumulado
            pd.crosstab(index=index,
                        columns=columns
                              ).apply(lambda r: r/r.sum() *100,
                                      axis=0).plot(kind='bar', stacked=True)
            
            self.log.Info("Graficos multivariados calculados correctamente")                

        except Exception as e:
            self.log.Error("Problemas para construir los graficos multivariado " + str(e))
                
    #univariado_cuantitativo
    def descriptiva(self,var):
        try:        
            descriptiva = {
                   "cuenta"     : var.describe()[0],
                   "media"      : var.describe()[1],
                   "de"         : var.describe()[2],
                   "min"        : var.describe()[3],    
                   "max"        : var.describe()[7],
                   "q1"         : var.describe()[4],
                   "q2"         : var.describe()[5],
                   "q3"         : var.describe()[6],    
                   "varianza"   : np.var(var),
                   "moda"       : var.mode(),
                   "mediana"    : var.median(),
                   "rango"      : max(var)-min(var),
                   "suma"       : sum(var),
                   "iqr"        : var.quantile(0.75) - var.quantile(0.25),
                   "asimetria"  : sp.skew(var),
                   "curtosis"   : sp.kurtosis(var),
             }
            self.log.Info("Estadisticos calculados correctamente")
            return descriptiva
        except Exception as e:
            self.log.Error("Problemas para calcular los estadisticos " + str(e))
            
    def tbl_frec_univariado(self,var):
        a = pd.value_counts(var) #frecuencia de clases
        b = 100 * var.value_counts() / len(var) # frecuencia relativa        
        return a,b
    
    def graf_univariado_cuant(self,var,titulo="graficos"):
        #grafico univariado cuantitativo
        try:
            fig, axs = plt.subplots(1, 2)
            var.value_counts().plot(kind="line",title=titulo)
            var.value_counts().plot(kind="bar",title=titulo)  
        except Exception as e:
            self.log.Error("Problemas para calcular la grafica, esta función solo admite variables cuantitativas" + str(e))    
        
    def graf_univariado_fre_rel(self,var,tipo="bar",titulo="bar"): 
         # gráfico de barras de frecuencias relativas.
        (100 * var.value_counts() / len(var)).plot(
                kind=tipo, title=titulo)
    
    #grafico univariado cualitativo
    def graf_univariado_cuali_torta(self,var,tipo="pie",titulo="pie"):
        # Gráfico de tarta
        var.value_counts().plot(kind=tipo, autopct='%.2f', 
                        figsize=(6, 6),
                        title=titulo)
               
    #grafico univariado_cuantitativo            
    def seaborn(self,var):
        # parametros esteticos de seaborn
        sns.set_palette("deep", desat=.6)
        sns.set_context(rc={"figure.figsize": (8, 4)})
        mu, sigma = var.describe()[1], var.describe()[2] # media y desvio estandar
        s = var        

        cuenta, cajas, ignorar = plt.hist(s, 30, normed=True)
        plt.plot(cajas, 1/(sigma * np.sqrt(2 * np.pi)) *
                 np.exp( - (cajas - mu)**2 / (2 * sigma**2) ),
                 linewidth=2, color='r')   
        
    def histograma(self,var,titulo='Histograma'):
        cuenta, cajas, ignorar = plt.hist(var, 20)
        plt.ylabel('frequencia')
        plt.xlabel('valores')
        plt.title(titulo)
        plt.show()
    
    def box_plot_multi(self,df):
        df.plot.box(grid='True')

    def box_plot_univ(self,df):
        fig, axs = plt.subplots(2, 3)
        # basic plot
        axs[0, 0].boxplot(df)
        axs[0, 0].set_title('basic plot')
        
        # notched plot
        axs[0, 1].boxplot(df, 1)
        axs[0, 1].set_title('notched plot')
        
        # change outlier point symbols
        axs[0, 2].boxplot(df, 0, 'gD')
        axs[0, 2].set_title('change outlier\npoint symbols')
        
        # don't show outlier points
        axs[1, 0].boxplot(df, 0, '')
        axs[1, 0].set_title("don't show\noutlier points")
        
        # horizontal boxes
        axs[1, 1].boxplot(df, 0, 'rs', 0)
        axs[1, 1].set_title('horizontal boxes')
        
        # change whisker length
        axs[1, 2].boxplot(df, 0, 'rs', 0, 0.75)
        axs[1, 2].set_title('change whisker length')
        
        
        
        
#distribuciones y probabilidades
#https://relopezbriega.github.io/blog/2016/06/29/distribuciones-de-probabilidad-con-python/
          