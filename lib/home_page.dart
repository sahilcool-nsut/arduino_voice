import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:arduino_voice/SelectBondedDevicePage.dart';
import 'package:arduino_voice/chat_page.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: Text('Devices to pair',style:TextStyle(fontFamily: 'Montserrat')),
          ),
          body: SelectBondedDevicePage(
            onChatPage: (device1) {
              BluetoothDevice device = device1;
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return ChatPage(server: device);
                  },
                ),
              );
            },
          ),
        ));
  }
}
