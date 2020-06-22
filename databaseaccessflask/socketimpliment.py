from flask import Flask
from flask_socketio import SocketIO,emit


app = Flask(__name__)
socketio = SocketIO(app)
app.config['SECRET_KEY'] = "kjajkasd"




@socketio.on("message")
def handle_msg(msg):
    socketio.send("message",msg) 


if __name__ == "__main__":
    
    socketio.run(app, host= "0.0.0.0", port= 8000)