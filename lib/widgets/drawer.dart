// import 'dart:typed_data';

// import 'package:flutter/material.dart';
// import 'package:packages/packages.dart';

// class DrawerContent extends StatefulWidget {
//   final BluetoothConnectionState connectionState;
//   final List<BluetoothService> services;
//   const DrawerContent(
//       {super.key, required this.connectionState, required this.services});

//   @override
//   State<DrawerContent> createState() => _DrawerContentState();
// }

// class _DrawerContentState extends State<DrawerContent> {
//   bool fastAcceleration = false;
//   bool kph = true;
//   bool lightOn = false;
//   bool lightBlink = false;

//   void sendCommand(
//       BluetoothCharacteristic characteristic, int commandByte, int speed) {
//     // Combine commands, calculate CRC, and transmit to ESC
//     Uint8List buf = Uint8List(6);
//     buf[0] = 0xA6;
//     buf[1] = 0x12;
//     buf[2] = 0x02;
//     buf[3] = commandByte;
//     buf[4] = speed;
//     buf[5] = calculateCrc8Maxim(buf.sublist(0, 5));
//     // Send command (this is a placeholder, replace with actual sending logic)
//     print('Command Byte: $commandByte, Buffer: $buf');
//     characteristic.write(buf);
//   }

//   int genCommandByte(bool fastAcceleration, bool kph, bool lightOn,
//       bool lightBlink, bool powerOn) {
//     List<bool> bits = [
//       powerOn,
//       lightBlink,
//       lightOn,
//       false,
//       kph,
//       fastAcceleration,
//       false,
//       false
//     ];
//     int commandByte = 0;
//     for (int i = 0; i < bits.length; i++) {
//       if (bits[i]) {
//         commandByte |= 1 << i;
//       }
//     }
//     return commandByte;
//   }

//   int startCommand(
//       bool fastAcceleration, bool kph, bool lightOn, bool lightBlink) {
//     return genCommandByte(fastAcceleration, kph, lightOn, lightBlink, true);
//   }

//   int stopCommand(bool lightBlink) {
//     return genCommandByte(false, true, false, lightBlink, false);
//   }

//   int calculateCrc8Maxim(Uint8List data) {
//     final crc8 = Crc8Maxim();
//     return crc8.convert(data).toBigInt().toInt();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Column(children: [
//       if (widget.services.isEmpty)
//         Text(
//           'No services available.',
//           style: TextStyle(color: Colors.grey),
//         ) else
//       if (widget.connectionState == BluetoothConnectionState.connected) ...[
//         SwitchListTile(
//           title: Text('Fast Acceleration'),
//           value: fastAcceleration,
//           onChanged: (bool value) {
//             setState(() {
//               fastAcceleration = value;
//             });
//           },
//         ),
//         SwitchListTile(
//           title: Text('KPH'),
//           value: kph,
//           onChanged: (bool value) {
//             setState(() {
//               kph = value;
//             });
//           },
//         ),
//         SwitchListTile(
//           title: Text('Light On'),
//           value: lightOn,
//           onChanged: (bool value) {
//             setState(() {
//               lightOn = value;
//             });
//           },
//         ),
//         SwitchListTile(
//           title: Text('Light Blink'),
//           value: lightBlink,
//           onChanged: (bool value) {
//             setState(() {
//               lightBlink = value;
//             });
//           },
//         ),
//         // SizedBox(height: 20),
//         // ElevatedButton(
//         //   onPressed: () {
//         //     int commandByte =
//         //         startCommand(fastAcceleration, kph, lightOn, lightBlink);
//         //     sendCommand(commandByte, 20);
//         //   },
//         //   child: Text('Send Start Command'),
//         // ),
//         // ElevatedButton(
//         //   onPressed: () {
//         //     int commandByte = stopCommand(lightBlink);
//         //     sendCommand(,commandByte, 0);
//         //   },
//         //   child: Text('Send Stop Command'),
//         // ),

