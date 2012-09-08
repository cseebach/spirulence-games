import bottle

from spirulence_games import windmaster

__author__ = 'spirulence'

app = bottle.Bottle()

app.mount("/windmaster", windmaster.app)

@app.route("/lib/<game_code:path>")
def game_code(game_code):
    return bottle.static_file(game_code, "lib/")

@app.route("/media/<asset:path>")
def game_assets(asset):
    return bottle.static_file(asset, "media/")
