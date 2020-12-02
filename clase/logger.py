import time
import io
import json

class logger():
    def __init__(self, pathlog='logs/', logName="process.log"):
        """Inicializa el logger
        
        Argumentos:
        pathlog -- Ruta donde se escribirá el log
        logName -- Nombre del archivo log (el archivo tendrá un sufihjo con la fecha de creación)        
        """
        self.path = pathlog
        self.filename = self.path + self.curDate() + "_" + logName
        self.flog = io.open(self.filename , 'a' , encoding = 'UTF-8') 
        self.typeMsg = {
                "I" : "[INFO ] ",
                "E" : "[ERROR] ",
                "D" : "[DEBUG] "                
                }
    
    def get_config(self,bd): #este metodo puede ir en la super clase 
        with open('conexion/'+bd+'.json') as f_in:
            json_str = f_in.read()
            return json.loads(json_str)
    
    def curDate(self):
        """Devuelve la decha en formato YYYYMMDDHHMMSS."""
        time.ctime()
        return  time.strftime('%Y%m%d%H%M%S')
    
    def curTime(self):
        """Devuelve la decha en formato YYYY-MM-DD HH:MM:SS."""
        time.ctime()
        return  '[' + time.strftime('%Y-%m-%d %H:%M:%S') + '] '
    
    def Info(self , message):
        """Escribe un mensaje de info en el log"""
        self.__writeLog(message , "I")
        
    def Error(self , message):
        """Escribe un mensaje de error en el log"""
        self.__writeLog(message , "E")
        
    def Debug(self , message):
        """Escribe un mensaje de Debug en el log"""
        self.__writeLog(message , "D")
    
    def __writeLog(self , message , typeM):
        """Función que escribe el mensaje con el tipo especificado"""
        msx = self.curTime() + self.typeMsg[typeM] + message.strip()
        print( msx ) 
        """
        log_ = "INSERT INTO public.conf_logs (log) VALUES (" + "'" + msx + "'" + ")"
        m = Sql(self.get_config('postgresql_scantrack'))
        m.execute(log_) 
        """
        self.flog.writelines( msx + "\n")
        self.flog.flush()
        
    def close(self):
        """ECierra el archivo de log"""
        self.flog.flush()
        self.flog.close()

        
"""        
log = logger()
log.Info("esto es un info")
log.Error("esto es un error")
log.Debug("esto es un debug")
"""        