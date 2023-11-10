import 'dart:io';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:ishtapp/components/custom_button.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:ishtapp/main.dart';
import 'package:ishtapp/screens/tabs/profile_tab.dart';
import 'package:ishtapp/widgets/svg_icon.dart';
import 'package:path/path.dart';
import 'package:ishtapp/constants/configs.dart';
import 'package:ishtapp/datas/app_state.dart';
import 'package:ishtapp/datas/pref_manager.dart';
import 'package:ishtapp/datas/user.dart';
import 'package:ishtapp/datas/vacancy.dart';
import 'package:ishtapp/utils/constants.dart';
// import 'package:gx_file_picker/gx_file_picker.dart';
import 'package:flutter_exif_rotation/flutter_exif_rotation.dart';
import 'package:ishtapp/datas/RSAA.dart';
import 'package:flutter_guid/flutter_guid.dart';
import 'package:ishtapp/routes/routes.dart';

enum user_gender { Male, Female }

class EditProfileScreen extends StatefulWidget {
  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  // Variables
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  final title_controller = TextEditingController();
  final experience_year_controller = TextEditingController();
  UserCv user_cv;
  Users user;

  File _imageFile;

  // PickedFile _imageFile;
  final ImagePicker _picker = ImagePicker();
  dynamic _pickImageError;
  String _retrieveDataError;
  File attachment;

  final DateFormat formatter = DateFormat('yyyy-MM-dd');

