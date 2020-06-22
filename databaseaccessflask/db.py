from flask import Flask, request, jsonify, redirect, url_for, make_response
from pymongo import MongoClient
from bson import ObjectId
import datetime
import bcrypt
import os
from gridfs import GridFS
import json
from  flask_socketio import SocketIO,send
app = Flask(__name__)
app.config['SECRET_KEY'] = "kjajkasd"
client = MongoClient(
    "mongodb+srv://atuldubey:08091959@cluster0-isxbl.mongodb.net/<dbname>?retryWrites=true&w=majority")
db = client.todo
todoApp = db.todo
usersList = db.users
images = GridFS(db)
messages = db.message
connections = db.connection
socketio = SocketIO(app)




@socketio.on("message")
def handle_msg(msg):
    print("Message Sent")
    send(msg, broadcast=True) 


@app.route('/login/<string:userID>', methods=['POST'])
def loginuser(userID):
    request_data = request.get_json()
    loginUser = usersList.find_one({'username': request_data['username']})

    if loginUser:
        if(bcrypt.hashpw(request_data['password'].encode('utf-8'), loginUser['password']) == loginUser['password']):

            return jsonify({"status": "OK", "data": {}, "error": {}, "username": userID})
        return (jsonify({"status": "NotOk", "data": {}, "error": "Sorry password does not match"}))
    return (jsonify({"status": "match", "data": {}, "error": "Username does not exist - create one"}))


@app.route('/register', methods=['POST', 'GET'])
def registerUser():
    if(request.method == "POST"):
        request_data = request.get_json()
        existingUser = usersList.find_one(
            {'username': request_data['username']})

        if existingUser == None:
            hashpass = bcrypt.hashpw(
                request_data['password'].encode('utf-8'), bcrypt.gensalt())
            usersList.insert_one(
                {'username': request_data['username'], 'password': hashpass})

            return jsonify({'status': "OK", "data": {}, "error": {}, 'username': request_data['username']})
        return (jsonify({"status": "NotOk", "data": {}, "error": "User already exist"}))
    return(redirect(url_for('loginuser', userID=request_data['username'])))


@app.route('/<string:userNa>', methods=['GET'])
def getList(userNa):

    reponse = {}

    if(usersList.find_one({"username": userNa}) == None):
        reponse = {"username": "Not Found",
                   "status": "Not Ok", "error": "No User"}
        return(jsonify(reponse))
    elif(todoApp.find_one({"username": userNa})):
        if(todoApp.find_one({"data": {}})):
            reponse = {"username": userNa, "status": "OK",
                       "data": {}, "error": "Add one item"}
            return jsonify(reponse)
        else:
            todoList = []
            for item in todoApp.find({"username": userNa}):

                todoItemtoAppend = {
                    "_id": item['_id'], "title": item['title'], "comment": item["comment"], "imageName": item['imageName']}
                todoList.append(todoItemtoAppend)

            return jsonify({"username": userNa, "status": "OK", "data": todoList, "error": {}})
    return jsonify({"data": {}, "error": "Not found", "username": userNa, "status": "Ok"})


@app.route('/addItem/<string:userID>', methods=['POST'])
def addItem(userID):
    todoList = []
    request_data = request.get_json()
    idofItem = request_data['_id']
    title = request_data['title']
    comment = request_data['comment']
    image = request_data['imageName']
    newItem = {
        'username': userID,
        '_id': idofItem,
        'title': title,
        'comment': comment,
        'imageName': image
    }
    todoApp.insert_one(newItem)
    todoList.append(newItem)
    return jsonify({"username": userID, "status": "OK", "data": todoList, "error": {}})


@ app.route('/deleteItem/<string:userID>/<string:iditem>/<string:filename>', methods=['DELETE'])
def deleteItem(userID, iditem, filename):

    itemtodelete = todoApp.find_one({'imageName': filename})
    print(itemtodelete['imageName'])
    idofitem = images.get_last_version(itemtodelete['imageName'])
    images.delete(idofitem._id)

    todoApp.delete_one({'_id': iditem, 'username': userID})

    todoList = []
    for item in todoApp.find({'username': userID}):

        todoItemtoAppend = {
            "_id": item['_id'], "title": item['title'], "comment": item["comment"]}
        todoList.append(todoItemtoAppend)

    return jsonify({"username": userID, "status": "OK", "data": todoList, "error": {}})


