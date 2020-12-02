# -*- coding: utf-8 -*-
"""
Created on Thu Jul 23 14:18:56 2020

@author: CAP04
"""


class Sql:
    def __init__(self):
        self.debug = False
        self.log = 'log'
    
    def removeComent(self):
        return "removeComent"
    
    def getQuery(self):
        return "getQuery"
    
class Mysql(Sql):
    def __init__(self):
        super().__init__()
        self.con = 'conMysql'
    
    def listarSql(self):
        return super().removeComent()
    
    def executeSql(self):
        return "executeSql desde Mysql"
    
class PostgreSql(Sql):
    def __init__(self):
        super().__init__()
        self.con = 'conPostgreSql'
    
    def listarSql(self):
        return "listarSql desde PostgreSql"
    
    def executeSql(self):
        return "executeSql desde PostgreSql"
    
sql = Mysql()
print(sql.listarSql())

    
    