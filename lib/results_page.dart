import 'package:flutter/material.dart';
import 'package:flutter_page_transition/flutter_page_transition.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tft_gg/info.dart';
import 'package:tft_gg/main.dart';

class ResultsPage extends StatefulWidget {

  Info playerInfo;
  ResultsPage({this.playerInfo});

  @override
  _ResultsPageState createState() => _ResultsPageState();
}

class _ResultsPageState extends State<ResultsPage> {

  var bannerAd;

  @override
  void initState() {
    super.initState();
    final adState = context.read(adStateProvider);
    bannerAd = BannerAd(
        size: AdSize.largeBanner,
        adUnitId: adState.bannerAdUnitId,
        listener: adState.listener,
        request: AdRequest()
    )..load();
  }

  @override
  void didChangeDependencies() {
    final adState = context.read(adStateProvider);
    adState.initialization.then((value){
      bannerAd = BannerAd(
          size: AdSize.largeBanner,
          adUnitId: adState.bannerAdUnitId,
          listener: adState.listener,
          request: AdRequest()
      )..load();
    });
  }


  @override
  Widget build(BuildContext context) {

    double windowWidth = MediaQuery.of(context).size.width;
    double windowHeight = MediaQuery.of(context).size.height;
    return WillPopScope(
      onWillPop: () async{
        Navigator.pushReplacement(context, PageTransition(child: SearchPage(), type: PageTransitionType.rippleLeftDown));

        return false;
      },
      child: Scaffold(
        body: Container(
          width: windowWidth,
          height: windowHeight,
          padding: EdgeInsets.symmetric(horizontal: windowWidth * 0.05, vertical: windowHeight * 0.03),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xffF00014), Color(0xff6200EE)]
            )
          ),
          child: ListView(
            children: [
              //------------------------ Summoner heading
              Container(
                width: windowWidth,
                margin: EdgeInsets.only(top: windowHeight * 0.03, bottom: windowHeight * 0.02),
                padding: EdgeInsets.symmetric(horizontal: windowWidth * 0.02),
                child: Text(
                    widget.playerInfo.summonerName,
                    style: GoogleFonts.spaceGrotesk(fontSize: 32, color: Colors.white, fontWeight: FontWeight.w600),
                    textAlign: TextAlign.start,
                ),
              ),
              //------------------------ level and rank
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: windowWidth * 0.3,
                    padding: EdgeInsets.only(left: windowWidth * 0.02),
                    child: Text('lvl ${widget.playerInfo.summonerLevel}', style: GoogleFonts.spaceGrotesk(fontSize: 24, color: Colors.white),),
                  ),
                  Container(
                    width: windowWidth * 0.5,
                    padding: EdgeInsets.only(right: windowWidth * 0.02),
                    child: Text(widget.playerInfo.league, style: GoogleFonts.spaceGrotesk(fontSize: 24, color: Colors.white), textAlign: TextAlign.end,),
                  ),
                ],
              ),
              //------------------------ general info
              Container(
                width: windowWidth,
                height: windowHeight * 0.35,
                margin: EdgeInsets.only(top: windowHeight * 0.05),
                decoration: BoxDecoration(
                  color: Color(0xff2f2d2d),
                  borderRadius: BorderRadius.circular(20)
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    //------------------------ players eliminated
                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: windowWidth * 0.4,
                            child: Text('Players eliminated', style: GoogleFonts.spaceGrotesk(fontSize: 20, color: Colors.white), textAlign: TextAlign.center,),
                          ),
                          Container(
                            width: windowWidth * 0.4,
                            child: Text('${widget.playerInfo.playersEliminated}', style: GoogleFonts.spaceGrotesk(fontSize: 20, color: Colors.white), textAlign: TextAlign.center,),
                          )
                        ],
                      ),
                    ),
                    //------------------------ total dmg to champions
                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: windowWidth * 0.4,
                            child: Text('Total dmg to champions', style: GoogleFonts.spaceGrotesk(fontSize: 20, color: Colors.white), textAlign: TextAlign.center,),
                          ),
                          Container(
                            width: windowWidth * 0.4,
                            child: Text('${widget.playerInfo.dmgToPlayers}', style: GoogleFonts.spaceGrotesk(fontSize: 20, color: Colors.white), textAlign: TextAlign.center,),
                          )
                        ],
                      ),
                    ),
                    //------------------------  most used legend
                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: windowWidth * 0.4,
                            child: Text('Most used pet', style: GoogleFonts.spaceGrotesk(fontSize: 20, color: Colors.white), textAlign: TextAlign.center,),
                          ),
                          Container(
                            width: windowWidth * 0.4,
                            child: Text('${widget.playerInfo.companion}', style: GoogleFonts.spaceGrotesk(fontSize: 20, color: Colors.white), textAlign: TextAlign.center,),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
              Container(
                width: windowWidth,
                height: windowHeight * 0.07,
                margin: EdgeInsets.only(top: windowHeight * 0.03),
                child: AdWidget(ad: bannerAd as BannerAd,),
              ),
              //------------------------ placements
              Container(
                width: windowWidth,
                height: windowHeight * 0.25,
                margin: EdgeInsets.only(top: windowHeight * 0.03),
                decoration: BoxDecoration(
                    color: Color(0xff2f2d2d),
                    borderRadius: BorderRadius.circular(20)
                ),
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    Container(
                      width: windowWidth * 1.7,
                      child: Column(
                        children: [
                          //------------------------ header
                          Container(
                            width: windowWidth * 1.67,
                            padding: EdgeInsets.only(top: windowHeight * 0.04, left: windowWidth * 0.08, bottom: windowHeight * 0.02),
                            child: Text('Placements', style: GoogleFonts.spaceGrotesk(fontSize: 24, color: Colors.white, fontWeight: FontWeight.w600),),
                          ),
                          //------------------------ placements percentages
                          Container(
                            padding: EdgeInsets.only(left: windowWidth * 0.1),
                            child: Row(
                              children: [
                                Column(
                                  children: [
                                    Container(
                                      width: windowWidth * 0.2,
                                      child: Text('1', style: GoogleFonts.spaceGrotesk(fontSize: 38, color: Colors.white, fontWeight: FontWeight.w600),),
                                    ),
                                    Container(
                                      width: windowWidth * 0.2,
                                      margin: EdgeInsets.only(top: windowHeight * 0.02),
                                      child: Text('${widget.playerInfo.placements[1] * 5}%', style: GoogleFonts.spaceGrotesk(fontSize: 24, color: Color(0xffF06400), fontWeight: FontWeight.w600),),
                                    ),
                                  ],
                                ),
                                Column(
                                  children: [
                                    Container(
                                      width: windowWidth * 0.2,
                                      child: Text('2', style: GoogleFonts.spaceGrotesk(fontSize: 38, color: Colors.white, fontWeight: FontWeight.w600),),
                                    ),
                                    Container(
                                      width: windowWidth * 0.2,
                                      margin: EdgeInsets.only(top: windowHeight * 0.02),
                                      child: Text('${widget.playerInfo.placements[2] * 5}%', style: GoogleFonts.spaceGrotesk(fontSize: 24, color: Color(0xffF06400), fontWeight: FontWeight.w600),),
                                    ),
                                  ],
                                ),
                                Column(
                                  children: [
                                    Container(
                                      width: windowWidth * 0.2,
                                      child: Text('3', style: GoogleFonts.spaceGrotesk(fontSize: 38, color: Colors.white, fontWeight: FontWeight.w600),),
                                    ),
                                    Container(
                                      width: windowWidth * 0.2,
                                      margin: EdgeInsets.only(top: windowHeight * 0.02),
                                      child: Text('${widget.playerInfo.placements[3] * 5}%', style: GoogleFonts.spaceGrotesk(fontSize: 24, color: Color(0xffF06400), fontWeight: FontWeight.w600),),
                                    ),
                                  ],
                                ),
                                Column(
                                  children: [
                                    Container(
                                      width: windowWidth * 0.2,
                                      child: Text('4', style: GoogleFonts.spaceGrotesk(fontSize: 38, color: Colors.white, fontWeight: FontWeight.w600),),
                                    ),
                                    Container(
                                      width: windowWidth * 0.2,
                                      margin: EdgeInsets.only(top: windowHeight * 0.02),
                                      child: Text('${widget.playerInfo.placements[4] * 5}%', style: GoogleFonts.spaceGrotesk(fontSize: 24, color: Color(0xffF06400), fontWeight: FontWeight.w600),),
                                    ),
                                  ],
                                ),
                                Column(
                                  children: [
                                    Container(
                                      width: windowWidth * 0.2,
                                      child: Text('5', style: GoogleFonts.spaceGrotesk(fontSize: 38, color: Colors.white, fontWeight: FontWeight.w600),),
                                    ),
                                    Container(
                                      width: windowWidth * 0.2,
                                      margin: EdgeInsets.only(top: windowHeight * 0.02),
                                      child: Text('${widget.playerInfo.placements[5] * 5}%', style: GoogleFonts.spaceGrotesk(fontSize: 24, color: Color(0xffF06400), fontWeight: FontWeight.w600),),
                                    ),
                                  ],
                                ),
                                Column(
                                  children: [
                                    Container(
                                      width: windowWidth * 0.2,
                                      child: Text('6', style: GoogleFonts.spaceGrotesk(fontSize: 38, color: Colors.white, fontWeight: FontWeight.w600),),
                                    ),
                                    Container(
                                      width: windowWidth * 0.2,
                                      margin: EdgeInsets.only(top: windowHeight * 0.02),
                                      child: Text('${widget.playerInfo.placements[6] * 5}%', style: GoogleFonts.spaceGrotesk(fontSize: 24, color: Color(0xffF06400), fontWeight: FontWeight.w600),),
                                    ),
                                  ],
                                ),
                                Column(
                                  children: [
                                    Container(
                                      width: windowWidth * 0.2,
                                      child: Text('7', style: GoogleFonts.spaceGrotesk(fontSize: 38, color: Colors.white, fontWeight: FontWeight.w600),),
                                    ),
                                    Container(
                                      width: windowWidth * 0.2,
                                      margin: EdgeInsets.only(top: windowHeight * 0.02),
                                      child: Text('${widget.playerInfo.placements[7] * 5}%', style: GoogleFonts.spaceGrotesk(fontSize: 24, color: Color(0xffF06400), fontWeight: FontWeight.w600),),
                                    ),
                                  ],
                                ),
                                Column(
                                  children: [
                                    Container(
                                      width: windowWidth * 0.2,
                                      child: Text('8', style: GoogleFonts.spaceGrotesk(fontSize: 38, color: Colors.white, fontWeight: FontWeight.w600),),
                                    ),
                                    Container(
                                      width: windowWidth * 0.2,
                                      margin: EdgeInsets.only(top: windowHeight * 0.02),
                                      child: Text('${widget.playerInfo.placements[8] * 5}%', style: GoogleFonts.spaceGrotesk(fontSize: 24, color: Color(0xffF06400), fontWeight: FontWeight.w600),),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ]
                ),
              ),
              //------------------------ most used traits and units
              Container(
                width: windowWidth,
                height: windowHeight * 0.5,
                margin: EdgeInsets.only(top: windowHeight * 0.03),
                decoration: BoxDecoration(
                    color: Color(0xff2f2d2d),
                    borderRadius: BorderRadius.circular(20)
                ),
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    //------------------------ traits
                    Column(
                      children: [
                        Container(
                          width: windowWidth * 0.55,
                          margin: EdgeInsets.only(top: windowHeight * 0.08, left: windowWidth * 0.1),
                          child: Text('Most used traits', style: GoogleFonts.spaceGrotesk(fontSize: 28, color: Colors.white, fontWeight: FontWeight.w500)),
                        ),
                        Container(
                          width: windowWidth * 0.55,
                          margin: EdgeInsets.only(top: windowHeight * 0.07, left: windowWidth * 0.1),
                          child: Column(
                            children: [
                              Container(
                                  width: windowWidth,
                                  child: Text('1. ${widget.playerInfo.traits.keys.elementAt(0)}', style: GoogleFonts.spaceGrotesk(fontSize: 22, color: Color(0xffEBC747)), textAlign: TextAlign.start,)
                              ),
                              Container(
                                  width: windowWidth,
                                  margin: EdgeInsets.only(top: windowHeight * 0.02),
                                  child: Text('2. ${widget.playerInfo.traits.keys.elementAt(1)}', style: GoogleFonts.spaceGrotesk(fontSize: 22, color: Color(0xffBAD6D9)),)
                              ),
                              Container(
                                  width: windowWidth,
                                  margin: EdgeInsets.only(top: windowHeight * 0.02),
                                  child: Text('3. ${widget.playerInfo.traits.keys.elementAt(2)}', style: GoogleFonts.spaceGrotesk(fontSize: 22, color: Color(0xffBA7348)),)
                              ),
                              Container(
                                  width: windowWidth,
                                  margin: EdgeInsets.only(top: windowHeight * 0.02),
                                  child: Text('4. ${widget.playerInfo.traits.keys.elementAt(3)}', style: GoogleFonts.spaceGrotesk(fontSize: 22, color: Colors.white),)
                              ),
                              Container(
                                  width: windowWidth,
                                  margin: EdgeInsets.only(top: windowHeight * 0.02),
                                  child: Text('5. ${widget.playerInfo.traits.keys.elementAt(4)}', style: GoogleFonts.spaceGrotesk(fontSize: 22, color: Colors.white),)
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                    //------------------------ units
                    Column(
                      children: [
                        Container(
                          width: windowWidth * 0.55,
                          margin: EdgeInsets.only(top: windowHeight * 0.08, left: windowWidth * 0.1),
                          child: Text('Most used units', style: GoogleFonts.spaceGrotesk(fontSize: 28, color: Colors.white, fontWeight: FontWeight.w500)),
                        ),
                        Container(
                          width: windowWidth * 0.55,
                          margin: EdgeInsets.only(top: windowHeight * 0.07, left: windowWidth * 0.1),
                          child: Column(
                            children: [
                              Container(
                                  width: windowWidth,
                                  child: Text('1. ${widget.playerInfo.units.keys.elementAt(0)}', style: GoogleFonts.spaceGrotesk(fontSize: 22, color: Color(0xffEBC747)), textAlign: TextAlign.start,)
                              ),
                              Container(
                                  width: windowWidth,
                                  margin: EdgeInsets.only(top: windowHeight * 0.02),
                                  child: Text('2. ${widget.playerInfo.units.keys.elementAt(1)}', style: GoogleFonts.spaceGrotesk(fontSize: 22, color: Color(0xffBAD6D9)),)
                              ),
                              Container(
                                  width: windowWidth,
                                  margin: EdgeInsets.only(top: windowHeight * 0.02),
                                  child: Text('3. ${widget.playerInfo.units.keys.elementAt(2)}', style: GoogleFonts.spaceGrotesk(fontSize: 22, color: Color(0xffBA7348)),)
                              ),
                              Container(
                                  width: windowWidth,
                                  margin: EdgeInsets.only(top: windowHeight * 0.02),
                                  child: Text('4. ${widget.playerInfo.units.keys.elementAt(3)}', style: GoogleFonts.spaceGrotesk(fontSize: 22, color: Colors.white),)
                              ),
                              Container(
                                  width: windowWidth,
                                  margin: EdgeInsets.only(top: windowHeight * 0.02),
                                  child: Text('5. ${widget.playerInfo.units.keys.elementAt(4)}', style: GoogleFonts.spaceGrotesk(fontSize: 22, color: Colors.white),)
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
