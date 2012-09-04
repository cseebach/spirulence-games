from gevent import monkey; monkey.patch_all()
import bottle
from bottle.ext import sqlite

__author__ = 'spirulence'

app = bottle.Bottle()
db_plugin = sqlite.Plugin(dbfile="windmaster.db")
app.install(db_plugin)

@app.route("/")
def game():
    return bottle.static_file("main.html", ".")

@app.route("/lib/<othercode>")
def other_code(othercode):
    return bottle.static_file(othercode, "lib/")

@app.route("/lib/impact/<jsfile>")
def impact_code(jsfile):
    return bottle.static_file(jsfile, "lib/impact/")

@app.route("/lib/game/<jsfile>")
def game_code(jsfile):
    return bottle.static_file(jsfile, "lib/game/")

@app.route("/lib/game/entities/<jsfile>")
def game_entities(jsfile):
    return bottle.static_file(jsfile, "lib/game/entities/")

@app.route("/lib/game/levels/<jsfile>")
def game_levels(jsfile):
    return bottle.static_file(jsfile, "lib/game/levels/")

@app.route("/media/<asset>")
def game_assets(asset):
    return bottle.static_file(asset, "media/")

if __name__ == "__main__":
    bottle.run(app, host="0.0.0.0", port=8081, server="gevent")