@app.route('/allpost', methods=['GET'])
def allItem():
    todoList = []
    for item in todoApp.find():
        todoItemtoAppend = {"_id": item['_id'], "title": item['title'],
                            "username": item["username"], "comment": item["comment"], 'imageName': item['imageName']}
        todoList.append(todoItemtoAppend)
    return jsonify({"data": todoList, "status": "OK", "error": {}})


@app.route('/upload/<file_name>/<string:itemId>', methods=['PUT'])
def upload(file_name, itemId):
    with images.new_file(filename=file_name) as fp:
        fp.write(request.data)
        file_id = fp._id
        todoItem = todoApp.find_one({'_id': itemId})
        todoItem['image'] = file_id
        todoApp.find_one_and_replace({'_id': itemId}, todoItem)
        print(todoItem)
    if images.find_one(file_id) is not None:
        return json.dumps({"status": "File Saved Successfully", "_id": itemId}), 200
    else:
        return json.dumps({'status': 'Error occurred while saving file.'}), 500


@app.route('/download/<string:user>/<file_name>/<string:itemID>')
def download(file_name, itemID, user):
    extractedItem = todoApp.find_one({"_id": itemID, "username": user})
    image = images.find_one({"_id": extractedItem['image']})
    response = make_response(image.read())
    response.headers['Content-type'] = "application/octet-stream"
    response.headers["Content-Disposition"] = "attachment; filename={}".format(
        file_name)
    return response


@app.route('/listusers/<string:userID>', methods=['GET'])
def listusers(userID):
    users = []
    for item in usersList.find():
        if(item['username'] != userID):
            usertoappend = {'username': item['username']}
            users.append(usertoappend)
    if(users == None):
        return jsonify({'data': {}, "status":  "Not Ok", "error": "No users"})
    return jsonify({'data': users, "status":  "OK", "error": "Users Found"})


@app.route('/requestchat', methods=['POST'])
def requestchat():
    request_data = request.get_json()
    from_user = request_data['from_user']
    to_user = request_data['to_user']
    to_user_channel = "private-notification_user%s" % (to_user)
    from_user_channel = 'private-notification_user%s' % (from_user)
    chat_channel = {'channel_from_user': from_user, 'channel_to_user': to_user}
    data = {
        "from_user": from_user,
        "to_user": to_user,
        "from_user_notification_channel": from_user_channel,
        "to_user_notification_channel": to_user_channel,
        "channel_name": chat_channel,
    }
    connections.insert_one(data)
    return jsonify(data)


@app.route('/sendmessage', methods=['POST'])
def sendmessage():
    request_data = request.get_json()
    from_user = request_data['from_user']
    to_user = request_data['to_user']
    message = request_data['message']
    idofchatitem = request_data['_id']
    tag = request_data['tag']
    new_message = {
        "_id": idofchatitem,
        "from_user": from_user,
        "to_user": to_user,
        "message": message,
        "tag" : tag
    }
    messages.insert_one(new_message)
    return jsonify(new_message)


@app.route('/allchat/<string:fromuser>/<string:touser>', methods=['GET'])
def allchat(fromuser, touser):
    response = {"data": {}, "error": "No Chat"}
    messagesList = []

    for item in messages.find({'from_user': fromuser, 'to_user': touser}):
        itemtoadd = {
            "message": item['message'], 'tag' : item['tag'],'_id': item['_id']}
        messagesList.append(itemtoadd)
    response = {"status": "OK", "data": messagesList}

   
    for item in messages.find({'from_user': touser, 'to_user': fromuser}):
        itemtoadd = {
                "message": item['message'], 'tag': item['tag'],'_id': item['_id']}
        messagesList.append(itemtoadd)
        response = {"data": messagesList, "error": "No Chat"}
    return jsonify(response)


if __name__ == '__main__':
    socketio.run(app,host='0.0.0.0', debug=True)
