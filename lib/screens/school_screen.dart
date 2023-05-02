import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ishtapp/datas/pref_manager.dart';
import 'package:ishtapp/screens/tabs/school_tab_details.dart';
import 'package:easy_localization/easy_localization.dart';

class SchoolScreen extends StatefulWidget {
  @override
  _SchoolScreenState createState() => _SchoolScreenState();
}

class _SchoolScreenState extends State<SchoolScreen> {
  List<String> videosList = [];
  List<String> titles = [
    (Prefs.getString(Prefs.ROUTE) != "PRODUCT_LAB")
        ? 'searching_work'.tr()
        : 'startup_lab'.tr(),
    'online_training_courses'.tr(),
    'artificial_intelligence'.tr(),
    'machine_learning'.tr(),
    'neural_networks'.tr(),
    'data_science'.tr(),
    'cyber_security'.tr(),
    'software_design'.tr(),
    'links_for_courses'.tr(),
  ];

  @override
  void initState() {
    super.initState();

    if (Prefs.getString(Prefs.LANGUAGE) == 'ru') {
      if (Prefs.getString(Prefs.ROUTE) != "PRODUCT_LAB") {
        videosList = [
          'assets/images/youtube/ishtapp-ru.jpg',
          'assets/images/youtube/online_courses.jpg',
          'assets/images/youtube/intelligence_agent.jpg',
          'assets/images/youtube/machine.jpeg',
          'assets/images/youtube/neiron.jpg',
          'assets/images/youtube/information.jpeg',
          'assets/images/youtube/cyber.jpeg',
          'assets/images/youtube/program.jpeg',
          'assets/images/youtube/courses.jpg',
        ];
      } else {
        videosList = [
          'assets/images/youtube/laboratory-ru.jpg',
          'assets/images/youtube/online_courses.jpg',
          'assets/images/youtube/intelligence_agent.jpg',
          'assets/images/youtube/machine.jpeg',
          'assets/images/youtube/neiron.jpg',
          'assets/images/youtube/information.jpeg',
          'assets/images/youtube/cyber.jpeg',
          'assets/images/youtube/program.jpeg',
          'assets/images/youtube/courses.jpg',
        ];
      }
    } else {
      if (Prefs.getString(Prefs.ROUTE) != "PRODUCT_LAB") {
        videosList = [
          'assets/images/youtube/ishtapp.jpg',
          'assets/images/youtube/online_courses.jpg',
          'assets/images/youtube/intelligence_agent.jpg',
          'assets/images/youtube/machine.jpeg',
          'assets/images/youtube/neiron.jpg',
          'assets/images/youtube/information.jpeg',
          'assets/images/youtube/cyber.jpeg',
          'assets/images/youtube/program.jpeg',
          'assets/images/youtube/courses.jpg',
        ];
      } else {
        videosList = [
          'assets/images/youtube/laboratory.jpg',
          'assets/images/youtube/online_courses.jpg',
          'assets/images/youtube/intelligence_agent.jpg',
          'assets/images/youtube/machine.jpeg',
          'assets/images/youtube/neiron.jpg',
          'assets/images/youtube/information.jpeg',
          'assets/images/youtube/cyber.jpeg',
          'assets/images/youtube/program.jpeg',
          'assets/images/youtube/courses.jpg',
        ];
      }
    }

    _setOrientation([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  @override
  void dispose() {
    super.dispose();
    _setOrientation([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  _setOrientation(List<DeviceOrientation> orientations) {
    SystemChrome.setPreferredOrientations(orientations);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('training'.tr()),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildMoreVideosView(),
          ],
        ),
      ),
    );
  }

  _buildMoreVideosView() {
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 15),
        child: ListView.builder(
            itemCount: videosList.length,
            physics: AlwaysScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => SchoolTabDetails(index)));
                },
                child: Container(
                  height: MediaQuery.of(context).size.height / 5,
                  margin: EdgeInsets.symmetric(vertical: 7),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(18),
                    child: Stack(
                      fit: StackFit.expand,
                      children: <Widget>[
                        Positioned(
                          child: Image(
                            image: AssetImage(videosList[index]),
                            fit: BoxFit.cover,
                          ),
                          /*AssetImage(
                            imageUrl:
                            "https://img.youtube.com/vi/${videosList[index].youtubeId}/0.jpg",
                            fit: BoxFit.cover,
                          ),*/
                        ),
                        Positioned(
                            left: 0,
                            bottom: 0,
                            right: 0,
                            child: Container(
                              alignment: Alignment.centerLeft,
                              width: double.infinity,
                              padding: const EdgeInsets.only(
                                  left: 10, right: 8, bottom: 8, top: 6),
                              color: Colors.black.withOpacity(0.5),
                              child: Text(
                                titles[index],
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.orange,
                                  shadows: <Shadow>[
                                    Shadow(
                                      offset: Offset(1.0, 1.0),
                                      blurRadius: 2.0,
                                      color: Color.fromARGB(255, 0, 0, 0),
                                    ),
                                  ],
                                ),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                                softWrap: false,
                              ),
                            )),
                      ],
                    ),
                  ),
                ),
              );
            }),
      ),
    );
  }
}