//         // if (widget.connectionState != BluetoothConnectionState.connected)
//         for (var service in widget.services)
//           ExpansionTile(
//               title: Text(
//                 'Service: ${service.uuid.toString().substring(0, 8)}',
//                 style: TextStyle(fontWeight: FontWeight.bold),
//               ),
//               children: service.characteristics.map((characteristic) {
//                 return ListTile(
//                     title: Text(
//                       'Characteristic: ${characteristic.uuid.toString().substring(0, 8)}',
//                     ),
//                     subtitle: Text(
//                         'Properties: ${characteristic.properties.toString()}'),
//                     trailing: Row(
//                       children: [
//                         if (characteristic.properties.read)
//                           ElevatedButton(
//                             onPressed: () async {
//                               if (characteristic.properties.read) {
//                                 try {
//                                   var value = await characteristic.read();
//                                   ScaffoldMessenger.of(context)
//                                       .showSnackBar(
//                                     SnackBar(
//                                       content: Text(
//                                           'Read Value: ${value.toString()}'),
//                                     ),
//                                   );
//                                 } catch (e) {
//                                   ScaffoldMessenger.of(context)
//                                       .showSnackBar(
//                                     SnackBar(
//                                       content: Text(
//                                           'Error reading characteristic: $e'),
//                                     ),
//                                   );
//                                 }
//                               } else {
//                                 ScaffoldMessenger.of(context).showSnackBar(
//                                   SnackBar(
//                                     content: Text(
//                                         'This characteristic does not support reading.'),
//                                   ),
//                                 );
//                               }
//                             },
//                             child: Text('Read'),
//                           ),
//                         if (characteristic.properties.write ||
//                             characteristic
//                                 .properties.writeWithoutResponse ||
//                             characteristic
//                                 .properties.authenticatedSignedWrites)
//                           ElevatedButton(
//                             onPressed: () async {
//                               try {
//                                 // await characteristic
//                                 //     .write([0x01, 0x02]); // Example data

//                                 int commandByte = startCommand(
//                                     fastAcceleration,
//                                     kph,
//                                     lightOn,
//                                     lightBlink);
//                                 sendCommand(
//                                     characteristic, commandByte, 20);
//                                 ScaffoldMessenger.of(context)
//                                     .showSnackBar(SnackBar(
//                                   content: Text('Write successful'),
//                                 ));
//                               } catch (e) {
//                                 ScaffoldMessenger.of(context)
//                                     .showSnackBar(SnackBar(
//                                   content: Text('Write failed: $e'),
//                                 ));
//                               }
//                             },
//                             child: Text('start'),
//                           ),
//                         if (characteristic.properties.write ||
//                             characteristic
//                                 .properties.writeWithoutResponse ||
//                             characteristic
//                                 .properties.authenticatedSignedWrites)
//                           ElevatedButton(
//                             onPressed: () {
//                               int commandByte = stopCommand(lightBlink);
//                               sendCommand(characteristic, commandByte, 0);
//                             },
//                             child: Text('Stop'),
//                           )
//                       ],
//                     ));
//               }).toList()),
// //////////
//         // ListView.builder(
//         //   itemCount: widget.services.length,
//         //   itemBuilder: (context, serviceIndex) {
//         //     final service = widget.services[serviceIndex];
//         //     final characteristics = service.characteristics;

//         //     return ExpansionTile(
//         //       title: Text(
//         //         'Service: ${service.uuid}',
//         //         style: TextStyle(fontWeight: FontWeight.bold),
//         //       ),
//         //       children: characteristics.map((characteristic) {
//         //         return ListTile(
//         //           title: Text('Characteristic: ${characteristic.uuid}'),
//         //           subtitle: Column(
//         //             crossAxisAlignment: CrossAxisAlignment.start,
//         //             children: [
//         //               Text('Properties: ${characteristic.properties}'),
//         //               Row(
//         //                 children: [
//         //                   ElevatedButton(
//         //                     onPressed: () async {
//         //                       try {
//         //                         final value = await characteristic.read();
//         //                         ScaffoldMessenger.of(context)
//         //                             .showSnackBar(SnackBar(
//         //                           content:
//         //                               Text('Read value: ${value.toString()}'),
//         //                         ));
//         //                       } catch (e) {
//         //                         ScaffoldMessenger.of(context)
//         //                             .showSnackBar(SnackBar(
//         //                           content: Text('Read failed: $e'),
//         //                         ));
//         //                       }
//         //                     },
//         //                     child: Text('Read'),
//         //                   ),
//         //                   SizedBox(width: 10),
//         //                   ElevatedButton(
//         //                     onPressed: () async {
//         //                       try {
//         //                         // await characteristic
//         //                         //     .write([0x01, 0x02]); // Example data

