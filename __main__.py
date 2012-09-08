import bottle

from windmaster import app

if __name__ == "__main__":
    bottle.run(app, host="0.0.0.0", port=8081, server="gevent")