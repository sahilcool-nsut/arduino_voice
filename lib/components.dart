import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

final codesExplainedStyle=GoogleFonts.karla(
  textStyle: TextStyle(
    color: Colors.black,
    fontWeight: FontWeight.bold,
    fontSize: 22,
  ),
);

final keyOfCodesStyle=  GoogleFonts.karla(
  textStyle: TextStyle(
    color: Colors.black87,
    fontWeight: FontWeight.w600,
    fontSize: 15.5,
  ),
);
final rainbowMode=  GoogleFonts.karla(
  textStyle: TextStyle(
    color: Colors.pink,
    fontWeight: FontWeight.w600,
    fontSize: 15.5,
  ),
);

final discoMode=  GoogleFonts.karla(
  textStyle: TextStyle(
    color: Colors.blueAccent,
    fontWeight: FontWeight.w600,
    fontSize: 15.5,
  ),
);
final supaFire=  GoogleFonts.karla(
  textStyle: TextStyle(
    color: Colors.red,
    fontWeight: FontWeight.w600,
    fontSize: 15.5,
  ),
);
final chasingMode=  GoogleFonts.karla(
  textStyle: TextStyle(
    color: Colors.lightBlueAccent,
    fontWeight: FontWeight.w600,
    fontSize: 15.5,
  ),
);
final icyCold=  GoogleFonts.karla(
  textStyle: TextStyle(
    color: Colors.indigo,
    fontWeight: FontWeight.w600,
    fontSize: 15.5,
  ),
);
final danceMode=  GoogleFonts.karla(
  textStyle: TextStyle(
    color: Colors.deepPurple,
    fontWeight: FontWeight.w600,
    fontSize: 15.5,
  ),
);


class keyOfCodesComponent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      content: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(
              left: 0.0, top: 10.0, right: 10.0, bottom: 0.0),
          child: Container(
            child: Column(
              children: [
                Center(
                    child: Text(
                      'LED Modes Available',
                      style: codesExplainedStyle,
                    )),
                Divider(
                  color: Colors.black,
                  height: 20,
                  thickness: 3,
                  indent: 10,
                  endIndent: 10,
                ),
                NotationText(text: 'Rainbow ', style:rainbowMode,),
                NotationText(text: 'Disco ', style: discoMode,),
                NotationText(text: 'Chasing ', style: chasingMode,),
                NotationText(text: 'Dance With Me ', style: danceMode,),
                NotationText(text: 'Supa Hot Fire ', style: supaFire,),
                NotationText(text: 'Icy Cold ', style: icyCold,),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


class NotationText extends StatelessWidget {
  final String text;
  final TextStyle style;

  NotationText({@required this.text, @required this.style});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(
                Icons.adjust,
                color: Colors.black,
                size: 20,
              ),
            ),
            Text(
              text,
              style: this.style,
            ),
            Text('Mode', style: keyOfCodesStyle,)
          ],
        ),

      ],
    );
  }
}