  final _name_controller = TextEditingController();
  final _surname_controller = TextEditingController();
  final _email_controller = TextEditingController();
  final _phone_number_controller = TextEditingController();
  final _birth_date_controller = TextEditingController();
  final _linkedin_controller = TextEditingController();
  final _address_of_company = TextEditingController();
  final _fullname_of_contact_person = TextEditingController();
  final _position_of_contact_person = TextEditingController();
  final _description_controller = TextEditingController();

  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: new Wrap(
                children: <Widget>[
                  new ListTile(
                      leading: new Icon(Icons.photo_library),
                      title: new Text('from_gallery'.tr()),
                      onTap: () {
                        _onImageButtonPressed(ImageSource.gallery, context: context);
                        Navigator.of(context).pop();
                      }),
                  new ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text('camera'.tr()),
                    onTap: () {
                      _onImageButtonPressed(ImageSource.camera, context: context);
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

//  List<UserExperienceForm> user_experience_forms = [];

  void _onImageButtonPressed(ImageSource source, {BuildContext context}) async {

    // PermissionStatus status = await Permission.storage.request();
    //
    // if (status.isGranted) {
    //   // You have permission to access photos; you can now perform the operation.
    // } else {
    //   // The user denied permission or didn't respond; you should handle this gracefully.
    //   if (status.isPermanentlyDenied) {
    //     openAppSettings();
    //   }
    // }


    try {
      final pickedFile = await _picker.getImage(
        source: source,
      );

      // File imageFile = File(pickedFile.path);
      //
      // if (imageFile.existsSync()) {
      //   // The file exists, proceed with displaying it.
      // } else {
      //   // The file does not exist; there might be an issue with the file path.
      // }

      // File rotatedImage = await FlutterExifRotation.rotateAndSaveImage(path: pickedFile.path);

      if (pickedFile != null && pickedFile.path != null) {
        // File rotatedImage = await FlutterExifRotation.rotateImage(path: pickedFile.path);

        File imageFile = File(pickedFile.path);

        if (imageFile.existsSync()) {
          setState(() {
            _imageFile = imageFile;
          });
        }

      }

      // setState(() {
      //   _imageFile = rotatedImage;
      // });

    } catch (e) {
      print("error: " + e.toString());
      setState(() {
        _pickImageError = e;
      });
    }
  }

  // Future<void> retrieveLostData() async {
  //   final LostData response = await _picker.getLostData();
  //   if (response.isEmpty) {
  //     return;
  //   }
  //   if (response.file != null) {
  //     setState(() {
  //       _imageFile = response.file;
  //     });
  //   } else {
  //     _retrieveDataError = response.exception.code;
  //   }
  // }

  void _showDataPicker(context) {
    DatePicker.showDatePicker(context,
        locale: LocaleType.ru,
        theme: DatePickerTheme(
          headerColor: Theme.of(context).primaryColor,
          cancelStyle: const TextStyle(color: Colors.white, fontSize: 17),
          doneStyle: const TextStyle(color: Colors.white, fontSize: 17),
        ), onConfirm: (date) {
      print(date);
      // Change state
      setState(() {
        _birth_date_controller.text = date.toString().split(" ")[0];
        StoreProvider.of<AppState>(context).state.user.user.data.birth_date = date;
      });
    });
  }

  int count = 1;
  int counter = 0;

  void _pickAttachment() async {
    FilePickerResult result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc', 'docx', 'jpeg'],
    );

    if(result != null) {
      File file = File(result.files.single.path);

      if (file != null) {
        setState(() {
          attachment = file;
        });
      } else {
        // User canceled the picker
      }
    } else {
      // User canceled the picker
    }

  }

  final _textStyle = TextStyle(
    color: Colors.black,
    fontSize: 16.0,
    fontWeight: FontWeight.w500,
  );

  bool is_migrant = false;

  user_gender gender = user_gender.Male;

  List<dynamic> regionList = [];
  String selectedRegion;
  List<String> items = [];
  List<dynamic> jobSpheres = [];
  List<String> spheres = [];
  String selectedJobSphere;
  List<String> departments = [];
  String selectedDepartment;
  List<String> socialOrientations = [];
  String selectedSocialOrientation;
  List<String> skillSetCategories = [];
  List<String> skills = [];

  List<dynamic> districtList = [];
  List<String> districts = [];
  String selectedDistrict;

  getLists() async {
    regionList = await Vacancy.getLists('region', null);
    regionList.forEach((region) {
      setState(() {
        items.add(region['name']);
      });
    });
  }

  getDistricts(region) async {
    districts = [];
    districtList = await Vacancy.getLists('districts_by_name', region);
    districtList.forEach((district) {
      setState(() {
        districts.add(district['name']);
      });
    });
  }

  @override
  void initState() {
    getLists();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (count == 1) {
      user = StoreProvider.of<AppState>(context).state.user.user.data;

      if (Prefs.getString(Prefs.USER_TYPE) == 'USER') {
        user_cv = StoreProvider.of<AppState>(context).state.user.user_cv.data;
        // title_controller.text = user_cv.job_title;
        //         // experience_year_controller.text = user_cv.experience_year == null ? '0' : user_cv.experience_year.toString();
      }
      _name_controller.text = user.name;
      _surname_controller.text = user.surname;
      _email_controller.text = user.email;
      _phone_number_controller.text = user.phone_number;
      _linkedin_controller.text = user.linkedin;
      _description_controller.text = user.description;
      is_migrant = user.is_migrant == 1;
      gender = user.gender == 1 ? user_gender.Female : user_gender.Male;
      selectedRegion = user.region;
      if(user.region != ''){
        getDistricts(user.region);
      }
      selectedDistrict = user.district;

      _fullname_of_contact_person.text = user.contact_person_fullname;
      _position_of_contact_person.text = user.contact_person_position;
      _address_of_company.text = user.address;

      if (user.birth_date != null) _birth_date_controller.text = formatter.format(user.birth_date);
      count = 2;
    }
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("edit_profile".tr()),
        leading: new IconButton(
            icon: new Icon(Icons.arrow_back),
            onPressed: (){
              if (_formKey.currentState.validate()) {
                final DateFormat formatter = DateFormat('yyyy-MM-dd');
                user.email = _email_controller.text;
                user.phone_number = _phone_number_controller.text;
                user.birth_date = formatter.parse(_birth_date_controller.text);
                user.linkedin = _linkedin_controller.text;

                user.name = _name_controller.text;
                user.surname = _surname_controller.text;
                user.is_migrant = is_migrant ? 1 : 0;
                user.gender = gender == user_gender.Male ? "male" : "female";
                user.region = selectedRegion;
                user.district = selectedDistrict;
                user.contact_person_fullname = _fullname_of_contact_person.text;
                user.contact_person_position = _position_of_contact_person.text;
                user.job_sphere = selectedJobSphere;
                user.department = selectedDepartment;
                user.social_orientation = selectedSocialOrientation;
                user.address = _address_of_company.text;
                user.description = _description_controller.text;

                if (_imageFile != null && _imageFile.path != null) {
                  user.uploadImage2(File(_imageFile.path)).then((value) {
                    StoreProvider.of<AppState>(context).dispatch(getUser());
                    setState(() {
                      Prefs.setString(
                          Prefs.PROFILEIMAGE,
                          StoreProvider.of<AppState>(context).state.user.user.data.image
                      );
                    });

                    if (Prefs.getString(Prefs.USER_TYPE) == 'USER') {
                      // user_cv.experience_year = int.parse(experience_year_controller.text);
                      // user_cv.job_title = title_controller.text;

                      if (attachment != null){
                        user_cv.save(attachment: attachment);
                      } else {
                        user_cv.save();
                      }
                    }

                    Navigator.pop(context);
                  });
                } else {
                  user.uploadImage2(null).then((value) {
                    if (Prefs.getString(Prefs.USER_TYPE) == 'USER') {
                      // user_cv.experience_year = int.parse(experience_year_controller.text);
                      // user_cv.job_title = title_controller.text;

                      if (attachment != null){
                        user_cv.save(attachment: attachment);
                      } else {
                        user_cv.save();
                      }
                    }
                  });
                  Navigator.pop(context);
                }

              } else {
                Navigator.pop(context);
                return;
              }
            }
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Profile photo
            Center(
              child: Column(
                children: [
                  GestureDetector(
                    child: _imageFile == null
                        ? CircleAvatar(
                            backgroundColor: kColorGray,
                            radius: 60,
                            child: SvgIcon("assets/icons/camera_icon.svg", width: 40, height: 40, color: kColorSecondary),
                          )
                        : CircleAvatar(
                            backgroundColor: kColorPrimary,
                            radius: 50,
                            backgroundImage: Image.file(
                              File(_imageFile.path),
                              fit: BoxFit.cover,
                            ).image,
                          ),
                    onTap: () {
                      _showPicker(context);
                    },
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 10),
                    child: Text(
                      "profile_photo".tr().toString().toUpperCase(),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700
                      ),
                    ),
                  )
                ],
              ),
            ),
            SizedBox(height: 20),
            Container(
              child: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    SizedBox(height: 20),

                    /// Название компании
                    Prefs.getString(Prefs.USER_TYPE) == "COMPANY" ? Column(
                      children: <Widget>[
                        Align(
                            widthFactor: 10,
                            heightFactor: 1.5,
                            alignment: Alignment.topLeft,
                            child: Text(
                              'organization_name'.tr().toString().toUpperCase() + '*',
                              style: TextStyle(fontSize: 12, color: Colors.black, fontWeight: FontWeight.w700),
                            )
                        ),
                        TextFormField(
                          controller: _name_controller,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                            border: OutlineInputBorder(),
                            enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey[200], width: 2.0)),
                            errorBorder: OutlineInputBorder(borderSide: BorderSide(color: kColorPrimary, width: 2.0)),
                            errorStyle: TextStyle(color: kColorPrimary, fontWeight: FontWeight.w500),
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            filled: true,
                            fillColor: kColorWhite,
                          ),
                          validator: (name) {
                            // Basic validation
                            if (name.isEmpty) {
                              return "please_fill_this_field".tr();
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 20),
                      ],
                    ) : Container(),

                    /// Контактный телефон
                    Align(
                        widthFactor: 10,
                        heightFactor: 1.5,
                        alignment: Alignment.topLeft,
                        child: Text(
                          'phone_number'.tr().toString().toUpperCase() + '*',
                          style: TextStyle(fontSize: 12, color: Colors.black, fontWeight: FontWeight.w700),
                        )
                    ),
                    TextFormField(
                      controller: _phone_number_controller,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                        border: OutlineInputBorder(),
                        enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey[200], width: 2.0)),
                        errorBorder: OutlineInputBorder(borderSide: BorderSide(color: kColorPrimary, width: 2.0)),
                        errorStyle: TextStyle(color: kColorPrimary, fontWeight: FontWeight.w500),
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        filled: true,
                        fillColor: kColorWhite,
                      ),
                      validator: (name) {
                        // Basic validation
//                      if (name.isEmpty) {
//                        return "please_fill_this_field".tr();
//                      }
                        return null;
                      },
                    ),

                    Prefs.getString(Prefs.USER_TYPE) == "USER" ?
                    Column(
                      children: [
                        SizedBox(height: 20),
                        Align(
                            widthFactor: 10,
                            heightFactor: 1.5,
                            alignment: Alignment.topLeft,
                            child: Text(
                              'name'.tr().toString().toUpperCase() + '*     ',
                              style: TextStyle(fontSize: 12, color: Colors.black, fontWeight: FontWeight.w700),
                            )
                        ),
                        TextFormField(
                          controller: _name_controller,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                            border: OutlineInputBorder(),
                            enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey[200], width: 2.0)),
                            errorBorder: OutlineInputBorder(borderSide: BorderSide(color: kColorPrimary, width: 2.0)),
                            errorStyle: TextStyle(color: kColorPrimary, fontWeight: FontWeight.w500),
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            filled: true,
                            fillColor: kColorWhite,
                          ),
                          validator: (name) {
                            // Basic validation
                            if (name.isEmpty) {
                              return "please_fill_this_field".tr();
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 20),
                        Align(
                            widthFactor: 10,
                            heightFactor: 1.5,
                            alignment: Alignment.topLeft,
                            child: Text(
                              'lastname'.tr().toString().toUpperCase() + '*',
                              style: TextStyle(fontSize: 12, color: Colors.black, fontWeight: FontWeight.w700),
                            )
                        ),
                        TextFormField(
                          controller: _surname_controller,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                            border: OutlineInputBorder(),
                            enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey[200], width: 2.0)),
                            errorBorder: OutlineInputBorder(borderSide: BorderSide(color: kColorPrimary, width: 2.0)),
                            errorStyle: TextStyle(color: kColorPrimary, fontWeight: FontWeight.w500),
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            filled: true,
                            fillColor: kColorWhite,
                          ),
                          validator: (name) {
                            // Basic validation
                            if (name.isEmpty) {
                              return "please_fill_this_field".tr();
                            }
                            return null;
                          },
                        )
                      ],
                    ) : Container(),
                    SizedBox(height: 20),