//         //                         int commandByte = startCommand(
//         //                             fastAcceleration, kph, lightOn, lightBlink);
//         //                         sendCommand(characteristic, commandByte, 20);
//         //                         ScaffoldMessenger.of(context)
//         //                             .showSnackBar(SnackBar(
//         //                           content: Text('Write successful'),
//         //                         ));
//         //                       } catch (e) {
//         //                         ScaffoldMessenger.of(context)
//         //                             .showSnackBar(SnackBar(
//         //                           content: Text('Write failed: $e'),
//         //                         ));
//         //                       }
//         //                     },
//         //                     child: Text('start'),
//         //                   ),
//         //                   ElevatedButton(
//         //                     onPressed: () {
//         //                       int commandByte = stopCommand(lightBlink);
//         //                       sendCommand(characteristic, commandByte, 0);
//         //                     },
//         //                     child: Text('Stop'),
//         //                   ),
//         //                 ],
//         //               ),
//         //             ],
//         //           ),
//         //         );
//         //       }).toList(),
//         //     );
//         //   },
//         // )
//       ],
//       // else
//       //   Center(
//       //     child: Text(
//       //       'No active connection. Please connect to a device.',
//       //       style: TextStyle(fontSize: 16, color: Colors.grey),
//       //       textAlign: TextAlign.center,
//       //     ),
//       //   ),
//     ]);
//   }
// }

// ////////
// ///
// ///
// ///
// ///
// ///
// ///

// // class DrawerContent extends StatefulWidget {
// //   final BluetoothConnectionState connectionState;
// //   final List<BluetoothService> services;

// //   const DrawerContent({
// //     super.key,
// //     required this.connectionState,
// //     required this.services,
// //   });

// //   @override
// //   State<DrawerContent> createState() => _DrawerContentState();
// // }

// // class _DrawerContentState extends State<DrawerContent> {
// //   bool fastAcceleration = false;
// //   bool kph = true;
// //   bool lightOn = false;
// //   bool lightBlink = false;

// //   void sendCommand(int commandByte, int speed) {
// //     // Combine commands, calculate CRC, and transmit to ESC
// //     Uint8List buf = Uint8List(6);
// //     buf[0] = 0xA6;
// //     buf[1] = 0x12;
// //     buf[2] = 0x02;
// //     buf[3] = commandByte;
// //     buf[4] = speed;
// //     buf[5] = calculateCrc8Maxim(buf.sublist(0, 5));
// //     // Send command (this is a placeholder, replace with actual sending logic)
// //     print('Command Byte: $commandByte, Buffer: $buf');
// //   }

// //   int genCommandByte(bool fastAcceleration, bool kph, bool lightOn,
// //       bool lightBlink, bool powerOn) {
// //     List<bool> bits = [
// //       powerOn,
// //       lightBlink,
// //       lightOn,
// //       false,
// //       kph,
// //       fastAcceleration,
// //       false,
// //       false
// //     ];
// //     int commandByte = 0;
// //     for (int i = 0; i < bits.length; i++) {
// //       if (bits[i]) {
// //         commandByte |= 1 << i;
// //       }
// //     }
// //     return commandByte;
// //   }

// //   int startCommand(
// //       bool fastAcceleration, bool kph, bool lightOn, bool lightBlink) {
// //     return genCommandByte(fastAcceleration, kph, lightOn, lightBlink, true);
// //   }

// //   int stopCommand(bool lightBlink) {
// //     return genCommandByte(false, true, false, lightBlink, false);
// //   }

