import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:highlight_text/highlight_text.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'components.dart';
import 'package:assets_audio_player/assets_audio_player.dart';

class ChatPage extends StatefulWidget {
  final BluetoothDevice server;

  const ChatPage({this.server});

  @override
  _ChatPage createState() => new _ChatPage();
}

class _Message {
  int whom;
  String text;

  _Message(this.whom, this.text);
}

class _ChatPage extends State<ChatPage> {
  final assetsAudioPlayer = AssetsAudioPlayer();



  stt.SpeechToText _speech;
  bool _isListening = false;
  String _text = 'Press the button and start speaking';
  double _confidence = 1.0;

  static final clientID = 0;
  BluetoothConnection connection;

  List<_Message> messages = List<_Message>();
  String _messageBuffer = '';

  final TextEditingController textEditingController =
      new TextEditingController();
  final ScrollController listScrollController = new ScrollController();

  bool isConnecting = true;
  bool get isConnected => connection != null && connection.isConnected;

  bool isDisconnecting = false;

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();

    BluetoothConnection.toAddress(widget.server.address).then((_connection) {
      print('Connected to the device');
      connection = _connection;
      setState(() {
        isConnecting = false;
        isDisconnecting = false;
      });
      connection.input.listen(_onDataReceived).onDone(() {
        if (isDisconnecting) {
          print('Disconnecting locally!');
        } else {
          print('Disconnected remotely!');
        }
        if (this.mounted) {
          setState(() {});
        }
      });
    }).catchError((error) {
      print('Cannot connect, exception occured');
      print(error);
    });
  }

  @override
  void dispose() {
    // Avoid memory leak (`setState` after dispose) and disconnect
    if (isConnected) {
      isDisconnecting = true;
      connection.dispose();
      connection = null;
    }

    super.dispose();
  }
  var code;
  double _value = 90.0;
  @override
  Widget build(BuildContext context) {
    final List<Row> list = messages.map((_message) {
      return Row(
        children: <Widget>[
          Container(
            child: Text(
                (text) {
                  return text == '/shrug' ? '¯\\_(ツ)_/¯' : text;
                }(_message.text.trim()),
                style: TextStyle(color: Colors.white)),
            padding: EdgeInsets.all(12.0),
            margin: EdgeInsets.only(bottom: 8.0, left: 8.0, right: 8.0),
            width: 222.0,
            decoration: BoxDecoration(
                color:
                    _message.whom == clientID ? Colors.blueAccent : Colors.grey,
                borderRadius: BorderRadius.circular(7.0)),
          ),
        ],
        mainAxisAlignment: _message.whom == clientID
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
      );
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: (isConnecting
            ? Text('Connecting ' + widget.server.name,style:TextStyle(fontFamily: 'Montserrat'))
            : isConnected
                ? Text('Live chat with ' + widget.server.name,style:TextStyle(fontFamily: 'Montserrat'))
                : Text('Chat log with ' + widget.server.name,style:TextStyle(fontFamily: 'Montserrat'))),
            actions: [
              Padding(padding: EdgeInsets.all(8.0), child: GestureDetector(
                onTap: () {
                  showDialog(
                      context: context,
                      barrierDismissible: true,
                      builder: (context) {
                        return keyOfCodesComponent();
                      });
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(
                    Icons.info_outline,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),),
            ],

      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: AvatarGlow(
        animate: _isListening,
        glowColor: Theme.of(context).primaryColor,
        endRadius: 75.0,
        duration: const Duration(milliseconds: 2000),
        repeatPauseDuration: const Duration(milliseconds: 100),
        repeat: true,
        child: FloatingActionButton(
          onPressed: isConnected ? _listen : null,
          child: Icon(_isListening ? Icons.mic : Icons.mic_none),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Container(
              padding: const EdgeInsets.fromLTRB(30.0, 30.0, 30.0, 150.0),
              child: TextHighlight(
                text: _text == '' ? "listening.." : _text,
                words: _highlights,
                textStyle: const TextStyle(
                  fontSize: 32.0,
                  color: Colors.black,
                  fontWeight: FontWeight.w400,
                  fontFamily: 'Montserrat'
                ),
              ),
            ),
            Flexible(
              child: ListView(
                  padding: const EdgeInsets.all(12.0),
                  controller: listScrollController,
                  children: list),
            ),
          ],
        ),
      ),
    );
  }

  void _onDataReceived(Uint8List data) {
    // Allocate buffer for parsed data
    int backspacesCounter = 0;
    data.forEach((byte) {
      if (byte == 8 || byte == 127) {
        backspacesCounter++;
      }
    });
    Uint8List buffer = Uint8List(data.length - backspacesCounter);
    int bufferIndex = buffer.length;

    // Apply backspace control character
    backspacesCounter = 0;
    for (int i = data.length - 1; i >= 0; i--) {
      if (data[i] == 8 || data[i] == 127) {
        backspacesCounter++;
      } else {
        if (backspacesCounter > 0) {
          backspacesCounter--;
        } else {
          buffer[--bufferIndex] = data[i];
        }
      }
    }

    // Create message if there is new line character
    String dataString = String.fromCharCodes(buffer);
    int index = buffer.indexOf(13);
    if (~index != 0) {
      setState(() {
        messages.add(
          _Message(
            1,
            backspacesCounter > 0
                ? _messageBuffer.substring(
                    0, _messageBuffer.length - backspacesCounter)
                : _messageBuffer + dataString.substring(0, index),
          ),
        );
        _messageBuffer = dataString.substring(index);
      });
    } else {
      _messageBuffer = (backspacesCounter > 0
          ? _messageBuffer.substring(
              0, _messageBuffer.length - backspacesCounter)
          : _messageBuffer + dataString);
    }
  }

  void _sendMessage(String text) async {
    text = text.trim();
    textEditingController.clear();

    if (text.length > 0) {
      try {
        connection.output.add(utf8.encode(text));
        await connection.output.allSent;

        setState(() {
          messages.add(_Message(clientID, text));
        });

        Future.delayed(Duration(milliseconds: 333)).then((_) {
          listScrollController.animateTo(
              listScrollController.position.maxScrollExtent,
              duration: Duration(milliseconds: 333),
              curve: Curves.easeOut);
        });
      } catch (e) {
        // Ignore error, but notify state
        setState(() {});
      }
    }
  }

  void _listen() async {
    assetsAudioPlayer.stop();
    if (!_isListening) {
      bool available = await _speech.initialize(
        onStatus: (val) => print('onStatus: $val'),
        onError: (val) => print('onError: $val'),
      );
      if (available) {
        setState(() => _isListening = true);
        _speech.listen(
          onResult: (val) => setState(() {
            _text = val.recognizedWords;
            if (val.hasConfidenceRating && val.confidence > 0) {
              _confidence = val.confidence;
            }
          }),
        );
      }
    } else {
      setState(() => _isListening = false);
      _speech.stop();
      changeMode();
    }
  }

  final Map<String, HighlightedWord> _highlights = {
    'flutter': HighlightedWord(
      onTap: () => print('flutter'),
      textStyle: const TextStyle(
        color: Colors.blue,
        fontWeight: FontWeight.bold,
      ),
    ),
    'off': HighlightedWord(
      onTap: () => print('off'),
      textStyle: const TextStyle(
        color: Colors.grey,
        fontWeight: FontWeight.bold,
      ),
    ),
    'rainbow': HighlightedWord(
      onTap: () => print('rainbow'),
      textStyle: const TextStyle(
        color: Colors.pink,
        fontWeight: FontWeight.bold,
      ),
    ),
    'cold': HighlightedWord(
      onTap: () => print('cold'),
      textStyle: const TextStyle(
        color: Colors.blue,
        fontWeight: FontWeight.bold,
      ),
    ),
    'hot': HighlightedWord(
      onTap: () => print('hot'),
      textStyle: const TextStyle(
        color: Colors.red,
        fontWeight: FontWeight.bold,
      ),
    ),
    'disco': HighlightedWord(
      onTap: () => print('disco'),
      textStyle: const TextStyle(
        color: Colors.deepPurpleAccent,
        fontWeight: FontWeight.bold,
      ),
    ),
    'twinkle': HighlightedWord(
      onTap: () => print('twinkle'),
      textStyle: const TextStyle(
        color: Colors.teal,
        fontWeight: FontWeight.bold,
      ),
    ),
    'racing': HighlightedWord(
      onTap: () => print('racing'),
      textStyle: const TextStyle(
        color: Colors.orange,
        fontWeight: FontWeight.bold,
      ),
    ),
    'colour': HighlightedWord(
      onTap: () => print('colour'),
      textStyle: const TextStyle(
        color: Colors.indigo,
        fontWeight: FontWeight.bold,
      ),
    ),
    'soft': HighlightedWord(
      onTap: () => print('soft'),
      textStyle: const TextStyle(
        color: Colors.pinkAccent,
        fontWeight: FontWeight.bold,
      ),
    ),
    'shining': HighlightedWord(
      onTap: () => print('shining'),
      textStyle: const TextStyle(
        color: Colors.pink,
        fontWeight: FontWeight.bold,
      ),
    ),
    'icy': HighlightedWord(
      onTap: () => print('icy'),
      textStyle: const TextStyle(
        color: Colors.blue,
        fontWeight: FontWeight.bold,
      ),
    ),
    'red': HighlightedWord(
      onTap: () => print('red'),
      textStyle: const TextStyle(
        color: Colors.red,
        fontWeight: FontWeight.bold,
      ),
    ),
    'dance': HighlightedWord(
      onTap: () => print('dance'),
      textStyle: const TextStyle(
        color: Colors.deepPurpleAccent,
        fontWeight: FontWeight.bold,
      ),
    ),
    'light': HighlightedWord(
      onTap: () => print('light'),
      textStyle: const TextStyle(
        color: Colors.teal,
        fontWeight: FontWeight.bold,
      ),
    ),
    'speed': HighlightedWord(
      onTap: () => print('speed'),
      textStyle: const TextStyle(
        color: Colors.orange,
        fontWeight: FontWeight.bold,
      ),
    ),
    'wave': HighlightedWord(
      onTap: () => print('wave'),
      textStyle: const TextStyle(
        color: Colors.indigo,
        fontWeight: FontWeight.bold,
      ),
    ),
    'sweet': HighlightedWord(
      onTap: () => print('sweet'),
      textStyle: const TextStyle(
        color: Colors.pinkAccent,
        fontWeight: FontWeight.bold,
      ),
    ),

  };

  void changeMode() {
    if (_text.contains('Off') || _text.contains('off')) {


          _sendMessage('0');
    }
    else if (_text.contains('Rainbow') || _text.contains('rainbow')||_text.contains('Shining') || _text.contains('shining')) {

          assetsAudioPlayer.open(
              Audio("audio/song1.mp3")
          );
          _sendMessage('1');
    }
    else if (_text.contains('Cold') || _text.contains('cold')||_text.contains('Icy') || _text.contains('icy')) {
          assetsAudioPlayer.open(
              Audio("audio/song2.mp3")

          );
          _sendMessage('2');
    }
    else if (_text.contains('Red') || _text.contains('red')||_text.contains('Hot') || _text.contains('hot')) {

      assetsAudioPlayer.open(
          Audio("audio/song0.mp3")
      );
      _sendMessage('3');
    }
    else if (_text.contains('Disco') || _text.contains('disco')||_text.contains('Dance') || _text.contains('dance')) {

      assetsAudioPlayer.open(
          Audio("audio/song4.mp3")
      );
      _sendMessage('4');
    }
    else if (_text.contains('Twinkle') || _text.contains('twinkle')||_text.contains('Light') || _text.contains('light')) {

      assetsAudioPlayer.open(
          Audio("audio/song5.mp3")
      );
      _sendMessage('5');
    }
    else if (_text.contains('Racing') || _text.contains('racing')||_text.contains('Speed') || _text.contains('speed')) {

      assetsAudioPlayer.open(
          Audio("audio/song6.mp3")
      );
      _sendMessage('6');
    }
    else if (_text.contains('Soft') || _text.contains('soft')||_text.contains('Sweet') || _text.contains('sweet')) {

      assetsAudioPlayer.open(
          Audio("audio/song7.mp3")
      );
      _sendMessage('7');
    }
    else if (_text.contains('Colour') || _text.contains('colour')||_text.contains('Wave') || _text.contains('wave')) {

      assetsAudioPlayer.open(
          Audio("audio/song8.mp3")
      );
      _sendMessage('8');
    }

  }
}
