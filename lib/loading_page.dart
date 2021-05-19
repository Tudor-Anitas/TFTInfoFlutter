import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';

class LoadingPage extends StatefulWidget {
  @override
  _LoadingPageState createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> with TickerProviderStateMixin{
  @override
  Widget build(BuildContext context) {

    double windowWidth = MediaQuery.of(context).size.width;
    double windowHeight = MediaQuery.of(context).size.height;
    
    return Scaffold(
      body: Container(
        width: windowWidth,
        height: windowHeight,
        decoration: BoxDecoration(
          // gradient: LinearGradient(
          //   begin: Alignment.topLeft,
          //   end: Alignment.bottomRight,
          //   colors: [
          //     Colors.deepOrange,
          //     Colors.pink
          //   ]
          // )
          color: Color(0xff2d2d2d)
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(),
            SpinKitWave(
              color: Colors.white,
              size: 50.0,
              controller: AnimationController(vsync: this, duration: Duration(milliseconds: 1500)),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: windowHeight * 0.1,
                  child: DefaultTextStyle(
                    style: GoogleFonts.spaceGrotesk(fontSize: 28, color: Colors.white),
                    child: AnimatedTextKit(
                      repeatForever: true,
                      animatedTexts: [
                        FadeAnimatedText('Searching for info'),
                        FadeAnimatedText('Collecting pets'),
                        FadeAnimatedText('Slaying enemies')
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
