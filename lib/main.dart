import 'dart:convert';
import 'dart:ui';
import 'package:intl/intl.dart';

import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

String mainFont = 'sg';

ScrollController todayListCon = ScrollController();

String cityName = 'Benghazi';

int i = 0;

var citys = [
  'Tripoli',
  'Benghazi',
  'Khoms',
  'Tobruk',
  'Misratah',
  'Sabha',
  'Susah, Libya',
  'Al Zawiyah',
  'Shahat',
  'Ajdabiyah',
  'Zliten',
  'Zintan',
  'Janzur, Libya',
  'Ubari'
];

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  cityName = prefs.getString('cityName') ?? 'Benghazi';
  isDay = prefs.getBool('isDay') ?? true;
  runApp(const MaterialApp(
    home: Home(),
    debugShowCheckedModeBanner: false,
  ));
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

bool isDay = true;

Future getData(city) async {
  final params = {
    'days': '5',
    'key': 'c066e67c2da8478f93b175455231601',
    'q': city,
    'aqi': 'yes'
  };

  final uri = Uri.https('api.weatherapi.com', '/v1/forecast.json', params);

  SharedPreferences prefs = await SharedPreferences.getInstance();

  var res = await http.get(uri);
  var json = await jsonDecode(res.body);
  // if (json['current']['is_day'] == 0) {
  if (int.parse(DateFormat('H').format(DateTime.now())) >= 19) {
    isDay = false;
  } else {
    isDay = true;
  }
  prefs.setBool('isDay', isDay);

  return json;
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    try {
      return FutureBuilder(
        builder: (context, snapshot) {
          double dw = MediaQuery.of(context).size.width;
          double dh = MediaQuery.of(context).size.height;
          double top = MediaQuery.of(context).padding.top;
          // double btm = MediaQuery.of(context).padding.bottom;
          print(snapshot.data);
          return Scaffold(
            body: Stack(children: [
              Container(
                height: dh,
                width: dw,
                color: isDay ? Colors.white : Colors.black,
              ),
              Stack(
                children: [
                  Positioned(
                    // ellipse45AvZ (75:954)
                    left: isDay ? 100 : -180,
                    top: isDay ? 186 : 44,
                    child: ImageFiltered(
                      imageFilter: ImageFilter.blur(
                        sigmaX: 100,
                        sigmaY: 100,
                      ),
                      child: Align(
                        child: SizedBox(
                          width: 480,
                          height: 480,
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(240),
                              gradient: RadialGradient(
                                center: const Alignment(-0, -0.746),
                                radius: 0.95,
                                colors: isDay
                                    ? [
                                        const Color(0x99eb20d7),
                                        const Color(0x99eb5c20),
                                        const Color(0x99ffd645),
                                        const Color(0x99090315)
                                      ]
                                    : [
                                        const Color(0x803B185F),
                                        const Color(0x80C060A1),
                                        const Color(0x8000005C),
                                        const Color(0x00090315)
                                      ],
                                stops: const [0, 0.286, 0.635, 1],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Container(
                width: dw,
                height: dh,
                padding: EdgeInsets.fromLTRB(0, top, 0, 0),
                child: (snapshot.connectionState == ConnectionState.done)
                    ? ScrollConfiguration(
                        behavior: NoGlowListView(),
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                width: dw,
                                height: 70,
                                padding:
                                    const EdgeInsets.fromLTRB(20, 20, 0, 0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        _showSimpleDialog();
                                      },
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            '${snapshot.data['location']['name']}',
                                            style: TextStyle(
                                                fontSize: 24,
                                                fontFamily: mainFont,
                                                color: isDay
                                                    ? const Color(0xff302745)
                                                    : Colors.white,
                                                fontWeight: FontWeight.w700),
                                          ),
                                          Text(
                                            ' ${snapshot.data['location']['country']}',
                                            style: TextStyle(
                                                fontSize: 12,
                                                fontFamily: mainFont,
                                                color: isDay
                                                    ? const Color(0xcc302745)
                                                    : Colors.white,
                                                fontWeight: FontWeight.w700),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                width: dw,
                                height: dw < dh ? 450 : 600,
                                color: Colors.transparent,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      width: dw / 4,
                                      height: dw / 4,
                                      color: Colors.transparent,
                                      child: weatherIcon(
                                          (snapshot.data['current']['condition']
                                                  ['text'])
                                              .toString()),
                                    ),
                                    Container(
                                      width: dw - 50,
                                      height: dw < dh ? 150 : 300,
                                      color: Colors.transparent,
                                      child: Center(
                                        child: Text(
                                          ' ${snapshot.data['current']['temp_c']}°',
                                          style: TextStyle(
                                            fontFamily: mainFont,
                                            fontWeight: FontWeight.w400,
                                            fontSize: dw / 4,
                                            color: isDay
                                                ? const Color(0xff302745)
                                                : Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      width: dw - 50,
                                      height: 30,
                                      color: Colors.transparent,
                                      child: Center(
                                        child: Text(
                                          '${snapshot.data['current']['condition']['text']}',
                                          style: TextStyle(
                                            fontFamily: mainFont,
                                            fontWeight: FontWeight.w700,
                                            fontSize: 24,
                                            color: isDay
                                                ? const Color(0xff302745)
                                                : Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                width: dw,
                                height: 70,
                                color: Colors.transparent,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      height: 30,
                                      width: dw,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          SizedBox(
                                              width: dw * 0.3,
                                              child: Center(
                                                  child: Text(
                                                'Humidity',
                                                style: TextStyle(
                                                  fontFamily: mainFont,
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 18,
                                                  color: isDay
                                                      ? const Color(0xcc302745)
                                                      : Colors.white,
                                                ),
                                              ))),
                                          SizedBox(
                                              width: dw * 0.35,
                                              child: Center(
                                                  child: Text('Wind',
                                                      style: TextStyle(
                                                        fontFamily: mainFont,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontSize: 18,
                                                        color: isDay
                                                            ? const Color(
                                                                0xcc302745)
                                                            : Colors.white,
                                                      )))),
                                          SizedBox(
                                              width: dw * 0.35,
                                              child: Center(
                                                  child: Text('Visiblity',
                                                      style: TextStyle(
                                                        fontFamily: mainFont,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontSize: 18,
                                                        color: isDay
                                                            ? const Color(
                                                                0xcc302745)
                                                            : Colors.white,
                                                      )))),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: 40,
                                      width: dw,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          SizedBox(
                                              width: dw * 0.3,
                                              child: Center(
                                                  child: Text(
                                                      '${snapshot.data['current']['humidity']} %',
                                                      style: TextStyle(
                                                        fontFamily: mainFont,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontSize: 24,
                                                        color: isDay
                                                            ? const Color(
                                                                0xff302745)
                                                            : Colors.white,
                                                      )))),
                                          SizedBox(
                                              width: dw * 0.35,
                                              child: Center(
                                                  child: Text(
                                                      '${snapshot.data['current']['wind_kph']} km/h',
                                                      style: TextStyle(
                                                        fontFamily: mainFont,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontSize: 24,
                                                        color: isDay
                                                            ? const Color(
                                                                0xff302745)
                                                            : Colors.white,
                                                      )))),
                                          SizedBox(
                                              width: dw * 0.35,
                                              child: Center(
                                                  child: Text(
                                                      '${snapshot.data['current']['vis_km']} km',
                                                      style: TextStyle(
                                                        fontFamily: mainFont,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontSize: 24,
                                                        color: isDay
                                                            ? const Color(
                                                                0xff302745)
                                                            : Colors.white,
                                                      )))),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.all(15),
                                width: dw,
                                height: 3,
                                color: isDay
                                    ? const Color(0x33302745)
                                    : Colors.white,
                              ),
                              Container(
                                width: dw,
                                color: Colors.transparent,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                          width: 120,
                                          child: Center(
                                            child: Text(
                                              'Today',
                                              style: TextStyle(
                                                  fontSize: 24,
                                                  fontFamily: mainFont,
                                                  color: isDay
                                                      ? const Color(0xff302745)
                                                      : Colors.white,
                                                  fontWeight: FontWeight.w700),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 120,
                                          child: Center(
                                            child: Text(
                                              '${DateFormat('EE').format(DateTime.now())}, ${DateFormat('dd LLL').format(DateTime.now())}',
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  fontFamily: mainFont,
                                                  color: isDay
                                                      ? const Color(0xff302745)
                                                      : Colors.white,
                                                  fontWeight: FontWeight.w400),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    SizedBox(
                                      width: dw,
                                      height: 110,
                                      child: ScrollConfiguration(
                                        behavior: NoGlowListView(),
                                        child: ListView(
                                            controller: todayListCon,
                                            scrollDirection: Axis.horizontal,
                                            children: [
                                              for (int i = 0, j = 00;
                                                  j < 24;
                                                  i++, j++)
                                                if (int.parse(DateFormat('H')
                                                        .format(
                                                            DateTime.now())) <=
                                                    j)
                                                  SizedBox(
                                                      width: 100,
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: [
                                                          Center(
                                                              child: Text(
                                                            int.parse(DateFormat(
                                                                            'H')
                                                                        .format(
                                                                            DateTime.now())) ==
                                                                    j
                                                                ? 'Now '
                                                                : '$j:00',
                                                            style: TextStyle(
                                                                fontFamily:
                                                                    mainFont,
                                                                fontSize: 18,
                                                                color: isDay
                                                                    ? const Color(
                                                                        0xcc302745)
                                                                    : Colors
                                                                        .white,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400),
                                                          )),
                                                          Container(
                                                            width: 30,
                                                            height: 30,
                                                            margin:
                                                                const EdgeInsets
                                                                        .fromLTRB(
                                                                    0,
                                                                    10,
                                                                    0,
                                                                    10),
                                                            child: weatherIcon(snapshot
                                                                            .data['forecast']
                                                                        [
                                                                        'forecastday']
                                                                    [
                                                                    0]['hour'][j]
                                                                [
                                                                'condition']['text']),
                                                          ),
                                                          SizedBox(
                                                            width: 80,
                                                            child: Center(
                                                              child: Text(
                                                                ' ${snapshot.data['forecast']['forecastday'][0]['hour'][j]['temp_c']}°',
                                                                style:
                                                                    TextStyle(
                                                                  fontFamily:
                                                                      mainFont,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                  fontSize: 22,
                                                                  color: isDay
                                                                      ? const Color(
                                                                          0xff302745)
                                                                      : Colors
                                                                          .white,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      )),
                                            ]),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.all(15),
                                width: dw,
                                height: 3,
                                color: isDay
                                    ? const Color(0x33302745)
                                    : Colors.white,
                              ),
                              Container(
                                width: dw,
                                color: Colors.transparent,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                          width: 200,
                                          child: Center(
                                            child: Text(
                                              '3-day forecast',
                                              style: TextStyle(
                                                  fontSize: 24,
                                                  fontFamily: mainFont,
                                                  color: isDay
                                                      ? const Color(0xff302745)
                                                      : Colors.white,
                                                  fontWeight: FontWeight.w700),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    SizedBox(
                                      width: dw,
                                      height: 120,
                                      child: ScrollConfiguration(
                                        behavior: NoGlowListView(),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              for (int i = 0,
                                                      j = int.parse(DateFormat(
                                                              'd')
                                                          .format(
                                                              DateTime.now()));
                                                  i < 3;
                                                  i++, j++)
                                                SizedBox(
                                                    width: 100,
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        Center(
                                                            child: Text(
                                                          int.parse(DateFormat(
                                                                          'd')
                                                                      .format(DateTime
                                                                          .now())) ==
                                                                  j
                                                              ? 'Today'
                                                              : j < 10
                                                                  ? '${DateFormat('MM').format(DateTime.now())}/0$j'
                                                                  : '${DateFormat('MM').format(DateTime.now())}/$j',
                                                          style: TextStyle(
                                                              fontFamily:
                                                                  mainFont,
                                                              fontSize: 18,
                                                              color: isDay
                                                                  ? const Color(
                                                                      0xcc302745)
                                                                  : Colors
                                                                      .white,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400),
                                                        )),
                                                        SizedBox(
                                                          width: 80,
                                                          child: Center(
                                                            child: Text(
                                                              ' ${snapshot.data['forecast']['forecastday'][i]['day']['maxtemp_c']}°',
                                                              style: TextStyle(
                                                                fontFamily:
                                                                    mainFont,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                fontSize: 28,
                                                                color: isDay
                                                                    ? const Color(
                                                                        0xff302745)
                                                                    : Colors
                                                                        .white,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          width: 80,
                                                          child: Center(
                                                            child: Text(
                                                              ' ${snapshot.data['forecast']['forecastday'][i]['day']['mintemp_c']}°',
                                                              style: TextStyle(
                                                                fontFamily:
                                                                    mainFont,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w300,
                                                                fontSize: 16,
                                                                color: isDay
                                                                    ? const Color(
                                                                        0xff302745)
                                                                    : Colors
                                                                        .white,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                          height: 20,
                                                        )
                                                      ],
                                                    )),
                                            ]),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    : SizedBox(
                        width: dw,
                        height: dh,
                        child: Center(
                            child: CircularProgressIndicator(
                          color: isDay ? const Color(0xff302745) : Colors.white,
                        )),
                      ),
              )
            ]),
          );

          // if (snapshot.connectionState == ConnectionState.done) {
          //   return Scaffold(
          //     body: Column(
          //       crossAxisAlignment: CrossAxisAlignment.center,
          //       mainAxisAlignment: MainAxisAlignment.center,
          //       children: [
          //         Text((snapshot.data['current']['condition']['text']).toString()),
          //         InkWell(
          //           onTap: () {
          //             setState(() {
          //               i += 1;
          //             });
          //           },
          //           child: Container(
          //             width: 100,
          //             height: 80,
          //             color: Colors.blue,
          //             child: Text('dsfda'),
          //           ),
          //         )
          //       ],
          //     ),
          //   );
          // } else {
          //   return Scaffold(
          //     body: Column(
          //       mainAxisAlignment: MainAxisAlignment.center,
          //       crossAxisAlignment: CrossAxisAlignment.center,
          //       children: [Text('.....')],
          //     )
          //   );
          // }
        },
        future: getData(cityName),
      );
    } catch (e) {
      return Container();
    }
  }

  Future<void> _showSimpleDialog() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return ScrollConfiguration(
            behavior: NoGlowListView(),
            child: SimpleDialog(
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20))),
              backgroundColor: const Color(0xff302745),
              // <-- SEE HERE
              title: const SizedBox(
                  height: 40,
                  child: Text(
                    'Choose a city',
                    style: TextStyle(color: Colors.white),
                  )),
              children: <Widget>[
                for (int i = 0; i < citys.length; i++)
                  SimpleDialogOption(
                    onPressed: () {
                      setState(() {
                        cityName = citys[i].toString();
                      });
                      prefs.setString('cityName', cityName);
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      citys[i].toString(),
                      style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w400,
                          fontSize: 16),
                    ),
                  ),
              ],
            ),
          );
        });
  }
}

Image weatherIcon(condition) {
  if (condition == 'Sunny') {
    return Image.asset(isDay ? 'assets/sunny.png' : 'assets/sunny_w.png');
  } else if (condition == 'rain') {
    return Image.asset(isDay ? 'assets/rainy.png' : 'assets/rainy_w.png');
  } else if (condition == 'Cloudy') {
    return Image.asset(isDay ? 'assets/cloudy.png' : 'assets/cloudy_w.png');
  } else if (condition == 'Clear') {
    return Image.asset(isDay ? 'assets/clear.png' : 'assets/clear_w.png');
  } else if (condition == 'Partly cloudy') {
    return Image.asset(isDay ? 'assets/partly_1.png' : 'assets/partly_2_w.png');
  } else {
    return Image.asset(isDay ? 'assets/cloudy.png' : 'assets/cloudy_w.png');
  }
}

class NoGlowListView extends ScrollBehavior {
  @override
  Widget buildOverscrollIndicator(
      BuildContext context, Widget child, ScrollableDetails details) {
    return child;
  }
}