// //   int calculateCrc8Maxim(Uint8List data) {
// //     final crc8 = Crc8Maxim();
// //     return crc8.convert(data).toBigInt().toInt();
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return widget.connectionState == BluetoothConnectionState.connected
// //         ? ListView(
// //             padding: EdgeInsets.all(16.0),
// //             children: [
// //               Text(
// //                 'Bluetooth Services',
// //                 style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
// //               ),
// //               SizedBox(height: 10),
// //               if (widget.services.isEmpty)
// //                 Text(
// //                   'No services available.',
// //                   style: TextStyle(color: Colors.grey),
// //                 ),
// //               for (var service in widget.services)
// //                 Card(
// //                   child: ExpansionTile(
// //                     title: Text(
// //                       'Service: ${service.uuid.toString().substring(0, 8)}',
// //                       style: TextStyle(fontWeight: FontWeight.bold),
// //                     ),
// //                     children: service.characteristics.map((characteristic) {
// //                       return ListTile(
// //                         title: Text(
// //                           'Characteristic: ${characteristic.uuid.toString().substring(0, 8)}',
// //                         ),
// //                         subtitle: Text(
// //                             'Properties: ${characteristic.properties.toString()}'),
// //                         trailing: ElevatedButton(
// //                           onPressed: () async {
// //                             if (characteristic.properties.read) {
// //                               try {
// //                                 var value = await characteristic.read();
// //                                 ScaffoldMessenger.of(context).showSnackBar(
// //                                   SnackBar(
// //                                     content:
// //                                         Text('Read Value: ${value.toString()}'),
// //                                   ),
// //                                 );
// //                               } catch (e) {
// //                                 ScaffoldMessenger.of(context).showSnackBar(
// //                                   SnackBar(
// //                                     content: Text(
// //                                         'Error reading characteristic: $e'),
// //                                   ),
// //                                 );
// //                               }
// //                             } else {
// //                               ScaffoldMessenger.of(context).showSnackBar(
// //                                 SnackBar(
// //                                   content: Text(
// //                                       'This characteristic does not support reading.'),
// //                                 ),
// //                               );
// //                             }
// //                           },
// //                           child: Text('Read'),
// //                         ),
// //                       );
// //                     }).toList(),
// //                   ),
// //                 ),
// //             ],
// //           )
// //         : Center(
// //             child: Text(
// //               'No Bluetooth connection detected.',
// //               style: TextStyle(color: Colors.red, fontSize: 16),
// //             ),
// //           );
// //   }
// // }

///////////////////////
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:packages/packages.dart';

class DrawerContent extends StatefulWidget {
  final BluetoothConnectionState connectionState;
  final List<BluetoothService> services;
  const DrawerContent(
      {super.key, required this.connectionState, required this.services});

  @override
  State<DrawerContent> createState() => _DrawerContentState();
}

class _DrawerContentState extends State<DrawerContent> {
  bool fastAcceleration = false;
  bool kph = true;
  bool lightOn = false;
  bool lightBlink = false;

  void sendCommand(
      BluetoothCharacteristic characteristic, int commandByte, int speed) {
    // Combine commands, calculate CRC, and transmit to ESC
    Uint8List buf = Uint8List(6);
    buf[0] = 0xA6;
    buf[1] = 0x12;
    buf[2] = 0x02;
    buf[3] = commandByte;
    buf[4] = speed;
    buf[5] = int.parse(calculateCrc8Maxim(buf.sublist(0, 5)), radix: 16);
    // Send command (this is a placeholder, replace with actual sending logic)
    characteristic.write(buf);
    print('Command Byte: $commandByte, Buffer: $buf');
  }

  int genCommandByte(bool fastAcceleration, bool kph, bool lightOn,
      bool lightBlink, bool powerOn) {
    List<bool> bits = [
      powerOn,
      lightBlink,
      lightOn,
      false,
      kph,
      fastAcceleration,
      false,
      false
    ];
    int commandByte = 0;
    for (int i = 0; i < bits.length; i++) {
      if (bits[i]) {
        commandByte |= 1 << i;
      }
    }
    return commandByte;
  }

  int startCommandByte() {
    List<bool> bits = [
      true, // powerOn
      true, // lightBlink
      true, // lightOn
      true, // (previously false)
      true, // kph
      true, // fastAcceleration
      true, // (previously false)
      true // (previously false)
    ];
    int commandByte = 0;
    for (int i = 0; i < bits.length; i++) {
      if (bits[i]) {
        commandByte |= 1 << i;
      }
    }

    return commandByte;
  }

