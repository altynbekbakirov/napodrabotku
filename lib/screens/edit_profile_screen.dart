import 'dart:io';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ishtapp/components/custom_button.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_redux/flutter_redux.dart';
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
  final _surnname_controller = TextEditingController();
  final _email_controller = TextEditingController();
  final _phone_number_controller = TextEditingController();
  final _birth_date_controller = TextEditingController();
  final _linkedin_controller = TextEditingController();
  final _address_of_company = TextEditingController();
  final _fullname_of_contact_person = TextEditingController();
  final _position_of_contact_person = TextEditingController();

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
    {
      try {
        final pickedFile = await _picker.getImage(
          source: source,
        );

        File rotatedImage = await FlutterExifRotation.rotateAndSaveImage(path: pickedFile.path);

        if (pickedFile != null && pickedFile.path != null) {
          File rotatedImage = await FlutterExifRotation.rotateImage(path: pickedFile.path);

          setState(() {
            _imageFile = rotatedImage;
          });
        }

        // setState(() {
        //   _imageFile = pickedFile;
        // });

      } catch (e) {
        print("error: " + e.toString());
        setState(() {
          _pickImageError = e;
        });
      }
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

  // void _pickAttachment() async {
  //   File file = await FilePicker.getFile(
  //     type: FileType.custom,
  //     allowedExtensions: ['pdf', 'doc', 'docx'],
  //   );
  //
  //   if (file != null) {
  //     setState(() {
  //       attachment = file;
  //     });
  //   } else {
  //     // User canceled the picker
  //   }
  // }

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
    districtList = await Vacancy.getLists('districts', region);
    districtList.forEach((district) {
      setState(() {
        districts.add(district['name']);
      });
    });
  }

  getJobSphere() async {
    var list = await Vacancy.getLists('job_sphere', null);
    list.forEach((sphere) {
      setState(() {
        spheres.add(sphere['name']);
      });
    });
  }

  getDepartments(String sphere) async {
    departments = [];
    var list = await Vacancy.getLists2('department', sphere);
    list.forEach((department) {
      setState(() {
        departments.add(department['name']);
      });
    });
  }

  getSocialOrientations() async {
    var list = await Vacancy.getLists('social_orientation', null);
    list.forEach((item) {
      setState(() {
        socialOrientations.add(item['name']);
      });
    });
  }

  @override
  void initState() {
    getLists();
    getJobSphere();
    getSocialOrientations();
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
      _surnname_controller.text = user.surname;
      _email_controller.text = user.email;
      _phone_number_controller.text = user.phone_number;
      _linkedin_controller.text = user.linkedin;
      is_migrant = user.is_migrant == 1;
      gender = user.gender == 1 ? user_gender.Female : user_gender.Male;
      selectedRegion = user.region;
      getDistricts(user.region);
      selectedDistrict = user.district;

      selectedJobSphere = user.job_sphere;
      selectedDepartment = user.department;
      getDepartments(user.job_sphere);
      selectedSocialOrientation = user.social_orientation;
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
                            backgroundColor: Prefs.getString(Prefs.ROUTE) == "PRODUCT_LAB" ? kColorProductLab : kColorPrimary,
                            radius: 60,
                            backgroundImage: Prefs.getString(Prefs.PROFILEIMAGE) != null
                                ? NetworkImage(
                                    SERVER_IP + Prefs.getString(Prefs.PROFILEIMAGE) + "?token=${Guid.newGuid}",
                                    headers: {"Authorization": Prefs.getString(Prefs.TOKEN)})
                                : null,
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
                    Prefs.getString(Prefs.USER_TYPE) == "COMPANY"
                        ? Column(
                      children: <Widget>[
                        Align(
                            heightFactor: 1.5,
                            alignment: Alignment.topLeft,
                            child: Text(
                              'company_name'.tr(),
                              style: TextStyle(fontSize: 16, color: Colors.black),
                            )),
                        TextFormField(
                          controller: _name_controller,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            filled: true,
                            fillColor: Colors.grey[200],
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
                    )
                        : Container(),

                    /// Контактный телефон
                    Align(
                        widthFactor: 10,
                        heightFactor: 1.5,
                        alignment: Alignment.topLeft,
                        child: Text(
                          'phone_number'.tr(),
                          style: TextStyle(fontSize: 16, color: Colors.black),
                        )),
                    TextFormField(
                      controller: _phone_number_controller,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        filled: true,
                        fillColor: Colors.grey[200],
                      ),
                      validator: (name) {
                        // Basic validation
//                      if (name.isEmpty) {
//                        return "please_fill_this_field".tr();
//                      }
                        return null;
                      },
                    ),

                    Prefs.getString(Prefs.USER_TYPE) == "USER"
                        ? Column(
                      children: [
                        SizedBox(height: 20),
                        Align(
                            widthFactor: 10,
                            heightFactor: 1.5,
                            alignment: Alignment.topLeft,
                            child: Text(
                              'surname'.tr(),
                              style: TextStyle(fontSize: 16, color: Colors.black),
                            )),
                      ],
                    )
                        : Container(),
                    Prefs.getString(Prefs.USER_TYPE) == "USER"
                        ? TextFormField(
                      controller: _name_controller,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        filled: true,
                        fillColor: Colors.grey[200],
                      ),
                      validator: (name) {
                        // Basic validation
                        if (name.isEmpty) {
                          return "please_fill_this_field".tr();
                        }
                        return null;
                      },
                    )
                        : Container(),
                    SizedBox(height: 20),

                    Align(
                        widthFactor: 10,
                        heightFactor: 1.5,
                        alignment: Alignment.topLeft,
                        child: Text(
                          'email'.tr(),
                          style: TextStyle(fontSize: 16, color: Colors.black),
                        )),
                    TextFormField(
                      enabled: false,
                      controller: _email_controller,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        filled: true,
                        fillColor: Colors.grey[100],
                      ),
                      validator: (name) {
                        // Basic validation
//                      if (name.isEmpty) {
//                        return "please_fill_this_field".tr();
//                      }
                        return null;
                      },
                      style: TextStyle(color: kColorPrimary.withOpacity(0.6)),
                    ),
                    SizedBox(height: 20),

                    /// Область
                    Align(
                        widthFactor: 10,
                        heightFactor: 1.5,
                        alignment: Alignment.topLeft,
                        child: Text(
                          'region'.tr(),
                          style: TextStyle(fontSize: 16, color: Colors.black),
                        )),
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
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide.none,
                            ),
                            filled: true,
                            fillColor: Colors.grey[200],
                            contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 12)),
                        selectedItem: selectedRegion),
                    SizedBox(height: 20),

                    /// Регион
                    Align(
                        widthFactor: 10,
                        heightFactor: 1.5,
                        alignment: Alignment.topLeft,
                        child: Text(
                          'district'.tr(),
                          style: TextStyle(fontSize: 16, color: Colors.black),
                        )),
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
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide.none,
                            ),
                            filled: true,
                            fillColor: Colors.grey[200],
                            contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 12)),
                        selectedItem: selectedDistrict),
                    SizedBox(height: 20),

                    /// Адрес компании/организации
                    Prefs.getString(Prefs.USER_TYPE) == "COMPANY"
                        ? Column(
                      children: <Widget>[
                        Align(
                            widthFactor: 10,
                            heightFactor: 1.5,
                            alignment: Alignment.topLeft,
                            child: Text(
                              'company_address'.tr(),
                              style: TextStyle(fontSize: 16, color: Colors.black),
                            )),
                        TextFormField(
                          enabled: true,
                          controller: _address_of_company,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            filled: true,
                            fillColor: Colors.grey[200],
                          ),
                          style: TextStyle(color: kColorPrimary.withOpacity(0.6)),
                        ),
                        SizedBox(height: 20),
                      ],
                    )
                        : Container(),

                    /// ФИО Контактного лица
                    Prefs.getString(Prefs.USER_TYPE) == "COMPANY"
                        ? Column(
                      children: <Widget>[
                        Align(
                            widthFactor: 10,
                            heightFactor: 1.5,
                            alignment: Alignment.topLeft,
                            child: Text(
                              'name_of_contact_person'.tr(),
                              style: TextStyle(fontSize: 16, color: Colors.black),
                            )),
                        TextFormField(
                          enabled: true,
                          controller: _fullname_of_contact_person,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            filled: true,
                            fillColor: Colors.grey[200],
                          ),
                          style: TextStyle(color: kColorPrimary.withOpacity(0.6)),
                        ),
                        SizedBox(height: 20),
                      ],
                    )
                        : Container(),

                    /// Должность контактного лица
                    Prefs.getString(Prefs.USER_TYPE) == "COMPANY"
                        ? Column(
                      children: <Widget>[
                        Align(
                            widthFactor: 10,
                            heightFactor: 1.5,
                            alignment: Alignment.topLeft,
                            child: Text(
                              'position'.tr(),
                              style: TextStyle(fontSize: 16, color: Colors.black),
                            )),
                        TextFormField(
                          enabled: true,
                          controller: _position_of_contact_person,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            filled: true,
                            fillColor: Colors.grey[200],
                          ),
                          style: TextStyle(color: kColorPrimary.withOpacity(0.6)),
                        ),
                        SizedBox(height: 20),
                      ],
                    )
                        : Container(),

                    /// Выбор сферы деятельности
                    Prefs.getString(Prefs.USER_TYPE) == "COMPANY"
                        ? Column(
                      children: <Widget>[
                        Align(
                            widthFactor: 10,
                            heightFactor: 1.5,
                            alignment: Alignment.topLeft,
                            child: Text(
                              'job_type'.tr(),
                              style: TextStyle(fontSize: 16, color: Colors.black),
                            )),
                        DropdownSearch<String>(
                            showSelectedItem: true,
                            items: spheres,
                            onChanged: (value) {
                              getDepartments(value);
                              setState(() {
                                selectedJobSphere = value;
                              });
                            },
                            dropdownSearchDecoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide.none,
                                ),
                                filled: true,
                                fillColor: Colors.grey[200],
                                contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 12)),
                            selectedItem: selectedJobSphere),
                        SizedBox(height: 20),
                      ],
                    )
                        : Container(),

                    /// Выбор Отрасли
                    Prefs.getString(Prefs.ROUTE) != "PRODUCT_LAB"
                        ? selectedJobSphere != null
                        ? Align(
                        widthFactor: 10,
                        heightFactor: 1.5,
                        alignment: Alignment.topLeft,
                        child: Text(
                          'industry'.tr(),
                          style: TextStyle(fontSize: 16, color: Colors.black),
                        ))
                        : Container()
                        : Container(),
                    Prefs.getString(Prefs.ROUTE) != "PRODUCT_LAB"
                        ? selectedJobSphere != null
                        ? DropdownSearch<String>(
                        showSelectedItem: true,
                        items: departments,
                        onChanged: (value) {
                          setState(() {
                            selectedDepartment = value;
                          });
                        },
                        dropdownSearchDecoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide.none,
                            ),
                            filled: true,
                            fillColor: Colors.grey[200],
                            contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 12)),
                        selectedItem: selectedDepartment)
                        : Container()
                        : Container(),
                    SizedBox(height: 20),

                    /// Социально-ориентированность
                    Prefs.getString(Prefs.USER_TYPE) == "COMPANY"
                        ? Column(
                      children: <Widget>[
                        Align(
                            widthFactor: 10,
                            heightFactor: 1.5,
                            alignment: Alignment.topLeft,
                            child: Text(
                              'social_orientation'.tr(),
                              style: TextStyle(fontSize: 16, color: Colors.black),
                            )),
                        DropdownSearch<String>(
                            showSelectedItem: true,
                            items: socialOrientations,
                            onChanged: (value) {
                              setState(() {
                                selectedSocialOrientation = value;
                              });
                            },
                            dropdownSearchDecoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide.none,
                                ),
                                filled: true,
                                fillColor: Colors.grey[200],
                                contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 12)),
                            selectedItem: selectedSocialOrientation),
                        SizedBox(height: 20),
                      ],
                    )
                        : Container(),

                    Prefs.getString(Prefs.USER_TYPE) == "USER"
                        ? Align(
                        widthFactor: 10,
                        heightFactor: 1.5,
                        alignment: Alignment.topLeft,
                        child: Text(
                          'birth_date'.tr(),
                          style: TextStyle(fontSize: 16, color: Colors.black),
                        ))
                        : Container(),
                    Prefs.getString(Prefs.USER_TYPE) == "USER"
                        ? CustomButton(
                        mainAxisAlignment: MainAxisAlignment.start,
                        width: MediaQuery.of(context).size.width * 1,
                        height: 60.0,
                        color: Colors.grey[100],
                        textColor: kColorPrimary.withOpacity(0.6),
                        textSize: 16,
                        fontWeight: FontWeight.w400,
                        textAlign: TextAlign.right,
                        text: _birth_date_controller.text,
                        onPressed: null)
                        : Container(),
                    SizedBox(height: 20),

                    Prefs.getString(Prefs.USER_TYPE) == "USER"
                        ? Align(
                        widthFactor: 10,
                        heightFactor: 1.5,
                        alignment: Alignment.topLeft,
                        child: Text(
                          'gender'.tr() + '  ',
                          style: TextStyle(fontSize: 16, color: Colors.black),
                        ))
                        : Container(),
                    Prefs.getString(Prefs.USER_TYPE) == "USER"
                        ? Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Radio(
                          value: user_gender.Male,
                          groupValue: gender,
                          activeColor: Colors.grey,
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
                          activeColor: Colors.grey,
                          onChanged: (user_gender value) {
                            setState(() {
                              gender = value;
                            });
                          },
                        ),
                        Text('female'.tr(), style: TextStyle(color: Colors.black)),
                      ],
                    )
                        : Container(),
                    SizedBox(height: 20),
                    Prefs.getString(Prefs.ROUTE) != "PRODUCT_LAB"
                        ? Column(
                      children: <Widget>[
                        user_cv == null
                            ? Container()
                            : Align(
                            widthFactor: 10,
                            heightFactor: 1.5,
                            alignment: Alignment.topLeft,
                            child: Text(
                              'attachment'.tr(),
                              style: TextStyle(fontSize: 16, color: Colors.black),
                            )),
                        user_cv == null
                            ? Container()
                            : CustomButton(
                            text: attachment != null ? basename(attachment.path) : 'upload_new_file'.tr(),
                            width: MediaQuery.of(context).size.width * 1,
                            color: Colors.grey[200],
                            textColor: kColorPrimary,
                            onPressed: () {
                              // _pickAttachment();
                            }),
                        user_cv == null ? Container() : SizedBox(height: 30),
                      ],
                    )
                        : Container(),

                    SizedBox(
                      width: double.maxFinite,
                      child: CustomButton(
                        padding: EdgeInsets.all(15),
                        color: Prefs.getString(Prefs.ROUTE) == "PRODUCT_LAB" ? kColorProductLab : kColorPrimary,
                        textColor: Colors.white,
                        onPressed: () {
                          Navigator.pushNamed(context, Routes.new_password);
                        },
                        text: 'change_password'.tr(),
                      ),
                    ),
                    SizedBox(height: 20),
                    SizedBox(
                      width: double.maxFinite,
                      child: CustomButton(
                        padding: EdgeInsets.all(15),
                        color: Prefs.getString(Prefs.ROUTE) == "PRODUCT_LAB" ? kColorProductLab : kColorPrimary,
                        textColor: Colors.white,
                        onPressed: () {
                          if (_formKey.currentState.validate()) {
                            final DateFormat formatter = DateFormat('yyyy-MM-dd');
                            user.email = _email_controller.text;
                            user.phone_number = _phone_number_controller.text;
                            user.birth_date = formatter.parse(_birth_date_controller.text);
                            user.linkedin = _linkedin_controller.text;

                            user.name = _name_controller.text;
                            user.surname = _surnname_controller.text;
                            user.is_migrant = is_migrant ? 1 : 0;
                            user.gender = gender == user_gender.Male ? 0 : 1;
                            user.region = selectedRegion;
                            user.district = selectedDistrict;
                            user.contact_person_fullname = _fullname_of_contact_person.text;
                            user.contact_person_position = _position_of_contact_person.text;
                            user.job_sphere = selectedJobSphere;
                            user.department = selectedDepartment;
                            user.social_orientation = selectedSocialOrientation;
                            user.address = _address_of_company.text;

                            if (_imageFile != null && _imageFile.path != null)
                              user.uploadImage2(File(_imageFile.path)).then((value) {
                                StoreProvider.of<AppState>(context).dispatch(getUser());
                                setState(() {
                                  Prefs.setString(
                                      Prefs.PROFILEIMAGE, StoreProvider.of<AppState>(context).state.user.user.data.image);
                                });
                                // Navigator.pop(context);
                              });
                            else
                              user.uploadImage2(null);

                            if (Prefs.getString(Prefs.USER_TYPE) == 'USER') {
                              // user_cv.experience_year = int.parse(experience_year_controller.text);
                              // user_cv.job_title = title_controller.text;

                              if (attachment != null)
                                user_cv.save(attachment: attachment);
                              else
                                user_cv.save();
                            }

                            Navigator.pop(context);

                          } else {
                            return;
                          }

                          /// Remove previous screens
                        },
                        text: 'save'.tr(),
                      ),
                    ),
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