//                     Align(
//                         widthFactor: 10,
//                         heightFactor: 1.5,
//                         alignment: Alignment.topLeft,
//                         child: Text(
//                           'email'.tr().toString().toUpperCase() + '*',
//                           style: TextStyle(fontSize: 12, color: Colors.black, fontWeight: FontWeight.w700),
//                         )
//                     ),
//                     TextFormField(
//                       controller: _email_controller,
//                       decoration: InputDecoration(
//                         enabled: false,
//                         contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
//                         border: OutlineInputBorder(),
//                         disabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey[200], width: 2.0)),
//                         enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey[200], width: 2.0)),
//                         errorBorder: OutlineInputBorder(borderSide: BorderSide(color: kColorPrimary, width: 2.0)),
//                         errorStyle: TextStyle(color: kColorPrimary, fontWeight: FontWeight.w500),
//                         floatingLabelBehavior: FloatingLabelBehavior.always,
//                         filled: true,
//                         fillColor: kColorWhite,
//                       ),
//                       validator: (name) {
//                         // Basic validation
// //                      if (name.isEmpty) {
// //                        return "please_fill_this_field".tr();
// //                      }
//                         return null;
//                       },
//                       style: TextStyle(color: kColorPrimary.withOpacity(0.6)),
//                     ),
//                     SizedBox(height: 20),

                    /// Область
                    Align(
                        widthFactor: 10,
                        heightFactor: 1.5,
                        alignment: Alignment.topLeft,
                        child: Text(
                          'region'.tr().toString().toUpperCase() + '*',
                          style: TextStyle(fontSize: 12, color: Colors.black, fontWeight: FontWeight.w700),
                        )
                    ),
                    DropdownSearch<String>(
                        showSelectedItem: true,
                        items: items,
                        popupItemDisabled: (String s) => s.startsWith('I'),
                        onChanged: (value) {
                          setState(() {
                            selectedRegion = value;
                            getDistricts(value);
                            selectedDistrict = '';
                          });
                        },
                        dropdownSearchDecoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 20),
                          border: OutlineInputBorder(),
                          enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey[200], width: 2.0)),
                          errorBorder: OutlineInputBorder(borderSide: BorderSide(color: kColorPrimary, width: 2.0)),
                          errorStyle: TextStyle(color: kColorPrimary, fontWeight: FontWeight.w500),
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          filled: true,
                          fillColor: kColorWhite,
                        ),
                        selectedItem: selectedRegion
                    ),
                    SizedBox(height: 20),

                    /// Регион
                    Align(
                        widthFactor: 10,
                        heightFactor: 1.5,
                        alignment: Alignment.topLeft,
                        child: Text(
                          'district'.tr().toString().toUpperCase() + '*',
                          style: TextStyle(fontSize: 12, color: Colors.black, fontWeight: FontWeight.w700),
                        )
                    ),
                    DropdownSearch<String>(
                        showSelectedItem: true,
                        items: districts,
                        popupItemDisabled: (String s) => s.startsWith('I'),
                        onChanged: (value) {
                          setState(() {
                            selectedDistrict = value;
                          });
                        },
                        dropdownSearchDecoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 20),
                          border: OutlineInputBorder(),
                          enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey[200], width: 2.0)),
                          errorBorder: OutlineInputBorder(borderSide: BorderSide(color: kColorPrimary, width: 2.0)),
                          errorStyle: TextStyle(color: kColorPrimary, fontWeight: FontWeight.w500),
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          filled: true,
                          fillColor: kColorWhite,
                        ),
                        selectedItem: selectedDistrict
                    ),
                    SizedBox(height: 20),

                    /// Адрес компании/организации
                    Prefs.getString(Prefs.USER_TYPE) == "COMPANY" ?
                    Column(
                      children: <Widget>[
                        Align(
                            widthFactor: 10,
                            heightFactor: 1.5,
                            alignment: Alignment.topLeft,
                            child: Text(
                              'company_address'.tr().toString().toUpperCase() + '*',
                              style: TextStyle(fontSize: 12, color: Colors.black, fontWeight: FontWeight.w700),
                            )
                        ),
                        TextFormField(
                          enabled: true,
                          controller: _address_of_company,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                            border: OutlineInputBorder(),
                            enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey[200], width: 2.0)),
                            errorBorder: OutlineInputBorder(borderSide: BorderSide(color: kColorPrimary, width: 2.0)),
                            errorStyle: TextStyle(color: kColorPrimary, fontWeight: FontWeight.w500),
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            filled: true,
                            fillColor: kColorWhite,
                          ),
                          style: TextStyle(color: kColorPrimary.withOpacity(0.6)),
                        ),
                        SizedBox(height: 20),
                      ],
                    ) : Container(),

                    /// ФИО Контактного лица
                    Prefs.getString(Prefs.USER_TYPE) == "COMPANY" ?
                    Column(
                      children: <Widget>[
                        Align(
                            widthFactor: 10,
                            heightFactor: 1.5,
                            alignment: Alignment.topLeft,
                            child: Text(
                              'name_of_contact_person'.tr().toString().toUpperCase() + '*',
                              style: TextStyle(fontSize: 12, color: Colors.black, fontWeight: FontWeight.w700),
                            )
                        ),
                        TextFormField(
                          enabled: true,
                          controller: _fullname_of_contact_person,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                            border: OutlineInputBorder(),
                            enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey[200], width: 2.0)),
                            errorBorder: OutlineInputBorder(borderSide: BorderSide(color: kColorPrimary, width: 2.0)),
                            errorStyle: TextStyle(color: kColorPrimary, fontWeight: FontWeight.w500),
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            filled: true,
                            fillColor: kColorWhite,
                          ),
                          style: TextStyle(color: kColorPrimary.withOpacity(0.6)),
                        ),
                        SizedBox(height: 20),
                      ],
                    ) : Container(),

                    /// Должность контактного лица
                    Prefs.getString(Prefs.USER_TYPE) == "COMPANY" ?
                    Column(
                      children: <Widget>[
                        Align(
                            widthFactor: 10,
                            heightFactor: 1.5,
                            alignment: Alignment.topLeft,
                            child: Text(
                              'position'.tr().toUpperCase(),
                              style: TextStyle(fontSize: 12, color: Colors.black, fontWeight: FontWeight.w700),
                            )),
                        TextFormField(
                          enabled: true,
                          controller: _position_of_contact_person,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                            border: OutlineInputBorder(),
                            enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey[200], width: 2.0)),
                            errorBorder: OutlineInputBorder(borderSide: BorderSide(color: kColorPrimary, width: 2.0)),
                            errorStyle: TextStyle(color: kColorPrimary, fontWeight: FontWeight.w500),
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            filled: true,
                            fillColor: kColorWhite,
                          ),
                          style: TextStyle(color: kColorPrimary.withOpacity(0.6)),
                        ),
                        SizedBox(height: 20),
                      ],
                    ) : Container(),

                    Prefs.getString(Prefs.USER_TYPE) == "USER" ?
                    Align(
                        widthFactor: 10,
                        heightFactor: 1.5,
                        alignment: Alignment.topLeft,
                        child: Text(
                          'birth_date'.tr().toString().toUpperCase() + '*',
                          style: TextStyle(fontSize: 12, color: Colors.black, fontWeight: FontWeight.w700),
                        )
                    ) : Container(),

                    Prefs.getString(Prefs.USER_TYPE) == "USER" ?
                    TextFormField(
                      controller: _birth_date_controller,
                      decoration: InputDecoration(
                        enabled: false,
                        contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                        border: OutlineInputBorder(),
                        disabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey[200], width: 2.0)),
                        enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey[200], width: 2.0)),
                        errorBorder: OutlineInputBorder(borderSide: BorderSide(color: kColorPrimary, width: 2.0)),
                        errorStyle: TextStyle(color: kColorPrimary, fontWeight: FontWeight.w500),
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        filled: true,
                        fillColor: kColorWhite,
                      ),
                      validator: (name) {
                        // Basic validation
//                      if (name.isEmpty) {
//                        return "please_fill_this_field".tr();
//                      }
                        return null;
                      },
                      style: TextStyle(color: kColorPrimary.withOpacity(0.6)),
                    ) : Container(),
                    SizedBox(height: 20),

                    Prefs.getString(Prefs.USER_TYPE) == "USER" ?
                    Align(
                        widthFactor: 10,
                        heightFactor: 1.5,
                        alignment: Alignment.topLeft,
                        child: Text(
                          'about_myself'.tr().toString().toUpperCase() + '*',
                          style: TextStyle(fontSize: 12, color: Colors.black, fontWeight: FontWeight.w700),
                        )
                    ) : Container(),

                    Prefs.getString(Prefs.USER_TYPE) == "USER" ?
                    TextFormField(
                      controller: _description_controller,
                      maxLines: 5,
                      focusNode: FocusNode(canRequestFocus: false),
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                        border: OutlineInputBorder(),
                        disabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey[200], width: 2.0)),
                        enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey[200], width: 2.0)),
                        errorBorder: OutlineInputBorder(borderSide: BorderSide(color: kColorPrimary, width: 2.0)),
                        errorStyle: TextStyle(color: kColorPrimary, fontWeight: FontWeight.w500),
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        filled: true,
                        fillColor: kColorWhite,
                      ),
                      validator: (name) {
                        if (name.isEmpty) {
                          return "please_fill_this_field".tr();
                        }
                        return null;
                      },
                    ) : Container(),
                    SizedBox(height: 20),

                    Prefs.getString(Prefs.USER_TYPE) == "USER" ?
                    Align(
                        widthFactor: 10,
                        heightFactor: 1.5,
                        alignment: Alignment.topLeft,
                        child: Text(
                          'gender'.tr().toString().toUpperCase() + '  ' + '*',
                          style: TextStyle(fontSize: 12, color: Colors.black, fontWeight: FontWeight.w700),
                        )
                    ) : Container(),

                    Prefs.getString(Prefs.USER_TYPE) == "USER" ?
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Radio(
                          value: user_gender.Male,
                          groupValue: gender,
                          activeColor: kColorPrimary,
                          onChanged: (user_gender value) {
                            setState(() {
                              gender = value;
                            });
                          },
                        ),
                        Text('male'.tr(), style: TextStyle(color: Colors.black)),
                        Radio(
                          value: user_gender.Female,
                          groupValue: gender,
                          activeColor: kColorPrimary,
                          onChanged: (user_gender value) {
                            setState(() {
                              gender = value;
                            });
                          },
                        ),
                        Text('female'.tr(), style: TextStyle(color: Colors.black)),
                      ],
                    ) : Container(),
                    SizedBox(height: 20),

                    Column(
                      children: <Widget>[
                        user_cv == null ?
                        Container() :
                        Align(
                            widthFactor: 10,
                            heightFactor: 1.5,
                            alignment: Alignment.topLeft,
                            child: Text(
                              'attachment'.tr().toString().toUpperCase()+' ',
                              style: TextStyle(fontSize: 12, color: Colors.black, fontWeight: FontWeight.w700),
                            )
                        ),
                        user_cv == null ? Container() :
                        CustomButton(
                            borderSide: BorderSide(
                                color: kColorPrimary,
                                width: 2.0
                            ),
                            padding: EdgeInsets.all(0),
                            color: Colors.transparent,
                            textColor: kColorPrimary,
                            text: attachment != null ? basename(attachment.path).length >=30 ? basename(attachment.path).replaceRange(30, basename(attachment.path).length, '...') : basename(attachment.path) : 'upload_new_file'.tr(),
                            onPressed: () {
                              _pickAttachment();
                            }
                        ),
                        user_cv == null ? Container() : SizedBox(height: 30),
                      ],
                    ),

                    SizedBox(
                      width: double.maxFinite,
                      child: CustomButton(
                        color: kColorPrimary,
                        textColor: Colors.white,
                        onPressed: () {
                          Navigator.pushNamed(context, Routes.new_password);
                        },
                        text: 'change_password'.tr(),
                      ),
                    ),
                    // SizedBox(height: 20),
                    // SizedBox(
                    //   width: double.maxFinite,
                    //   child: CustomButton(
                    //     color: kColorPrimary,
                    //     textColor: Colors.white,
                    //     onPressed: () {
                    //       if (_formKey.currentState.validate()) {
                    //         final DateFormat formatter = DateFormat('yyyy-MM-dd');
                    //         user.email = _email_controller.text;
                    //         user.phone_number = _phone_number_controller.text;
                    //         user.birth_date = formatter.parse(_birth_date_controller.text);
                    //         user.linkedin = _linkedin_controller.text;
                    //
                    //         user.name = _name_controller.text;
                    //         user.surname = _surname_controller.text;
                    //         user.is_migrant = is_migrant ? 1 : 0;
                    //         user.gender = gender == user_gender.Male ? "male" : "female";
                    //         user.region = selectedRegion;
                    //         user.district = selectedDistrict;
                    //         user.contact_person_fullname = _fullname_of_contact_person.text;
                    //         user.contact_person_position = _position_of_contact_person.text;
                    //         user.job_sphere = selectedJobSphere;
                    //         user.department = selectedDepartment;
                    //         user.social_orientation = selectedSocialOrientation;
                    //         user.address = _address_of_company.text;
                    //         user.description = _description_controller.text;
                    //
                    //         if (_imageFile != null && _imageFile.path != null) {
                    //           user.uploadImage2(File(_imageFile.path)).then((value) {
                    //             StoreProvider.of<AppState>(context).dispatch(getUser());
                    //             setState(() {
                    //               Prefs.setString(
                    //                   Prefs.PROFILEIMAGE,
                    //                   StoreProvider.of<AppState>(context).state.user.user.data.image
                    //               );
                    //             });
                    //
                    //             if (Prefs.getString(Prefs.USER_TYPE) == 'USER') {
                    //               // user_cv.experience_year = int.parse(experience_year_controller.text);
                    //               // user_cv.job_title = title_controller.text;
                    //
                    //               if (attachment != null){
                    //                 user_cv.save(attachment: attachment);
                    //               } else {
                    //                 user_cv.save();
                    //               }
                    //               Navigator.pop(context);
                    //             }
                    //           });
                    //         } else {
                    //           user.uploadImage2(null);
                    //           Navigator.pop(context);
                    //         }
                    //
                    //       } else {
                    //         Navigator.pop(context);
                    //         return;
                    //       }
                    //     },
                    //     text: 'save'.tr(),
                    //   ),
                    // ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