  int stopCommandByte() {
    List<bool> bits = [
      false, //power on
      false, //light blink
      false, //light on
      false,
      kph,
      fastAcceleration,
      false,
      false
    ];
    int commandByte = 0;
    for (int i = 0; i < bits.length; i++) {
      if (bits[i]) {
        commandByte |= 1 << i;
      }
    }
    return commandByte;
  }

  int startCommand(
      bool fastAcceleration, bool kph, bool lightOn, bool lightBlink) {
    return startCommandByte();
    //genCommandByte(fastAcceleration, kph, lightOn, lightBlink, true);
  }

  int stopCommand(bool lightBlink) {
    return stopCommandByte();
    // genCommandByte(false, true, false, lightBlink, false);
  }

  String calculateCrc8Maxim(Uint8List data) {
    final crc8 = Crc8Maxim();
    return crc8.convert(data).toRadixString(16);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              if (widget.services.isEmpty)
                Center(
                  child: Text(
                    'No services available.',
                    style: TextStyle(color: Colors.grey, fontSize: 18),
                  ),
                )
              else if (widget.connectionState ==
                  BluetoothConnectionState.connected) ...[
                SwitchListTile(
                  title: Text('Fast Acceleration'),
                  value: fastAcceleration,
                  onChanged: (bool value) {
                    setState(() {
                      fastAcceleration = value;
                    });
                  },
                ),
                SwitchListTile(
                  title: Text('KPH'),
                  value: kph,
                  onChanged: (bool value) {
                    setState(() {
                      kph = value;
                    });
                  },
                ),
                SwitchListTile(
                  title: Text('Light On'),
                  value: lightOn,
                  onChanged: (bool value) {
                    setState(() {
                      lightOn = value;
                    });
                  },
                ),
                SwitchListTile(
                  title: Text('Light Blink'),
                  value: lightBlink,
                  onChanged: (bool value) {
                    setState(() {
                      lightBlink = value;
                    });
                  },
                ),
                for (var service in widget.services)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: service.characteristics.map((characteristic) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Characteristic: ${characteristic.uuid.str.toString()}',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 4),
                          ),
                          // Text(
                          //   'Properties: ${characteristic.properties..toString()}',
                          //   style: TextStyle(
                          //       fontWeight: FontWeight.normal, fontSize: 4),
                          // ),
                          Row(
                            children: [
                              if (characteristic.properties.read)
                                IconButton(
                                  icon: Icon(Icons.read_more),
                                  onPressed: () async {
                                    try {
                                      var value = await characteristic.read();
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: Text(
                                              'Read Value: ${value.toString()}'),
                                        ),
                                      );
                                    } catch (e) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: Text(
                                              'Error reading characteristic: $e'),
                                        ),
                                      );
                                    }
                                  },
                                ),
                              if (characteristic.properties.write ||
                                  characteristic
                                      .properties.writeWithoutResponse ||
                                  characteristic
                                      .properties.authenticatedSignedWrites)
                                IconButton(
                                  icon: Icon(Icons.play_arrow),
                                  onPressed: () async {
                                    try {
                                      int commandByte = startCommand(
                                          fastAcceleration,
                                          kph,
                                          lightOn,
                                          lightBlink);
                                      sendCommand(
                                          characteristic, commandByte, 20);
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: Text('Write successful'),
                                        ),
                                      );
                                    } catch (e) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: Text('Write failed: $e'),
                                        ),
                                      );
                                    }
                                  },
                                ),
                              if (characteristic.properties.write ||
                                  characteristic
                                      .properties.writeWithoutResponse ||
                                  characteristic
                                      .properties.authenticatedSignedWrites)
                                IconButton(
                                  icon: Icon(Icons.stop),
                                  onPressed: () {
                                    int commandByte = stopCommand(lightBlink);
                                    sendCommand(
                                        characteristic, commandByte, 20);
                                  },
                                ),
                            ],
                          ),
                          Divider(),
                        ],
                      );
                    }).toList(),
                  ),
              ]
              // else
              //   Center(
              //     child: Text(
              //       'No active connection. Please connect to a device.',
              //       style: TextStyle(fontSize: 16, color: Colors.grey),
              //       textAlign: TextAlign.center,
              //     ),
              //   ),
            ],
          ),
        ),
      ),
    );
  }
}
////////
///
///
///
///
///
///

