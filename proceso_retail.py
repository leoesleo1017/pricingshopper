
"""
@author: leonardo.patino
"""
import json
import pandas as pd

from clase.logger import logger
from clase.sql import Sql
from clase.additional_variables import EnrichmentOps

class ProcesoRatail:    
    def __init__(self): 
        self.folder = 'sql/rutinas_retail/' 
        #self.item_volumen = True
                       
    def get_config(self,bd): #este metodo puede ir en la super clase 
        with open('conexion/'+bd+'.json') as f_in:
            json_str = f_in.read()
            return json.loads(json_str)
    
    def validar_vista(self,df): 
        msg = "validar estructura"
        log.Info(msg)
        m.escribirLog_config("[Info] " + msg)  
        list_formatos = [
            'object',
            'object',
            'object',
            'object',
            'object',
            'float64',
            'object',
            'object',
            'object',
            'object',
            'object',
            'object',
            'object',
            'object',
            'object',
            'object',
            'object',
            'int64',
            'int64',
            'object',
            'object',
            'object',
            'object',
            'object',
            'int64',
            'object',
            'object',
            'object',
            'object',
            'object',
            'object',
            'object',
            'object',
            'float64',
            'float64',
            'float64',
            'float64',
            'float64',
            'float64',
            'float64',
            'float64',
            'float64',
            'float64',
            'float64',
            'float64',
            'float64',
            'float64',
            'float64',
            'float64',
            'float64',
            'float64',
            'float64',
            'float64',
            'float64',
            'float64',
            'float64',
            'float64',
            'float64',
            'float64',
            'float64',
            'float64',
            'float64',
            'float64',
            'float64',
            'float64',
            'float64',
            'float64',
            'float64',
            'float64',
            'float64',
            'float64',
            'float64',
            'float64',
            'float64',
            'float64',
            'object',
            'object',
            'int64',
            'object']        
        for i in range(len(df.columns)):
            #print(str(df.dtypes[i]).replace('dtype(',''), " = ", list_formatos[i])
            if str(df.dtypes[i]).replace('dtype(','') != list_formatos[i]:                
                msg = "la columna" + df.columns[i] + "no cumple con el formato, tiene: " + df.dtypes[i] + "y debe ser: " + list_formatos[i]
                log.Error(msg)
                m.escribirLog_config("[Error] " + msg)  
                return "error"
            else:
                return "ok"            
            
    def cargarInsumoOasis(self,nom_fichero,nom_bd):
        try:
            df = pd.read_csv("ficheros/VISTAS/" + nom_fichero + ".csv",delimiter=';',header=None)
            df = df.rename(columns = {
                0:'COD_PRODUCTO',
                1:'MERCADO_DL',
                2:'MERCADO',
                3:'REGION',
                4:'CANAL',
                5:'SELECCION',
                6:'PERIODO',
                7:'COD_TAG',
                8:'DUP_PRODUCTO',
                9:'DUP_CONSISTENCIA',
                10:'DUP_EMPAQUE',
                11:'DUP_NOMBRE_FABRICANTE',
                12:'DUP_INTEGRAL_NO_INTEGRAL',
                13:'DUP_MARCA',
                14:'DUP_NIVEL_AZUCAR',
                15:'DUP_OFERTA_PROMOCIONAL',
                16:'DUP_PRESENTACION',
                17:'RANGO_MIN',
                18:'RANGO_MAX',
                19:'DUP_SABOR',
                20:'DUP_SEGMENTO',
                21:'DUP_CATEGORIA',
                22:'DUP_SUBMARCA',
                23:'DUP_SUBTIPO',
                24:'TAMANO',
                25:'TAMANO_SINPROC',
                26:'DUP_TIPO',
                27:'DUP_TIPOCARNE',
                28:'DUP_TIPO_SABOR',
                29:'DUP_VARIEDAD',
                30:'DUP_IMPORTADO',
                31:'NIVEL',
                32:'FUENTE',
                33:'VENTAS_EN_VOLUMEN_KILOS_000',
                34:'VENTAS_EN_VALOR_000000',
                35:'DIST_TIENDAS_VENDEDORAS_POND',
                36:'DIST_TIENDAS_VENDEDORAS_NUM',
                37:'PROMEDIO_VENTAS_KILOS',
                38:'COMPRAS_PROMEDIO_POR_TIENDA_KILOS',
                39:'INVENTARIO_PROMEDIO_POR_TIENDA_KILOS',
                40:'COMPRAS_TOTALES_KILOS_000',
                41:'INVENTARIO_ACTIVO_KILOS_000',
                42:'INVENTARIO_TOTAL_KILOS_000',
                43:'DIST_MANEJANTES_POND',
                44:'DIST_MANEJANTES_NUM',
                45:'DIST_AGOTADOS_NUM',
                46:'DIST_TIENDAS_COMPRADORAS_NUM',
                47:'DIST_TIENDAS_COMPRADORAS_POND',
                48:'DIST_AGOTADOS_POND',
                49:'COMPRAS_DIRECTAS_KILOS_000',
                50:'DIST_MATERIAL_POP_NUM',
                51:'DIST_MATERIAL_POP_POND',
                52:'DIST_EXHIBI_ESPECIALES_NUM',
                53:'DIST_EXHIBI_ESPECIALES_POND',
                54:'DIST_OFERTAS_NUM',
                55:'DIST_OFERTAS_POND',
                56:'DIST_ACTIVIDAD_PROMOCIONAL_NUM',
                57:'DIST_ACTIVIDAD_PROMOCIONAL_POND',
                58:'DIST_EXHIBICIONES_NUM_MAX',
                59:'DIST_EXHIBICIONES_POND_MAX',
                60:'DIST_EXHIBICIONES_POND_PROM',
                61:'DIST_NUM_AGOTADOS_PROM',
                62:'DIST_NUM_MANEJANTE_MAX',
                63:'DIST_NUM_MANEJANTE_PROM',
                64:'DIST_NUM_TIENDAS_COMPRANDO_MAX',
                65:'DIST_NUM_TIENDAS_VENDIENDO_MAX',
                66:'DIST_OFERTAS_NUM_MAX',
                67:'DIST_OFERTAS_NUM_PROM',
                68:'DIST_OFERTAS_POND_MAX',
                69:'DIST_OFERTAS_POND_PROM',
                70:'DIST_POND_AGOTADOS_PROM',
                71:'DIST_POND_MANEJANTE_MAX',
                72:'DIST_POND_MANEJANTE_PROM',
                73:'DIST_POND_TIENDAS_COMPRANDO_MAX',
                74:'DIST_POND_TIENDAS_VENDIENDO_MAX',
                75:'NOMBRE_ARCHIVO',
                76:'TAMANO_nls',
                77:'NRO_LINEA_ARCHIVO',
                78:'RANGO_SINPROC'}) 
            msg = "********** Cargar insumo Oasis ***************** \nTamaño del archivo: " + str(df.shape) + " nombre: " + nom_fichero
            log.Info(msg)
            m.escribirLog_config("[Info] " + msg)
            res = self.validar_vista(df)
            if res == 'ok':
                m.insert_sql_masivo(df,name_table = nom_bd)
            else:
                msg = "La vista no tiene la estructura esperada"
                log.Error(msg)
                res = 'error'
        except Exception as e:
            msg = "Problemas para cargar la vista: " + nom_fichero + " " + str(e)
            log.Error(msg)
            res = 'error'
        return res
    
    def insumoOasisconexion(self,nom_bd,periodoOasis,categoria=None):
        """
        metodo que se conecta a la base de datos de Oasis y genera la vista y lo conviernte a pandas
        """
        try:
            res = 'error' 
            if categoria is not None:                
                params = {"categoria" : categoria}
                try:
                    df = oasis.executeFile(self.folder + '00_vista_oasis_categoria.sql',params,devolucion=True)
                except:
                    df = None    
            else:
                params = {"periodo" : periodoOasis}
                try:
                    df = oasis.executeFile(self.folder + '00_vista_oasis.sql',params,devolucion=True)
                except:
                    df = None                             
            if df is None:
                msg = "La vista no tiene información en el periodo suministrado,verifique la conexión a Oasis"
                log.Error(msg)
                return "error"              
            else:    
                df = df.rename(columns = {
                    0:'COD_PRODUCTO',
                    1:'MERCADO_DL',
                    2:'MERCADO',
                    3:'REGION',
                    4:'CANAL',
                    5:'SELECCION',
                    6:'PERIODO',
                    7:'COD_TAG',
                    8:'DUP_PRODUCTO',
                    9:'DUP_CONSISTENCIA',
                    10:'DUP_EMPAQUE',
                    11:'DUP_NOMBRE_FABRICANTE',
                    12:'DUP_INTEGRAL_NO_INTEGRAL',
                    13:'DUP_MARCA',
                    14:'DUP_NIVEL_AZUCAR',
                    15:'DUP_OFERTA_PROMOCIONAL',
                    16:'DUP_PRESENTACION',
                    17:'RANGO_MIN',
                    18:'RANGO_MAX',
                    19:'DUP_SABOR',
                    20:'DUP_SEGMENTO',
                    21:'DUP_CATEGORIA',
                    22:'DUP_SUBMARCA',
                    23:'DUP_SUBTIPO',
                    24:'TAMANO',
                    25:'TAMANO_SINPROC',
                    26:'DUP_TIPO',
                    27:'DUP_TIPOCARNE',
                    28:'DUP_TIPO_SABOR',
                    29:'DUP_VARIEDAD',
                    30:'DUP_IMPORTADO',
                    31:'NIVEL',
                    32:'FUENTE',
                    33:'VENTAS_EN_VOLUMEN_KILOS_000',
                    34:'VENTAS_EN_VALOR_000000',
                    35:'DIST_TIENDAS_VENDEDORAS_POND',
                    36:'DIST_TIENDAS_VENDEDORAS_NUM',
                    37:'PROMEDIO_VENTAS_KILOS',
                    38:'COMPRAS_PROMEDIO_POR_TIENDA_KILOS',
                    39:'INVENTARIO_PROMEDIO_POR_TIENDA_KILOS',
                    40:'COMPRAS_TOTALES_KILOS_000',
                    41:'INVENTARIO_ACTIVO_KILOS_000',
                    42:'INVENTARIO_TOTAL_KILOS_000',
                    43:'DIST_MANEJANTES_POND',
                    44:'DIST_MANEJANTES_NUM',
                    45:'DIST_AGOTADOS_NUM',
                    46:'DIST_TIENDAS_COMPRADORAS_NUM',
                    47:'DIST_TIENDAS_COMPRADORAS_POND',
                    48:'DIST_AGOTADOS_POND',
                    49:'COMPRAS_DIRECTAS_KILOS_000',
                    50:'DIST_MATERIAL_POP_NUM',
                    51:'DIST_MATERIAL_POP_POND',
                    52:'DIST_EXHIBI_ESPECIALES_NUM',
                    53:'DIST_EXHIBI_ESPECIALES_POND',
                    54:'DIST_OFERTAS_NUM',
                    55:'DIST_OFERTAS_POND',
                    56:'DIST_ACTIVIDAD_PROMOCIONAL_NUM',
                    57:'DIST_ACTIVIDAD_PROMOCIONAL_POND',
                    58:'DIST_EXHIBICIONES_NUM_MAX',
                    59:'DIST_EXHIBICIONES_POND_MAX',
                    60:'DIST_EXHIBICIONES_POND_PROM',
                    61:'DIST_NUM_AGOTADOS_PROM',
                    62:'DIST_NUM_MANEJANTE_MAX',
                    63:'DIST_NUM_MANEJANTE_PROM',
                    64:'DIST_NUM_TIENDAS_COMPRANDO_MAX',
                    65:'DIST_NUM_TIENDAS_VENDIENDO_MAX',
                    66:'DIST_OFERTAS_NUM_MAX',
                    67:'DIST_OFERTAS_NUM_PROM',
                    68:'DIST_OFERTAS_POND_MAX',
                    69:'DIST_OFERTAS_POND_PROM',
                    70:'DIST_POND_AGOTADOS_PROM',
                    71:'DIST_POND_MANEJANTE_MAX',
                    72:'DIST_POND_MANEJANTE_PROM',
                    73:'DIST_POND_TIENDAS_COMPRANDO_MAX',
                    74:'DIST_POND_TIENDAS_VENDIENDO_MAX',
                    75:'NOMBRE_ARCHIVO',
                    76:'TAMANO_nls',
                    77:'NRO_LINEA_ARCHIVO',
                    78:'RANGO_SINPROC'}) 
                
                df['VENTAS_EN_VOLUMEN_KILOS_000'] = df['VENTAS_EN_VOLUMEN_KILOS_000'].astype(float)
                df['VENTAS_EN_VALOR_000000'] = df['VENTAS_EN_VALOR_000000'].astype(float)
                df['DIST_TIENDAS_VENDEDORAS_POND'] = df['DIST_TIENDAS_VENDEDORAS_POND'].astype(float)
                df['DIST_TIENDAS_VENDEDORAS_NUM'] = df['DIST_TIENDAS_VENDEDORAS_NUM'].astype(float)
                df['PROMEDIO_VENTAS_KILOS'] = df['PROMEDIO_VENTAS_KILOS'].astype(float)
                df['COMPRAS_PROMEDIO_POR_TIENDA_KILOS'] = df['COMPRAS_PROMEDIO_POR_TIENDA_KILOS'].astype(float)
                df['INVENTARIO_PROMEDIO_POR_TIENDA_KILOS'] = df['INVENTARIO_PROMEDIO_POR_TIENDA_KILOS'].astype(float)
                df['COMPRAS_TOTALES_KILOS_000'] = df['COMPRAS_TOTALES_KILOS_000'].astype(float)
                df['INVENTARIO_ACTIVO_KILOS_000'] = df['INVENTARIO_ACTIVO_KILOS_000'].astype(float)
                df['INVENTARIO_TOTAL_KILOS_000'] = df['INVENTARIO_TOTAL_KILOS_000'].astype(float)
                df['DIST_MANEJANTES_POND'] = df['DIST_MANEJANTES_POND'].astype(float)
                df['DIST_MANEJANTES_NUM'] = df['DIST_MANEJANTES_NUM'].astype(float)
                df['DIST_AGOTADOS_NUM'] = df['DIST_AGOTADOS_NUM'].astype(float)
                df['DIST_TIENDAS_COMPRADORAS_NUM'] = df['DIST_TIENDAS_COMPRADORAS_NUM'].astype(float)
                df['DIST_TIENDAS_COMPRADORAS_POND'] = df['DIST_TIENDAS_COMPRADORAS_POND'].astype(float)
                df['DIST_AGOTADOS_POND'] = df['DIST_AGOTADOS_POND'].astype(float)
                df['COMPRAS_DIRECTAS_KILOS_000'] = df['COMPRAS_DIRECTAS_KILOS_000'].astype(float)
                df['DIST_MATERIAL_POP_NUM'] = df['DIST_MATERIAL_POP_NUM'].astype(float)
                df['DIST_MATERIAL_POP_POND'] = df['DIST_MATERIAL_POP_POND'].astype(float)
                df['DIST_EXHIBI_ESPECIALES_NUM'] = df['DIST_EXHIBI_ESPECIALES_NUM'].astype(float)
                df['DIST_EXHIBI_ESPECIALES_POND'] = df['DIST_EXHIBI_ESPECIALES_POND'].astype(float)
                df['DIST_OFERTAS_NUM'] = df['DIST_OFERTAS_NUM'].astype(float)
                df['DIST_OFERTAS_POND'] = df['DIST_OFERTAS_POND'].astype(float)
                df['DIST_ACTIVIDAD_PROMOCIONAL_NUM'] = df['DIST_ACTIVIDAD_PROMOCIONAL_NUM'].astype(float)
                df['DIST_ACTIVIDAD_PROMOCIONAL_POND'] = df['DIST_ACTIVIDAD_PROMOCIONAL_POND'].astype(float)
                df['DIST_EXHIBICIONES_NUM_MAX'] = df['DIST_EXHIBICIONES_NUM_MAX'].astype(float)
                df['DIST_EXHIBICIONES_POND_MAX'] = df['DIST_EXHIBICIONES_POND_MAX'].astype(float)
                df['DIST_EXHIBICIONES_POND_PROM'] = df['DIST_EXHIBICIONES_POND_PROM'].astype(float)
                df['DIST_NUM_AGOTADOS_PROM'] = df['DIST_NUM_AGOTADOS_PROM'].astype(float)
                df['DIST_NUM_MANEJANTE_MAX'] = df['DIST_NUM_MANEJANTE_MAX'].astype(float)
                df['DIST_NUM_MANEJANTE_PROM'] = df['DIST_NUM_MANEJANTE_PROM'].astype(float)
                df['DIST_NUM_TIENDAS_COMPRANDO_MAX'] = df['DIST_NUM_TIENDAS_COMPRANDO_MAX'].astype(float)
                df['DIST_NUM_TIENDAS_VENDIENDO_MAX'] = df['DIST_NUM_TIENDAS_VENDIENDO_MAX'].astype(float)
                df['DIST_OFERTAS_NUM_MAX'] = df['DIST_OFERTAS_NUM_MAX'].astype(float)
                df['DIST_OFERTAS_NUM_PROM'] = df['DIST_OFERTAS_NUM_PROM'].astype(float)
                df['DIST_OFERTAS_POND_MAX'] = df['DIST_OFERTAS_POND_MAX'].astype(float)
                df['DIST_OFERTAS_POND_PROM'] = df['DIST_OFERTAS_POND_PROM'].astype(float)
                df['DIST_POND_AGOTADOS_PROM'] = df['DIST_POND_AGOTADOS_PROM'].astype(float)
                df['DIST_POND_MANEJANTE_MAX'] = df['DIST_POND_MANEJANTE_MAX'].astype(float)
                df['DIST_POND_MANEJANTE_PROM'] = df['DIST_POND_MANEJANTE_PROM'].astype(float)
                df['DIST_POND_TIENDAS_COMPRANDO_MAX'] = df['DIST_POND_TIENDAS_COMPRANDO_MAX'].astype(float)
                df['DIST_POND_TIENDAS_VENDIENDO_MAX'] = df['DIST_POND_TIENDAS_VENDIENDO_MAX'].astype(float)
    
                msg = "********** Cargar insumo Oasis ***************** \nTamaño del archivo: " + str(df.shape) + " periodo: " + periodoOasis
                log.Info(msg)
                m.escribirLog_config("[Info] " + msg)
                res = self.validar_vista(df)
                if res == 'ok':
                    m.insert_sql_masivo(df,name_table = nom_bd)
                else:
                    msg = "La vista no tiene la estructura esperada"
                    log.Error(msg)                       
        except Exception as e:
            msg = "Problemas para cargar la vista desde oasis" + str(e)
            log.Error(msg)
        return res        
        
    def ingresarReglas(self,va):
        """
        Método que recibe la variable adicional para contruir un diccionario con las reglas sin commillas
        que están matriculadas en la tabla conf_reglas
        """
        res = m.executeFile(self.folder + '02_subrutina_listar_reglas.sql',devolucion=True)
        vec_regla = []
        for i in range(len(res)):
            if res[0][i] == va:
                vec_regla.append(res[2][i])                    
        reglas = " ".join(vec_regla)
        params = {
            "REGLAS" : reglas
        }
        return params    
    
    def reglas_varadinegocios(self): 
        """
        Ingresar reglas (se debe ejecutar luego de temp_02_var_adi_negocios) 
        nota: cuando se ingrese una nueva variable adicional se debe crear tanto
        la rutnina sql como agregarlo en la tabla ma_variable_adicional
        """
        msg = "********** Agregar Variables Adicionales ******"
        log.Info(msg)
        m.escribirLog_config("[Info] " + msg) 
        va = "SELECT variable_adicional FROM PUBLIC.ma_variable_adicional" #WHERE variable_adicional = 'pastas_linea'
        lista_reglas = m.execute(va,param=True) 
        
        i = 0
        while i < len(lista_reglas):
            try:
                res = m.executeFile(self.folder + '02_subrutina_va_' + lista_reglas[i][0] + '.sql', self.ingresarReglas(lista_reglas[i][0]),debug=False)
                if res == 'error':
                    msg = "Proceso suspendido problemas con " + '02_subrutina_va_' + lista_reglas[i][0] + '.sql' + " regla: " + lista_reglas[i][0]
                    log.Error(msg)
                    m.escribirLog_config("[Error] " + msg) 
                    return res
                    break
                i += 1 
            except Exception as e:
                msg = "Problemas con la rutina: " + '02_subrutina_va_' + lista_reglas[i][0] + '.sql' + " regla: " + lista_reglas[i][0] + " " + str(e)
                log.Error(msg)
                m.escribirLog_config("[Error] " + msg)
                return 'error'
                break
        res = "ok"
        return res
    
    def actualizarvariablesadicionales(self):
        """
        Este metodo toma las las tablas de "temp_02_va" que se crearon en el metodo reglas_varadinegocios, sus registros 
        los inserta en las tablas con nomenclatura "va" limpiando antes la tabla,
        nota: la tabla "conf_reglas" en el campo "variable_adicional" tambien controla las "temp_va" y las tablas "va"
        """        
        va = "SELECT variable_adicional FROM PUBLIC.ma_variable_adicional" #WHERE variable_adicional = 'pastas_linea'
        res_var = m.execute(va,param=True) 
        i = 0
        while i < len(res_var):            
            params = {
                    "tabla_temp"    : 'PUBLIC.temp_02_va_' + res_var[i][0],
                    "tabla_va"      : 'PUBLIC.va_' + res_var[i][0],
                    "tabla_com"     : 'PUBLIC.va_' + res_var[i][0] + '_'
                    }
            res_act =  m.executeFile(self.folder + '02_subrutina_actualizar_va.sql',params)
            if res_act == "error":
                res = res_act
                msg = "Problemas con 02_subrutina_actualizar_va"
                log.Debug(msg)
                m.escribirLog_config("[Debug] " + msg)
                break
            else:
                res = "ok"
                i += 1 
        return res     
    
    def actualizarcodificaciones(self,debug=True): 
        """
        actualizar codificaciones se debe ejecutar luego de temp 04
        NOTA: al momento de insertar las nuevas variables garantizar que se inserte en orden alfabetico de la variable (los componentes que componen la variable)
        """
        msg = "********** Actualizar Codificaciones **********"
        log.Info(msg)
        m.escribirLog_config("[Info] " + msg)
        tipocodi = "select * from PUBLIC.ma_tipo_codificacion where estado_retail = 1" #and tipo_codificacion = 'TAMANO_nls'
        res_macodi = m.execute(tipocodi,param=True)          
        #c = 0
        for c in range(len(res_macodi)):
            tablatemp = 'temp_05_act_' + res_macodi[c][1].lower()            
            params = {
                    "tablatemp"             : tablatemp,
                    "tipo_codificacion"     : res_macodi[c][1],
                    "cod_codificacion"      : 'COD_' + res_macodi[c][1],
                    "inicial_codificacion"  : res_macodi[c][2]                              
                }
            m.executeFile(self.folder + '05_subrutina_actualizar_codificacion.sql',params,debug=False)  
            #print(res_macodi[c][1]," : ",val)
            #ARMAR EL INSERT
            tabla_temp = "select * from PUBLIC." + tablatemp 
            temp_res = m.execute(tabla_temp,param=True)
            if len(temp_res) != 0:
                i= 0
                while i < len(temp_res):    
                    params = {
                            "id_tipo_codificacion"  : res_macodi[c][0],
                            "descripcion"           : temp_res[i][1],
                            "codificacion"          : temp_res[i][0],
                            "tablatemp"             : tablatemp                            
                        }            
                    res_codi = m.executeFile(self.folder + '05_subrutina_insert_va_codificacion.sql',params)
                    if res_codi == "error":
                        res = res_codi
                        msg = "Problemas con 08_subrutina_actualizar_codificacion"
                        log.Debug(msg)
                        m.escribirLog_config("[Debug] " + msg)
                        break
                    else:
                        i += 1                                    
            else:
                res = "ok"
                if debug:
                    msg = "la tabla no tiene data: " + tablatemp
                    log.Debug(msg) #si debug True ver las tablas temp sin data 
                    m.escribirLog_config("[Debug] " + msg)
            m.executeFile(self.folder + '05_subrutina_drop_act.sql',params={"tablatemp" : tablatemp}) 
            msg = "Tabla eliminada: " + tablatemp
            log.Info(msg)
            m.escribirLog_config("[Info]" + msg)                       
        return res
    
    def ficheroscodificaciones(self):
        msg = "********** Ficheros Codificaciones **********"
        log.Info(msg)
        m.escribirLog_config("[Info] " + msg)
        va_codificacion = "SELECT tipo_codificacion FROM PUBLIC.ma_tipo_codificacion"
        res_codi = m.execute(va_codificacion,param=True)  
        if len(res_codi) != 0:
            i= 0
            while i < len(res_codi):
                params = {
                            "tipo_codificacion"  : res_codi[i][0]                         
                        }
                try:
                    res_query = m.executeFile(self.folder + '07_subrutina_guardar_codificaciones.sql',params,devolucion=True,debug=False)                                     
                    res_query = res_query.rename(columns = {0:res_codi[i][0],1:'COD_' + res_codi[i][0]})                   
                    res_query.to_csv('ficheros/codificaciones/' + res_codi[i][0] + '.csv', header=True, index=False) #pendiente separar por ","
                except Exception as e:
                    msg = "Proceso suspendido problemas con 07_subrutina_guardar_codificaciones " + str(e)
                    log.Error(msg)
                    m.escribirLog_config("[Error] " + msg)
                    break
                i += 1    
                res = "ok"
        else:
            res = "error"
        return res     
    
    def guardartransaccionalventas(self):
        msg = "********** Guardar transaccional ventas **********"
        log.Info(msg)
        m.escribirLog_config("[Info] " + msg)
        try:
            res_query = m.executeFile(self.folder + '08_subrutina_guardar_transaccional_ventas.sql',devolucion=True,debug=False)                      
            if len(res_query) != 0:
                res_query.to_csv('ficheros/codificaciones/transaccional_ventas.csv', header=True, index=False)
                res = "ok"
            else:
                res = "noData"
        except Exception as e:
            msg = "Proceso suspendido problemas con 08_rutina_guardar_transaccional_ventas " + str(e)
            log.Error(msg)
            m.escribirLog_config("[Error] " + msg)
            res = "error"        
        return res    
     
    def acumularVentas(self):
        msg = "********** Acumular transaccional ventas **********"
        log.Info(msg)
        m.escribirLog_config("[Info] " + msg)
        try:
            res_query = m.executeFile(self.folder + '08_subrutina_limpiar_ventas_historia.sql',devolucion=True,debug=False)
            res_query = m.executeFile(self.folder + '08_subrutina_acumular_ventas.sql',devolucion=True,debug=False)
            res = res_query                     
        except Exception as e:
            msg = "Proceso suspendido problemas con 08_subrutina_acumular_ventas " + str(e)
            log.Error(msg)
            m.escribirLog_config("[Error] " + msg)
            res = "error"        
        return res
               
    #Item Volumen
    def itemvolumen(self,item_volumen):
        if item_volumen:
            msg = "********** Item Volumen ... *****************"
            log.Info(msg)
            m.escribirLog_config("[Info] " + msg)
            ruta = 'C:/Users/CAP04/Desktop/Proyecto/armadillo/ficheros/'
            nombre = 'Nutresa Item Volumen Jul - Sep 2020.xlsx'        
            m_peso = item.obtain_additional_var_from_item_volume(ruta,nombre)
            m.insert_sql_masivo(m_peso,name_table = 'ma_peso_prueba')
            res = m.executeFile(self.folder + '00_item_volumen.sql')
            if res == "error":
                return res 
            else:
                res = "ok"
                msg = "********** Item Volumen Generado *****************"
                log.Info(msg)
                m.escribirLog_config("[Info] " + msg)
        return "ok"   
    
    def main(self,drop=True,mes='jun_20', periodoOasis='2020-09-01',categoria=None,item_volumen=False,acumVentas=False):  
        #limpiar logs y almacenar en historicos logs
        m.executeFile(self.folder + '00_limpiar_logs.sql')
        msg = "********** Ejecucion iniciada *******************"
        log.Info(msg)
        m.escribirLog_config("[Info] " + msg)        
        
        if categoria is not None:
            res_oasis = self.insumoOasisconexion('nielsen_retail_' + categoria.replace(" ","_").lower() ,periodoOasis,categoria=categoria)
            param = {"mes"   : 'nielsen_retail_' + categoria.replace(" ","_").lower()}
        else:
            #res_oasis = self.cargarInsumoOasis('VISTA_RETAIL_NIELSEN_'+ mes,'nielsen_retail_' + mes) #cuando sea un archivo plano
            res_oasis = self.insumoOasisconexion('nielsen_retail_' + mes,periodoOasis)
            param = {"mes"   : 'nielsen_retail_' + mes}
        #res_oasis = "ok"
        if res_oasis != "ok":
            msg = "Proceso suspendido problemas con insumo Oasis"
            log.Error(msg)
            m.escribirLog_config("[Error] " + msg)
            return "error"              
        else:
            msg = "********** Rutinas core ... *****************"
            log.Info(msg)    
            m.escribirLog_config("[Info] " + msg)
            lista_rutinas = (
                'temporal_origen_va.sql', #solo aplica para la primera ejecución en producción
                '08_subrutina_eliminar_tablastemp.sql', # esta rutina se ejecuta tanto en el inicio como en en final del ciclo
                '00_item_volumen.sql', #no lo ejecuta , solo lo valida
                '00_rutina_select_mes_cat.sql',
                '01_rutina_prep_datos.sql',
                '01_subrutina_productos_nuevos.sql',
                '02_rutina_var_adi_negocios.sql',
                '03_subrutina_h_productos.sql',
                '03_rutina_var_adi_rangos.sql',
                '04_subrutina_rango_precio.sql',
                '04_subrutina_rango_precio_individual.sql',
                '04_subrutina_rango_tamano.sql',
                '04_subrutina_rango_tamano_individual.sql',
                '04_rutina_rangos.sql',
                '05_rutina_va_codificacion.sql',
                '05_subrutina_va_codificacion2.sql',
                '05_subrutina_va_codificacion3.sql',
                '05_subrutina_va_codificacion4.sql',
                '05_subrutina_va_codificacion5.sql',
                '05_subrutina_va_codificacion6.sql',
                '05_subrutina_va_codificacion7.sql',
                '06_rutina_productos.sql',                
                '07_rutina_atributos_mercado.sql',
                '06_subrutina_maestra_productos.sql',
                '08_rutina_transaccional_ventas.sql'
                #'08_subrutina_eliminar_tablastemp.sql'           
                )                        
            i = 0
            while i < len(lista_rutinas):    
                try:
                    if lista_rutinas[i] != '10_rutina_eliminar_tablastemp.sql':
                        msg = "Ejecutando nielsen_retail_" + mes
                        log.Info(msg)
                        m.escribirLog_config("[Info] " + msg) 
                        res = m.executeFile(self.folder + lista_rutinas[i], param)   
                        if lista_rutinas[i] == '00_item_volumen':
                            res_item = self.itemvolumen(item_volumen)
                            if res_item != "ok":
                                msg = "Proceso suspendido problemas con item volumen [sql]" + lista_rutinas[i]
                                log.Error(msg)
                                m.escribirLog_config("[Error] " + msg)
                                break                                                       
                        if lista_rutinas[i] == '02_rutina_var_adi_negocios.sql':
                            res_reg = self.reglas_varadinegocios()                            
                            if res_reg != "ok":
                                msg = "Proceso suspendido problemas con las subrutinas de " + lista_rutinas[i]
                                log.Error(msg)              
                                m.escribirLog_config("[Error] " + msg)                                        
                                break
                            res_act_reg = self.actualizarvariablesadicionales()
                            if res_act_reg != "ok":
                                msg = "Proceso suspendido al actualizar en la subrutina de " + lista_rutinas[i]
                                log.Error(msg)
                                m.escribirLog_config("[Error] " + msg)
                                break
                        if lista_rutinas[i] == '04_rutina_rangos.sql':
                            res_codi = self.actualizarcodificaciones()
                            if res_codi != "ok":
                                msg = "Problemas con la subrutina de " + lista_rutinas[i]
                                log.Error(msg)
                                m.escribirLog_config("[Error] " + msg)
                                break 
                            else:
                                res_codi_guar = self.ficheroscodificaciones()
                                if res_codi_guar != "ok":
                                    msg = "Proceso suspendido problemas con las subrutinas de " + lista_rutinas[i] + "ficheroscodificaciones"
                                    log.Error(msg)
                                    m.escribirLog_config("[Error] " + msg)
                                    break 
                        if lista_rutinas[i] == '08_rutina_transaccional_ventas.sql':        
                            res_ventas_guar = self.guardartransaccionalventas()
                            if res_ventas_guar != "ok":
                                msg = "Proceso suspendido problemas con las subrutinas de " + lista_rutinas[i] + "guardartransaccionalventas"
                                log.Error(msg)
                                m.escribirLog_config("[Error] " + msg)
                                break
                            elif res_ventas_guar == "noData":
                                msg = "Rutina " + lista_rutinas[i] + "ha generado el archivo sin ventas [guardartransaccionalventas]"
                                log.Debug(msg)
                                m.escribirLog_config("[Debug] " + msg)
                        if res == 'error':
                            msg = "Proceso suspendido problemas con " + lista_rutinas[i]
                            log.Error(msg)
                            m.escribirLog_config("[Error] " + msg)
                            break                        
                        if lista_rutinas[i] == '08_rutina_transaccional_ventas.sql' and acumVentas:
                            res_vent = self.acumularVentas()
                            if res_vent != "ok":
                                msg = "Problemas con la subrutina de " + lista_rutinas[i] + "[acumularVentas]"
                                log.Error(msg)
                                m.escribirLog_config("[Error] " + msg)
                                break                                 
                    elif lista_rutinas[i] == '10_rutina_eliminar_tablastemp.sql':
                        if drop:
                            m.executeFile(self.folder + lista_rutinas[i])
                            #print("Eliminar: ",lista_rutinas[i])
                    i += 1        
                except Exception as e:
                    msg = "Problemas con " + lista_rutinas[i] + " " + str(e)
                    log.Error(msg)
                    m.escribirLog_config("[Error] " + msg)
                    break        
        msg = "********** Fin Ejecución **************"
        log.Info(msg)
        m.escribirLog_config("[Info] " + msg)
                                         
#instancias         
log = logger()
item = EnrichmentOps()

programa = ProcesoRatail()
m = Sql(programa.get_config('postgresql_retail'),log)
oasis = Sql(programa.get_config('mysql_oasis'),log)

"""   
categoria=None
periodoOasis='2020-09-01'
mes='jun_20'
#res_oasis = programa.insumoOasisconexion('nielsen_retail_' + mes,periodoOasis)

folder = 'sql/rutinas_retail/'
params = {"periodo" : periodoOasis}
df = oasis.executeFile(folder + '00_vista_oasis.sql',params,devolucion=True)
"""
    
"""
#posgresql
#con devolucion
param = {'inicial' : 'TB'}  
res = m.executeFile(folder + 'borrar.sql',params=param,devolucion=True)
print(res)
#sin devolucion
param = {'inicial' : 'TB'}  
m.executeFile(folder + 'borrar2.sql',params=param)


#mysqlLocalhost   
res = prueba.executeFile(folder + 'prueba.sql',devolucion=True)
print(res)

#mysqloasis 
param = {'periodo' : '2020-09-01'}  
res = oasis.executeFile(folder + '00_vista_oasis.sql', params=param, devolucion=True)
print(res)

"""




    
    