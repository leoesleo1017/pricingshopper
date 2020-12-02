# -*- coding: utf-8 -*-
"""
Created on Thu Oct 15 14:50:59 2020

@author: CAP04
"""
import json

class Get_config:
    def get_config(self,bd):
        with open('conexion/'+bd+'.json') as f_in:
            json_str = f_in.read()
            return json.loads(json_str)