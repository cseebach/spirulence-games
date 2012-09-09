import bottle
from bottle.ext import sqlite

__author__ = 'spirulence'

app = bottle.Bottle()
db_plugin = sqlite.Plugin(dbfile="teknosparx.db")
app.install(db_plugin)

@app.route("/")
@bottle.view("teknosparx.html")
def game():
    return dict()