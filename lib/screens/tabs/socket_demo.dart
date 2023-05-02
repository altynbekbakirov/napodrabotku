import 'dart:async';
import 'dart:convert';
import 'dart:io';
//import 'package:socket_io/socket_io.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class StreamSocket{
  final _socketResponse= StreamController<String>();

  void Function(String) get addResponse => _socketResponse.sink.add;

  Stream<String> get getResponse => _socketResponse.stream;

  void dispose(){
    _socketResponse.close();
  }
}

class SocketDemo extends StatefulWidget {
  SocketDemo() : super();

  final String title = "Socket Demo";

  @override
  SocketDemoState createState() => SocketDemoState();
}

class SocketDemoState extends State<SocketDemo> with WidgetsBindingObserver {
  WebSocketChannel channel ;

  String _status;
//  SocketUtil _socketUtil;

  List<String> _messages;
  TextEditingController _textEditingController;
  int userSelected = 1;
  IO.Socket socket;

  @override
  void initState() {
    super.initState();
    // connectAndListen();
    socket = IO.io('http://10.0.2.2:8001');
    _textEditingController = TextEditingController();
    _status = "";
    _messages = List<String>();

    /*Socket.connect("192.168.0.105", 8001).then((socket) {
      print('Connected to: ');

      //Establish the onData, and onDone callbacks
      socket.listen((data) {
        print(new String.fromCharCodes(data).trim());
      },
          onDone: () {
            print("Done");
            socket.destroy();
          });

      //Send the request
      socket.write(json.encode('{command: "register", userId: 9}'));
    });*/
  }



  StreamSocket streamSocket =StreamSocket();

//STEP2: Add this function in main function in main.dart file and add incoming data to the stream
  void connectAndListen(){
    IO.Socket socket = IO.io('http://10.0.2.2:8001',
      OptionBuilder()
        .setTransports(['websocket']).build()
    );

    socket.onConnect((_) {
      print('connect');
      socket.emit('msg', 'test111');
    });

    //When an event recieved from server, data is added to the stream
    socket.on('event', (data) {
      print(data);
      streamSocket.addResponse;
    });
    socket.onDisconnect((_) => print('disconnect'));

  }

  @override
  void dispose() {
    channel.sink.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20.0),
      child: Column(
        children: <Widget>[
          TextField(
            controller: _textEditingController,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: const BorderRadius.all(
                  const Radius.circular(
                    5.0,
                  ),
                ),
              ),
              filled: true,
              fillColor: Colors.white60,
              contentPadding: EdgeInsets.all(15.0),
              hintText: 'Enter message',
            ),
          ),
          OutlineButton(
            child: Text("Send Message"),
            onPressed: () {

              // print(111);
              // connectAndListen();

              if (_textEditingController.text.isEmpty) {
                return;
              }
              // socket.onConnect((_) {
              //   print('connect');
              //   socket.emit('chat message', 'testa23423');
              // });
              socket.emit('chat message', _textEditingController.text);
              socket.on('event', (data) => print(data));
              socket.onDisconnect((_) => print('disconnect'));
              socket.on('fromServer', (_) => print(_));
              /*channel.sink.add('chat message, message');
              channel.sink.add(json.encode('{command: "message", from:"1", to: "9", message: "22"}'));
              channel.sink.add('asd');
              _socketUtil.sendMessage(_textEditingController.text).then(
                    (bool messageSent) {
                  if (messageSent) {
                    _textEditingController.text = "";
                  }
                },
              );*/
            },
          ),
          SizedBox(
            height: 20.0,
          ),
          Text(_status),
          SizedBox(
            height: 20.0,
          ),
          Expanded(
            child: StreamBuilder(
              stream: streamSocket.getResponse,
              builder: (BuildContext context, AsyncSnapshot<String> snapshot){
                print(snapshot.data);
                return Container(
                  child: Text(snapshot.data != null ? snapshot.data : 'tttt'),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void messageListener(String message) {
    print('Adding message');
    setState(() {
      _messages.add(message);
    });
  }

  void connectListener(bool connected) {
    setState(() {
      _status = "Status: " + (connected ? "Connected" : "Failed to Connect");
    });
  }
}

/*
class SocketUtil {
  Socket _socket;
  bool socketInit = false;
  static const String SERVER_IP = "192.168.0.105";
  static const int SERVER_PORT = 8001;

  Future<bool> sendMessage(String message) async {
    try {
      _socket.add(utf8.encode("chat message, message"));
    } catch (e) {
      print(e.toString());
      return false;
    }
    return true;
  }

  Future<bool> initSocket(
      Function connectListener, Function messageListener) async {
    try {
      print('Connecting to socket');
      _socket = await Socket.connect(SERVER_IP, SERVER_PORT);
      connectListener(true);
      _socket.listen((List<int> event) {
        messageListener(utf8.decode(event));
      });
      socketInit = true;
    } catch (e) {
      print(e.toString());
      connectListener(false);
      return false;
    }
    return true;
  }

  void closeSocket() {
    _socket.close();
    _socket = null;
  }

  void cleanUp() {
    if (null != _socket) {
      _socket.destroy();
    }
  }
}
*/
