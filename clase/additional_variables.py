import pandas as pd
import numpy as np
import re
import pdb
#import reporting
from lxml import etree
#from exceptions import XMLExtractException, IVExtractException

class EnrichmentOps():
  """Clase encargada de obtener variables adicionales de multiples insumos y aplicar reglas para 
  almacenar datos en base de datos"""
  __REGULAR_EXPRESION_SIZE = r'((?:\d+(?:\.\d+)?)(?=\s*(?=G(?!RAN)|KG|LT)))'
  __REGULAR_EXPRESION_KG = r'(\d+(?:\.\d+)?)(?=\s*(?=KG))'
  __REGULAR_EXPRESION_LT = r'(\d+(?:\.\d+)?)(?=\s*(?=LT))'
  __REGULAR_EXPRESION_UXE  = r'(?:(?:\s|\w|\()X)(?:\s)?(\d+)(?:(?=\s|]|\)|E|\s\d+))'
  __REGULAR_EXPRESION_RANGOS = r'((?:\d+(?:\.\d+)?))'
  __REGULAR_EXPRESION_RANGE_IN_DESC = r'(\d+(?:\.\d+)?) A (\d+(?:\.\d+)?)'
  def __init__(self):
    pass

  def __first_filter(self, row, cols_cal, cols_original):
    #verificar que el tamaño calculado sea igual al derivado
    row['resultado'] = 0
    row['estado'] = 'sin clasificar'
    match_obj = re.findall(self.__REGULAR_EXPRESION_LT, row['DESC'])
    if len(match_obj) > 0:
      for col in cols_cal:
        if row[col]== -99 or col == cols_cal[-1]:
          row[col] = float(match_obj[0]) * 950 #Litros a gramos aproximados(de manera muy general)
          break
    #tiene mayor importancia el peso se deja despues de litros por este motivo
    match_obj = re.findall(self.__REGULAR_EXPRESION_KG, row['DESC'])
    if len(match_obj) > 0:
      for col in cols_cal:
        if row[col]== -99 or col == cols_cal[-1]:
          row[col] = float(match_obj[0]) * 1000 #kilos a gramos
          break


    if row['0_tamano'] == row['0_tamano_original']:
      row['resultado'] = row['0_tamano']
      row['estado'] = 'OK'
    elif float(row['0_tamano']) >= float(row['0_tamano_original']) and float(row['0_tamano']) <= float(row['1_tamano_original']):
      row['resultado'] = row['0_tamano']
      row['estado'] = 'OK'
    else:
      for col in cols_cal:
        if float(row[col]) == float(row['0_tamano_original']) and row['0_tamano_original'] != -99:
          row['resultado'] = row[col]
          row['estado'] = 'Revisar'
          break
        elif float(row[col]) >= float(row['0_tamano_original']) and float(row[col]) <= float(row['1_tamano_original']):
          row['resultado'] = row[col]
          row['estado'] = 'Revisar'
          break

    if row['resultado'] == -99:
      row['resultado'] = 0
      row['estado'] = 'sin clasificar'
    return row

  def __second_filter(self, row, cols_cal, cols_original):
    match_obj = re.findall(self.__REGULAR_EXPRESION_RANGE_IN_DESC, row['DESC'])
    if row['0_tamano_original'] == -99:
      row['resultado'] = row['0_tamano']
      row['estado'] = 'Asignar tamano descripcion'
    elif row['0_tamano'] == -99:
      row['resultado'] = 0
      row['estado'] = 'No se puede asignar tamano'
    elif "O MAS" in row['TAMANOS'] or "MAS DE" in row['TAMANOS']:
      for col in cols_cal:
        if float(row[col]) >= float(row['0_tamano_original']):
          row['resultado'] = row[col]
          row['estado'] = 'rango sin limite superior'
          break
    elif len(match_obj) == 1:
      tmp_match = match_obj[0][1]
      if len(match_obj[0][1]) == 5 and "." in match_obj[0][1]:
        tmp_match = tmp_match.replace('.', '')
      if float(row['0_tamano_original']) >= float(match_obj[0][0]) and \
        float(row['0_tamano_original']) <= float(tmp_match):
        row['resultado'] = row['0_tamano_original']
        row['estado'] = 'tamano reportado coincide con el rango de descripcion'

    return row

  def __third_filter(self, row, cols_cal, cols_uxe):
    for colsize in cols_cal:
      found = False
      for col in cols_uxe:
        if row[col] != -99:
          cal_size = int(float(row[colsize]) / int(row[col]))
          if abs(cal_size - float(row['0_tamano_original'])) <= 2:
            row['resultado'] = cal_size
            row['estado'] = 'tamano asignado dividiendo tamano entre unidades por empaque'
            found=True
            break
          elif cal_size >= float(row['0_tamano_original']) and cal_size <= float(row['1_tamano_original']):
            row['resultado'] = cal_size
            row['estado'] = 'tamano asignado porque el tamano calculado se encuentra en el rango reportado'
            found=True
            break
      if found:
        break
    #casos de decimales  
    for colsize in cols_cal:
      if abs(float(row[colsize]) - float(row['0_tamano_original'])) < 0.9:
        row['resultado'] = row[colsize]
        row['estado'] = 'asignado por ajuste decimal'
        break

    #casos de miles
    for colsize in cols_cal:
      if type(row[colsize]) is str:
        if len(row[colsize]) == 5 and "." in row[colsize]:
          row[colsize] = row[colsize].replace('.', '')
      if row[colsize] == row['0_tamano_original']:
        row['resultado'] = row[colsize]
        row['estado'] = 'asignando modificando unidad de miles del insumo'
        break
      elif float(row[colsize]) >= float(row['0_tamano_original']) and float(row[colsize]) <= float(row['1_tamano_original']):
        row['resultado'] = row[colsize]
        row['estado'] = 'modificado unidad de miles y se ajusta al rango'
        break

    return row

  def rename_used_sheet_columns(self, sheet_name, df):
    """función que renombra las columnas del Item Volumen de acuerdo a un condición"""
    sheet_name = sheet_name.upper()
    if sheet_name in ['GALLETAS', 'PASTAS', 'CAFE MOLIDO', 'CAFE SOLUBLE', 'MODIFICADORES LECHE',
    'CHOCOLATE MESA']:
      pass
    elif sheet_name == 'CARNICOS CONSERVA':
      df.rename({'PESO':'TAMANOS'}, axis='columns', inplace=True)
    elif sheet_name == 'VEGETALES CONSERVA':
      df.rename({'CONTENIDO': 'TAMANOS'},axis='columns', inplace=True)
    elif sheet_name in ['CHOCOLATINAS', 'MANI']:
      df.rename({'TAMANO': 'TAMANOS'},axis='columns', inplace=True)
    elif sheet_name in ['CARNES FRIAS']:
      try:
        df.loc[df['TAMANO'].isin(['OTROS']), 'TAMANO'] = df.loc[df['TAMANO'] in ['OTROS'], 'RANGOS']
      except Exception as e:
        pass
      df.rename({'TAMANO': 'TAMANOS'}, axis='columns',inplace=True)
    elif sheet_name in ['CEREALES BARRA']:
      df.rename({'TAMANOS':'TAMANOS_OR'},axis='columns', inplace=True)
      df.rename({'PESO TOTAL': 'TAMANOS', 'DESCRIPCION':'DESC'},axis='columns', inplace=True)
    elif sheet_name == 'HELADOS':
      try:
        df.loc[df['PESO'].isin(['OTROS']), 'PESO'] = df.loc[df['PESO'] in ['OTROS'], 'TAMANOS']
      except Exception as e:
        pass
      df.rename({'TAMANO': 'TAMANOS'},axis='columns', inplace=True)
    return df

  def obtain_additional_var_from_item_volume(self, path_to_item_volumen, item_volumen_name):
    df_dict = pd.read_excel(path_to_item_volumen+ item_volumen_name, sheet_name=None, header=2)
    full_table = pd.DataFrame()
    #reporting.enr_logger.info("abriendo archivo de Item Volumen: %s" % item_volumen_name)
    for name, sheet in df_dict.items():
      sheet.columns = sheet.columns.str.strip()
      sheet['CATEGORIA'] = name.upper()
      sheet = self.rename_used_sheet_columns(name, sheet)
      #reporting.enr_logger.info("procesando hoja: %s..." % name)
      #procesar item volumen
      """
      if name.upper() == 'HELADOS':
        sheet = sheet.loc[:, ['TAG', 'DESC', 'TAMANOS', 'SHARE VOL','LEVEL']]
      else:
        sheet['LEVEL'] = 'NA'
      """
      sheet = sheet.loc[:, ['TAG', 'DESC', 'TAMANOS', 'SHARE VOL','LEVEL']]
      df = sheet['DESC'].str.extractall(self.__REGULAR_EXPRESION_SIZE)
      df = df.reset_index()
      df = df.pivot(index = 'level_0', columns='match', values=0)
      df.columns = [str(col)+'_tamano' for col in df.columns]
      df = sheet.join(df)
      # pasar tamano y valores a numerico cruzar con sheet y comparar resultados 
      df_size_ori = sheet['TAMANOS'].str.extractall(self.__REGULAR_EXPRESION_RANGOS)
      df_size_ori = df_size_ori.reset_index()
      df_size_ori = df_size_ori.pivot(index = 'level_0', columns='match', values=0)
      df_size_ori.columns = [str(col)+'_tamano_original' for col in df_size_ori.columns]
      df = df.join(df_size_ori)
      del df_size_ori

      #calculo de unidades por empaque
      df_uxe = sheet['DESC'].str.extractall(self.__REGULAR_EXPRESION_UXE)
      df_uxe = df_uxe.reset_index()
      df_uxe = df_uxe.pivot(index = 'level_0', columns='match', values=0)
      df_uxe.columns = [str(col)+'_uxe' for col in df_uxe.columns]
      df = df.join(df_uxe)
      del df_uxe
      #reporting.enr_logger.info("consolidando hoja %s..." % name)
      df['Hoja'] = name.upper()
      full_table = full_table.append(df)
    full_table.reset_index(inplace=True, drop=True)
    #reporting.enr_logger.info("finalizado procesamiento de todas las hojas preparando la asignación de valores definitivos")
    cols_cal_size = [col for col in full_table.columns if col.endswith('_tamano')]
    cols_ori_size = [col for col in full_table.columns if col.endswith('_tamano_original')]
    cols_cal_uxe = [col for col in full_table.columns if col.endswith('_uxe')]
    if '1_tamano_original' not in full_table.columns:
      full_table['1_tamano_original'] = np.nan
    full_table = full_table.fillna(-99)
    try:
      #reporting.enr_logger.info("Catalogando usando el primer filtro...")
      full_table = full_table.apply(lambda x: self.__first_filter(x, cols_cal_size,cols_ori_size), axis=1)
      if full_table.loc[full_table['estado'] == 'sin clasificar', :].shape[0]!= 0:
        #reporting.enr_logger.info("Catalogando usando el segundo filtro...") 
        full_table.loc[full_table['estado'] == 'sin clasificar', :] = full_table.loc[full_table['estado'] == 'sin clasificar',:].apply(lambda x: self.__second_filter(x, cols_cal_size,cols_ori_size), axis=1)
      if full_table.loc[full_table['estado'] == 'sin clasificar', :].shape[0]!= 0:
        #reporting.enr_logger.info("Catalogando usando el tercer filtro...") 
        full_table.loc[full_table['estado'] == 'sin clasificar', :] = full_table.loc[full_table['estado'] == 'sin clasificar',:].apply(lambda x: self.__third_filter(x, cols_cal_size,cols_cal_uxe), axis=1)
      #reporting.enr_logger.info("Rellenando valores por defecto...") 
      # IF COLUMNAS CALCULADAS 
        
      full_table[full_table==-99] = np.nan
    except Exception as iv:
      pass
      #raise IVExtractException(str(iv), item_volumen_name)
    #ya no es necesario escribir un archivo de Excel solo necesario durante la prueba
    #full_table.to_excel('../stage_area/temp_files/temp_input_files/out_size_uxe.xlsx', index=False)
    #reporting.enr_logger.info("Ejecución finalizada...") 
      
    full_table = self.buscar_hijos_tag(full_table)
    full_table = self.max_share_tamano_tag_padre(full_table)  
    return full_table;

  def read_xml_dictionary(self, path_to_xml, xml_name):
    data = path_to_xml + xml_name
    try:
      #reporting.enr_logger.info("Parseando documento: %s" % xml_name) 
      tree = etree.parse(data)
      req_elems = tree.xpath('//wsp_xml_root/Groups/Groups/Group/RequestElements')
      req_elem = tree.xpath('//wsp_xml_root/Groups/Groups/Group/RequestElements/RequestElement')
      group_elem = tree.xpath('//wsp_xml_root/Groups/Groups/Group')
    except Exception as e:
      pass
      #raise XMLExtractException("Error parsing xml file", xml_name)
    counter = 0
    child_counter = 0
    df_data = []
    try:
      #reporting.enr_logger.info("Generando tabla del documento")
      for elem in req_elems:
        grp_tag, grp_name = group_elem[counter].attrib['Tag'], group_elem[counter].attrib['Name']
        elem_attr = elem.attrib['Count']
        for i in range(0, int(elem_attr)):
          label = req_elem[child_counter].attrib['Label']
          value = req_elem[child_counter].attrib['Value']
          child_counter = child_counter + 1
          df_data.append([counter, grp_tag, grp_name, elem_attr, label, value, str(counter)+"_" +str(i), child_counter])
        counter = counter + 1
    except Exception as e:
      #raise XMLExtractException(str(e), xml_name)
      pass
    #reporting.enr_logger.info("Retornar datos parseados de xml")
    df = pd.DataFrame(data = df_data, columns=['Id_Grupo', 'tag_grupo', 'nombre_grupo', 'cantidad_elementos_grupo', 'label_elemento', 'nombre_elemento', 'id_elemento', 'elemento_numero'])
    #df.to_excel(path_to_xml + 'out_dict_gall.xlsx', index=False)
    return df
  
  def buscar_hijos_tag(self,df):
      v_padre = []
      v_seg = []
      v_asig = []
      v_relle = []
      for i in range(len(df)):
          #if df['TAG'][i][0] in ('N','S','Q') or df['LEVEL'][i][0] == 'P':
          if df['LEVEL'][i][0] == 'T' or df['LEVEL'][i][0] == 'P':
              val = 1
          else:
              val = 0
          v_padre.append(val)
          v_seg.append(sum(v_padre[0:(i+1)]))  
            
          if i == 0:
              v_asig.append(df['TAG'][0])
          if v_seg[i] != v_seg[i-1] and i != 0:
              v_asig.append(df['TAG'][i])
          elif v_seg[i] == v_seg[i-1] and i != 0:
              v_asig.append('na')
                
          if i == 0:
              v_relle.append(df['TAG'][0])
          if v_asig[i] == "na" and i != 0:
              v_relle.append(v_relle[i-1])
          elif v_asig[i] != "na" and i != 0:
              v_relle.append(v_asig[i])  
      df['TAG_PADRE'] = v_relle
      df['SEGMENTO_PADRE'] = v_seg
      df['ASIGNACION_PADRE'] = v_asig
      df['RELLENAR_HJOS'] = v_relle
      #df.to_csv('../ficheros/m_peso.csv', header=True, index=False)
      return df

  def max_share_tamano_tag_padre(self,df): 
      tag_unicos = df['TAG_PADRE'].unique()
      n = pd.value_counts(df['TAG_PADRE']).max()  #saber cual es el maximo numero de repeticiones TAG para optimizar el ciclo
      v_max = []
      v_tamano = []
      v_tag = []
      v_uxe = []
      aux = 0
      for t in range(len(tag_unicos)):
          max_ = 0
          tamano = 0
          uxe = 0
          i = aux 
          v = 0
          padre = 0
          while i < len(df) and v < n:
              if df['TAG_PADRE'][i] == tag_unicos[t]:
                  padre += 1
                  if padre == 1:
                      share_padre = df['SHARE VOL'][i] 
                      tamano = df['resultado'][i]
                      uxe = df['0_uxe'][i]
                  elif padre > 1:
                      if tamano == 0:
                          tamano = df['resultado'][i]
                      if uxe == 0:
                          uxe = df['0_uxe'][i]    
                      if share_padre != 0: #si es igual a cero no tendria como sacar una distribucion de frecuencias
                          if df['SHARE VOL'][i] != 0:
                              if (df['SHARE VOL'][i] / share_padre)*100 > max_:
                                  #print((df['SHARE VOL'][i] / share_padre)*100,  "es mayor a: ", max_,": ",((df['SHARE VOL'][i] / share_padre)*100) > max_)
                                  max_ = (df['SHARE VOL'][i] / share_padre) * 100                    
                                  if max_ < 0.75:
                                      tamano = 0
                                      uxe = 1
                                  else:
                                      tamano = df['resultado'][i]
                                      uxe = df['0_uxe'][i]
                  aux = i              
              i += 1  
              v += 1 
          v_max.append(max_)
          v_tamano.append(tamano)
          v_uxe.append(uxe)
          v_tag.append(tag_unicos[t])    
                 
      d = {
           'TAG_PADRE': v_tag,
           'TAMANO'   : v_tamano,
           'UXE'      : v_uxe
            }                
      df_tamano = pd.DataFrame(data=d) 
      df = pd.merge(df,df_tamano,on='TAG_PADRE',how='left')
      #df.to_csv('ficheros/m_peso_TEST.csv', header=True, index=False)  
      return df
      

"""
item = EnrichmentOps()
ruta = 'C:/Users/CAP04/Desktop/Proyecto/armadillo/ficheros/'
nombre = 'Nutresa Item Volumen Jul - Sep 2020.xlsx'        
m_peso = item.obtain_additional_var_from_item_volume(ruta,nombre)
m_peso.to_csv('peso.csv', header=True, index=False)
"""



    
