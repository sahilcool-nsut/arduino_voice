import 'package:flutter/material.dart';
import 'home_page.dart';
import 'package:assets_audio_player/assets_audio_player.dart';


class LandingPage extends StatefulWidget {
  static String id = 'home_screen';
  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {

  //var firstColor = Color(0xffdecdc3), secondColor = Color(0xffea5455);
  //var firstColor = Color(0xFF07689f),secondColor = Color(0xffa2d5f2);
  var firstColor = Color(0xFFeb8f8f),secondColor = Color(0xFFec0101);
  var code ;





  @override

  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image:AssetImage('images/background.jpg'),
                fit: BoxFit.cover
            )
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Flexible(
              child:Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 40.0,
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 50.0,left:10.0),
                      child: Container(

                        child: Text(
                            'Crazy LED',
                            style: TextStyle(
                              fontFamily: 'Montserrat',
                              color: Colors.white,
                              fontSize: 50.0,
                            )
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 10.0,left:10.0),
                      child: Text(
                          'Lighting for every mood.',
                          style: TextStyle(
                            fontFamily: 'Montserrat',
                            color: Colors.white,
                            fontSize:20.0,
                          )
                      ),
                    )
                  ]
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(bottom:30.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: Card(
                        margin: EdgeInsets.symmetric(vertical: 0.0,horizontal: 25.0),
                        color: Colors.red,
                        child: FlatButton(
                          onPressed: () {

                           // if(assetsAudioPlayer.isPlaying.value) {
                           //
                           //     assetsAudioPlayer.stop();
                           //
                           //
                           // }
                           // else
                           //   {
                           //
                           //     // setState(() {
                           //     //   assetsAudioPlayer.play();
                           //     // });
                           //     assetsAudioPlayer.open(
                           //       Audio("audio/song0.mp3")
                           //
                           //     );
                           // }
                                // Audio("audio/song1.mp3")

                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => Home()),
                            );
                          },
                          child: ListTile(
                            title: Center(
                              child: Text(
                                "Connect Device",
                                style: TextStyle(
                                  fontFamily: 'Montserrat',
                                  fontSize: 17.0,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),

                    SizedBox(
                      height: 15.0,
                    ),
                  ],
                ),
              ),
            )
          ],

        ),
      ),
    );
  }
}