// class DrawerContent extends StatefulWidget {
//   final BluetoothConnectionState connectionState;
//   final List<BluetoothService> services;

//   const DrawerContent({
//     super.key,
//     required this.connectionState,
//     required this.services,
//   });

//   @override
//   State<DrawerContent> createState() => _DrawerContentState();
// }

// class _DrawerContentState extends State<DrawerContent> {
//   bool fastAcceleration = false;
//   bool kph = true;
//   bool lightOn = false;
//   bool lightBlink = false;

//   void sendCommand(int commandByte, int speed) {
//     // Combine commands, calculate CRC, and transmit to ESC
//     Uint8List buf = Uint8List(6);
//     buf[0] = 0xA6;
//     buf[1] = 0x12;
//     buf[2] = 0x02;
//     buf[3] = commandByte;
//     buf[4] = speed;
//     buf[5] = calculateCrc8Maxim(buf.sublist(0, 5));
//     // Send command (this is a placeholder, replace with actual sending logic)
//     print('Command Byte: $commandByte, Buffer: $buf');
//   }

//   int genCommandByte(bool fastAcceleration, bool kph, bool lightOn,
//       bool lightBlink, bool powerOn) {
//     List<bool> bits = [
//       powerOn,
//       lightBlink,
//       lightOn,
//       false,
//       kph,
//       fastAcceleration,
//       false,
//       false
//     ];
//     int commandByte = 0;
//     for (int i = 0; i < bits.length; i++) {
//       if (bits[i]) {
//         commandByte |= 1 << i;
//       }
//     }
//     return commandByte;
//   }

//   int startCommand(
//       bool fastAcceleration, bool kph, bool lightOn, bool lightBlink) {
//     return genCommandByte(fastAcceleration, kph, lightOn, lightBlink, true);
//   }

//   int stopCommand(bool lightBlink) {
//     return genCommandByte(false, true, false, lightBlink, false);
//   }

//   int calculateCrc8Maxim(Uint8List data) {
//     final crc8 = Crc8Maxim();
//     return crc8.convert(data).toBigInt().toInt();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return widget.connectionState == BluetoothConnectionState.connected
//         ? ListView(
//             padding: EdgeInsets.all(16.0),
//             children: [
//               Text(
//                 'Bluetooth Services',
//                 style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//               ),
//               SizedBox(height: 10),
//               if (widget.services.isEmpty)
//                 Text(
//                   'No services available.',
//                   style: TextStyle(color: Colors.grey),
//                 ),
//               for (var service in widget.services)
//                 Card(
//                   child: ExpansionTile(
//                     title: Text(
//                       'Service: ${service.uuid.toString().substring(0, 8)}',
//                       style: TextStyle(fontWeight: FontWeight.bold),
//                     ),
//                     children: service.characteristics.map((characteristic) {
//                       return ListTile(
//                         title: Text(
//                           'Characteristic: ${characteristic.uuid.toString().substring(0, 8)}',
//                         ),
//                         subtitle: Text(
//                             'Properties: ${characteristic.properties.toString()}'),
//                         trailing: ElevatedButton(
//                           onPressed: () async {
//                             if (characteristic.properties.read) {
//                               try {
//                                 var value = await characteristic.read();
//                                 ScaffoldMessenger.of(context).showSnackBar(
//                                   SnackBar(
//                                     content:
//                                         Text('Read Value: ${value.toString()}'),
//                                   ),
//                                 );
//                               } catch (e) {
//                                 ScaffoldMessenger.of(context).showSnackBar(
//                                   SnackBar(
//                                     content: Text(
//                                         'Error reading characteristic: $e'),
//                                   ),
//                                 );
//                               }
//                             } else {
//                               ScaffoldMessenger.of(context).showSnackBar(
//                                 SnackBar(
//                                   content: Text(
//                                       'This characteristic does not support reading.'),
//                                 ),
//                               );
//                             }
//                           },
//                           child: Text('Read'),
//                         ),
//                       );
//                     }).toList(),
//                   ),
//                 ),
//             ],
//           )
//         : Center(
//             child: Text(
//               'No Bluetooth connection detected.',
//               style: TextStyle(color: Colors.red, fontSize: 16),
//             ),
//           );
//   }
// }
