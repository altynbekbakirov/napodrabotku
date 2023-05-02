// import 'package:ishtapp/datas/user_model.dart';

class DemoUser {
  /// User basic info
  final String userFullname;
  final String userPhotoLink;
  final String userSchool;
  final String jobTitle;
  final String userDistance;

  // Constructor
  DemoUser(
      {this.userFullname,
      this.userPhotoLink,
      this.userSchool,
      this.jobTitle,
      this.userDistance});
}

/// CURRENT SINGNED USER DEMO [currentUserDemo]
DemoUser currentUserDemo = DemoUser(
  userFullname: "Deborah, 25",
  userPhotoLink: "assets/images/demo_users/maddevs.png",
  userSchool: "University of Oxford",
  jobTitle: "Computer programmer",
  userDistance: "0km",
);

const DEMO_PROFILE_BIO =
    'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Maecenas semper\n'
    '😍👜👢👗🌷🍔🧁️🍟🍕❤️️ convallis nulla in cursus. '
    'Proin id accumsan felis. Aenean malesuada vitae ligula ac bibendum.';

/// DEMO PROFILES - [getDemoUsers] ///
///
List<DemoUser> getDemoUsers() {
  /// User list
  return [
    DemoUser(
      userFullname: "Carolyn, 20",
      userPhotoLink: "assets/images/demo_users/maddevs.png",
      userSchool: "Harvard University",
      jobTitle: "Dentist",
      userDistance: "10km",
    ),
    DemoUser(
      userFullname: "Rachel, 25",
      userPhotoLink: "assets/images/demo_users/maddevs.png",
      userSchool: "Massachusetts Institute of Technology",
      jobTitle: "Management analyst",
      userDistance: "15km",
    ),
    DemoUser(
      userFullname: "Nicole, 27",
      userPhotoLink: "assets/images/demo_users/maddevs.png",
      userSchool: "Stanford University",
      jobTitle: "Psychologist",
      userDistance: "20km",
    ),
    DemoUser(
      userFullname: "Angela, 24",
      userPhotoLink: "assets/images/demo_users/maddevs.png",
      userSchool: "University of Cambridge",
      jobTitle: "Engineer",
      userDistance: "25km",
    ),
    DemoUser(
      userFullname: "Deborah, 25",
      userPhotoLink: "assets/images/demo_users/maddevs.png",
      userSchool: "University of Oxford",
      jobTitle: "Computer programmer",
      userDistance: "30km",
    ),
    DemoUser(
      userFullname: "Jennifer, 25",
      userPhotoLink: "assets/images/demo_users/maddevs.png",
      userSchool: "University of California",
      jobTitle: "Physical scientist",
      userDistance: "35km",
    ),
  ];
}
