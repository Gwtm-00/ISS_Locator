import googlemaps
from flask import Flask, render_template, Request,request, jsonify,json
import requests


from datetime import datetime


app = Flask(__name__,template_folder='templates')


@app.route('/')
def root():
    lat_long = getISScoordinates()
    
    coordi = json.loads(lat_long)
    longi = coordi['iss_position']['longitude']
    lati = coordi['iss_position']['latitude']
    return render_template('index.html',lat = lati, lng = longi)

@app.route('/iss')
def getISScoordinates():
    r = requests.get('http://api.open-notify.org/iss-now.json').text
    return r


if __name__=="__main__":
    app.run()