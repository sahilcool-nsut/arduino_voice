import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

class BluetoothDeviceListEntry extends StatelessWidget {
  final Function onTap;
  final BluetoothDevice device;

  BluetoothDeviceListEntry({this.onTap, @required this.device});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: Icon(Icons.devices),
      title: Text(device.name ?? "Unknown device",style: TextStyle(fontFamily: 'Montserrat'),),
      subtitle: Text(device.address.toString()),
      trailing: FlatButton(
        child: Text('Connect',style: TextStyle(color:Colors.white,fontFamily: 'Montserrat'),),
        onPressed: onTap,
        color: Colors.red,
      ),
    );
  }
}
