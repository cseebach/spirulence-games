from gevent import monkey; monkey.patch_all()
import bottle
from bottle.ext import sqlite

__author__ = 'spirulence'

app = bottle.Bottle()
db_plugin = sqlite.Plugin(dbfile="windmaster.db")
app.install(db_plugin)

@app.route("/")
@bottle.view("windmaster.html")
def game():
    return dict()

