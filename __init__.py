import bottle
from gevent import monkey; monkey.patch_all()

from spirulence_games import windmaster
from spirulence_games import teknosparx

__author__ = 'spirulence'

app = bottle.Bottle()

app.mount("/windmaster", windmaster.app)
app.mount("/teknosparx", teknosparx.app)

@app.route("/lib/<game_code:path>")
def game_code(game_code):
    return bottle.static_file(game_code, "lib/")

@app.route("/media/<asset:path>")
def game_assets(asset):
    return bottle.static_file(asset, "media/")
