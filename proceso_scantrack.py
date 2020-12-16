"""
@author: leonardo.patino
"""
import json
import pandas as pd

from clase.logger import logger
from clase.sql import Sql

class ProcesoScantrack:    
    def __init__(self): 
        self.folder = 'sql/rutinas_scantrack/' 
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
            'float64',
            'object',
            'object',
            'int64',
            'int64',
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
            'object',
            'object',
            'int64',
            'float64',
            'float64',
            'float64',
            'float64',
            'int64',
            'int64']
        
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
                1:'NOMBRE_MERCADO ',
                2:'MERCADO_DL',
                3:'FUENTE',
                4:'DUP_TIPO_SABOR',
                5:'DUP_SUBTIPO',
                6:'DUP_PRODUCTO',
                7:'DUP_INTEGRAL_NO_INTEGRAL',
                8:'DUP_OFERTA_PROMOCIONAL',
                9:'DUP_TIPOCARNE',
                10:'NOMBRE_ARCHIVO',
                11:'COD_TAG',
                12:'RANGO_MIN',
                13:'RANGO_MAX',
                14:'RANGO_SINPROC',
                15:'DUP_CONSISTENCIA',
                16:'COD_EAN',
                17:'DUP_CATEGORIA',
                18:'DUP_EMPAQUE',
                19:'ANO',
                20:'MES',
                21:'DUP_NOMBRE_FABRICANTE',
                22:'DUP_MARCA',
                23:'DUP_SEGMENTO',
                24:'DUP_VARIEDAD',
                25:'DUP_PRESENTACION',
                26:'DUP_SABOR',
                27:'DUP_SUBMARCA',
                28:'DUP_TIPO',
                29:'DUP_NIVEL_AZUCAR',
                30:'REGION_NLS',
                31:'CANAL_NLS',
                32:'DESCRIPCION_FUENTE',
                33:'TAMANO_SINPROC',
                34:'TAMANO',
                35:'VENTAS_VALOR_nls',
                36:'VENTAS_VOLUMEN_nls',
                37:'DIST_TIENDAS_VENDEDORAS_POND',
                38:'DIST_TIENDAS_VENDEDORAS_NUM',
                39:'GRUPO',
                40:'ANIO' }) 
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
                params = periodoOasis
                try:
                    df = oasis.executeFile(self.folder + '00_vista_oasis.sql',params,devolucion=True)
                except:
                    df = None
            if df is None:
                msg = "La vista no tiene información en el periodo suministrado, verifique la conexión a Oasis"
                log.Error(msg)
            else:
                df = df.rename(columns = {
                    0:'COD_PRODUCTO',
                    1:'NOMBRE_MERCADO ',
                    2:'MERCADO_DL',
                    3:'FUENTE',
                    4:'DUP_TIPO_SABOR',
                    5:'DUP_SUBTIPO',
                    6:'DUP_PRODUCTO',
                    7:'DUP_INTEGRAL_NO_INTEGRAL',
                    8:'DUP_OFERTA_PROMOCIONAL',
                    9:'DUP_TIPOCARNE',
                    10:'NOMBRE_ARCHIVO',
                    11:'COD_TAG',
                    12:'RANGO_MIN',
                    13:'RANGO_MAX',
                    14:'RANGO_SINPROC',
                    15:'DUP_CONSISTENCIA',
                    16:'COD_EAN',
                    17:'DUP_CATEGORIA',
                    18:'DUP_EMPAQUE',
                    19:'ANO',
                    20:'MES',
                    21:'DUP_NOMBRE_FABRICANTE',
                    22:'DUP_MARCA',
                    23:'DUP_SEGMENTO',
                    24:'DUP_VARIEDAD',
                    25:'DUP_PRESENTACION',
                    26:'DUP_SABOR',
                    27:'DUP_SUBMARCA',
                    28:'DUP_TIPO',
                    29:'DUP_NIVEL_AZUCAR',
                    30:'REGION_NLS',
                    31:'CANAL_NLS',
                    32:'DESCRIPCION_FUENTE',
                    33:'TAMANO_SINPROC',
                    34:'TAMANO',
                    35:'VENTAS_VALOR_nls',
                    36:'VENTAS_VOLUMEN_nls',
                    37:'DIST_TIENDAS_VENDEDORAS_POND',
                    38:'DIST_TIENDAS_VENDEDORAS_NUM',
                    39:'GRUPO',
                    40:'ANIO' }) 
                
                df['VENTAS_VALOR_nls'] = df['VENTAS_VALOR_nls'].astype(float)
                df['VENTAS_VOLUMEN_nls'] = df['VENTAS_VOLUMEN_nls'].astype(float)
                df['DIST_TIENDAS_VENDEDORAS_POND'] = df['DIST_TIENDAS_VENDEDORAS_POND'].astype(float)
                df['DIST_TIENDAS_VENDEDORAS_NUM'] = df['DIST_TIENDAS_VENDEDORAS_NUM'].astype(float)
                
                msg = "********** Cargar insumo Oasis *****************" 
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
        tipocodi = "select * from PUBLIC.ma_tipo_codificacion where estado_scantrack = 1" #and tipo_codificacion = 'TAMANO_nls'
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
   
    def main(self,drop=True,mes='jun_20',periodoOasis={'ano' : '20', 'mes' : '5'},categoria=None,acumVentas=False):
        #limpiar logs y almacenar en historicos logs
        m.executeFile(self.folder + '00_limpiar_logs.sql')
        msg = "********** Ejecución iniciada *******************"
        log.Info(msg)
        m.escribirLog_config("[Info] " + msg)        
        if categoria is not None:
            #res_oasis = self.cargarInsumoOasis('VISTA_SCANTRACK_NIELSEN_'+ mes,'nielsen_scantrack_' + mes)
            res_oasis = self.insumoOasisconexion('nielsen_scantrack_' + categoria.replace(" ","_").lower(),periodoOasis,categoria=categoria)
            param = {"mes"   : 'nielsen_scantrack_' + categoria.replace(" ","_").lower()}
        else:
            res_oasis = self.insumoOasisconexion('nielsen_scantrack_' + mes,periodoOasis)
            param = {"mes"   : 'nielsen_scantrack_' + mes}
        #res_oasis = "ok"
        if res_oasis != "ok":
            msg = "Proceso suspendido problemas con insumo Oasis"
            log.Error(msg)
            m.escribirLog_config("[Error] " + msg)
        else:
            msg = "********** Rutinas core ... *****************"
            log.Info(msg)    
            m.escribirLog_config("[Info] " + msg)
            lista_rutinas = (
                'temporal_origen_va.sql', #solo aplica para la primera ejecución en producción
                '08_subrutina_eliminar_tablastemp.sql', # esta rutina se ejecuta tanto en el inicio como en en final del ciclo              
                '00_rutina_select_mes_cat.sql',
                '01_rutina_prep_datos.sql',
                '01_subrutina_productos_nuevos.sql',
                '02_rutina_var_adi_negocios.sql',
                '03_rutina_var_adi_rangos.sql',
                '05_rutina_va_codificacion.sql',
                '05_subrutina_va_codificacion2.sql',
                '05_subrutina_va_codificacion3.sql',
                '05_subrutina_va_codificacion4.sql',
                '05_subrutina_va_codificacion5.sql',
                '05_subrutina_va_codificacion6.sql',
                '05_subrutina_va_codificacion7.sql',
                '06_subrutina_productos.sql',   
                '06_subrutina_maestra_productos.sql',
                '07_rutina_atributos_mercado.sql',                
                '08_rutina_transaccional_ventas.sql',
                '08_subrutina_eliminar_tablastemp.sql'           
                )            

            i = 0
            while i < len(lista_rutinas):    
                try:
                    if lista_rutinas[i] != '10_rutina_eliminar_tablastemp.sql':
                        msg = "Ejecutando nielsen_scantrack_" + mes
                        log.Info(msg)
                        m.escribirLog_config("[Info] " + msg) 
                        res = m.executeFile(self.folder + lista_rutinas[i], param)                                                     
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

programa = ProcesoScantrack()
m = Sql(programa.get_config('postgresql_scantrack'),log)
oasis = Sql(programa.get_config('mysql_oasis'),log)


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
param = {'ano' : '2020', 'grupo' : '5'}  
res = oasis.executeFile(folder + '00_vista_oasis.sql', params=param, devolucion=True)
print(res)


programa.insumoOasisconexion('nielsen_scantrack_' + mes,periodoOasis)
"""

        
