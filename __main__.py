import bottle

from spirulence_games import app

if __name__ == "__main__":
    bottle.run(app, host="0.0.0.0", port=8080, server="gevent")