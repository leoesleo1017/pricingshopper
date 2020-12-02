from flask import Flask, render_template, request, redirect, url_for, flash, session 
#import os
#from werkzeug import secure_filename
#import hashlib
import pandas as pd


app = Flask(__name__)
#app.config.from_object(DevelopmentConfig)

@app.route('/')
def index():
    return render_template('index.html')

if __name__ == '__main__':
    app.run(host='127.0.0.1', port=5000,debug=True) 
