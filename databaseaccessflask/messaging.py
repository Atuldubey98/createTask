from flask import Flask
from flask_socketio import SocketIO, send

app = Flask(__name__)
app.config['SECRET_KEY'] = 'sadjklsakjl'
socketio = SocketIO(app)

@socketio.on('message')
def handlemesage(msg):
    send(msg, broadcast = True)

if __name__ == "__main__":
    socketio.run(app, host = '0.0.0.0')