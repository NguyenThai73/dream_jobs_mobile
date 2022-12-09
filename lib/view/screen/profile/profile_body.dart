// ignore_for_file: avoid_unnecessary_containers, must_be_immutable, camel_case_types, constant_identifier_names, deprecated_member_use, use_build_context_synchronously
import 'package:an_toan_bao_mat_trong_ptpmdd/model/careers.dart';
import 'package:an_toan_bao_mat_trong_ptpmdd/view/common/color.dart';
import 'package:an_toan_bao_mat_trong_ptpmdd/view/components/edit_input.dart';
import 'package:custom_radio_grouped_button/custom_radio_grouped_button.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:io';
import '../../../controllers/provider.dart';
import '../../common/style.dart';
import '../../components/app_text_fields.dart';
import '../../components/date_picker_box.dart';

class ProfileBody extends StatefulWidget {
  bool checkEdit;
  ProfileBody({super.key, required this.checkEdit});
  @override
  State<ProfileBody> createState() => _ProfileBodyState();
}

enum gioiTinh { Nam, Nu, Khac }

class _ProfileBodyState extends State<ProfileBody> {
  gioiTinh? _character;

  List<String> listEducational = [
    "Tốt nghiệp tiểu học",
    "Tốt nghiệp THCS",
    "Tốt nghiệp THPT",
    "Tốt nghiệp Cao đẳng",
    "Tốt nghiệp Đại học",
    "Thạc sĩ/Tiến sĩ",
    "Phó GS,GS",
    "Khác"
  ];
  Careers selectedItem = Careers(id: 0, name: "");
  @override
  void initState() {
    super.initState();
    var user = Provider.of<User>(context, listen: false);
    if (user.user.height != null && user.user.career != null) {
      selectedItem = Careers(id: user.user.height, name: user.user.career);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<User>(builder: (context, user, child) {
      return Container(
        width: MediaQuery.of(context).size.width * 1,
        // ignore: prefer_const_constructors
        decoration: BoxDecoration(
          border: const Border(
            top: BorderSide(
              color: maincolor,
              width: 1.0,
            ),
          ),
        ),
        child: Stack(
          children: <Widget>[
            Positioned(
              top: (MediaQuery.of(context).size.width / 2.6) - 24.0,
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 193, 231, 247),
                  borderRadius: const BorderRadius.only(topLeft: Radius.circular(32.0), topRight: Radius.circular(32.0)),
                  boxShadow: <BoxShadow>[
                    BoxShadow(color: colorBlack.withOpacity(0.2), offset: const Offset(1.1, 1.1), blurRadius: 10.0),
                  ],
                ),
                padding: const EdgeInsets.only(left: 10, right: 10),
                child: Padding(
                  padding: const EdgeInsets.only(left: 8, right: 8),
                  child: SingleChildScrollView(
                    child: Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          const SizedBox(height: 100),
                          (!widget.checkEdit)
                              ? Center(
                                  child: OutlinedButton(
                                  onPressed: () async {
                                    FilePickerResult? result = await FilePicker.platform.pickFiles();

                                    if (result != null) {
                                      String fileName = result.files.first.name;
                                      String path = result.files.first.path ?? "";
                                      await FirebaseStorage.instance.ref('image/avatar/$fileName').putFile(File(path));
                                      setState(() {
                                        user.user.avatar =
                                            "https://firebasestorage.googleapis.com/v0/b/store-image-a4f19.appspot.com/o/image%2Favatar%2F$fileName?alt=media";
                                      });
                                    }
                                  },
                                  child: const Text(
                                    "Thay ảnh",
                                    style: textAppStyle,
                                  ),
                                ))
                              : Row(),
                          (!widget.checkEdit) ? const SizedBox(height: 20) : Row(),
                          EditInput(
                            widget: Row(
                              children: [
                                Expanded(
                                    flex: 2,
                                    child: Text(
                                      "Họ tên",
                                      style: AppStyles.medium(),
                                    )),
                                Expanded(
                                  flex: 5,
                                  child: (!widget.checkEdit)
                                      ? AppTextFields(
                                          hint: '',
                                          controller: TextEditingController(text: "${user.user.fullname}"),
                                          onChanged: (name) {
                                            user.user.fullname = name;
                                          },
                                        )
                                      : Text("${user.user.fullname}", style: AppStyles.appTextStyle()),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),
                          EditInput(
                            widget: Row(
                              children: [
                                Expanded(
                                    flex: 2,
                                    child: Text(
                                      "Email",
                                      style: AppStyles.medium(),
                                    )),
                                Expanded(
                                  flex: 5,
                                  child: Text("${user.user.email}", style: AppStyles.appTextStyle()),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),
                          EditInput(
                            widget: Row(
                              children: [
                                Expanded(
                                    flex: 2,
                                    child: Text(
                                      "SĐT",
                                      style: AppStyles.medium(),
                                    )),
                                Expanded(
                                    flex: 5,
                                    child: (!widget.checkEdit)
                                        ? AppTextFields(
                                            hint: '',
                                            controller:
                                                TextEditingController(text: (user.user.sdt != null && user.user.sdt != "") ? "${user.user.sdt}" : ""),
                                            onChanged: (name) {
                                              user.user.sdt = name;
                                            },
                                          )
                                        : (user.user.sdt != null && user.user.sdt != "")
                                            ? Text("${user.user.sdt}", style: AppStyles.appTextStyle())
                                            : const Text("")),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),
                          EditInput(
                            widget: SizedBox(
                                height: 50,
                                child: (!widget.checkEdit)
                                    ? DatePickerBox(
                                        label: Text(
                                          'Ngày sinh',
                                          style: AppStyles.medium(),
                                        ),
                                        flexLabel: 2,
                                        flexDatePiker: 5,
                                        realTime: (user.user.birthday != null && user.user.birthday != "") ? user.user.birthday : null,
                                        callbackValue: (value) {
                                          user.user.birthday = value;
                                        },
                                      )
                                    : Row(
                                        children: [
                                          Expanded(
                                              flex: 2,
                                              child: Text(
                                                "Ngày sinh",
                                                style: AppStyles.medium(),
                                              )),
                                          Expanded(
                                            flex: 5,
                                            child: (user.user.birthday != null && user.user.birthday != "")
                                                ? Text("${user.user.birthday}", style: AppStyles.appTextStyle())
                                                : const Text(""),
                                          )
                                        ],
                                      )),
                          ),
                          const SizedBox(height: 20),
                          EditInput(
                            widget: (!widget.checkEdit)
                                ? Row(
                                    children: [
                                      Expanded(
                                          flex: 2,
                                          child: Text(
                                            "Giới tính",
                                            style: AppStyles.medium(),
                                          )),
                                      Expanded(
                                        flex: 5,
                                        child: CustomRadioButton(
                                          width: 80,
                                          elevation: 0,
                                          unSelectedColor: maincolor,
                                          // ignore: prefer_const_literals_to_create_immutables
                                          buttonLables: [
                                            'Nam',
                                            'Nữ',
                                          ],
                                          // ignore: prefer_const_literals_to_create_immutables
                                          buttonValues: [
                                            "0",
                                            "1",
                                          ],
                                          defaultSelected: (user.user.gender != null) ? user.user.gender.toString() : "0",
                                          buttonTextStyle:
                                              ButtonTextStyle(selectedColor: colorWhite, unSelectedColor: colorBlack, textStyle: AppStyles.medium()),
                                          radioButtonValue: (value) {
                                            // print(value);
                                            int gender = int.parse(value.toString());
                                            user.user.gender = gender;
                                          },
                                          selectedColor: maincolor,
                                          selectedBorderColor: maincolor,
                                          unSelectedBorderColor: maincolor,
                                        ),
                                      ),
                                    ],
                                  )
                                : Row(
                                    children: [
                                      Expanded(
                                          flex: 2,
                                          child: Text(
                                            "Giới tính",
                                            style: AppStyles.medium(),
                                          )),
                                      Expanded(
                                        flex: 5,
                                        child: (user.user.gender != null)
                                            ? (user.user.gender == 0)
                                                ? Text("Nam", style: AppStyles.appTextStyle())
                                                : Text("Nữ", style: AppStyles.appTextStyle())
                                            : const Text(""),
                                      )
                                    ],
                                  ),
                          ),
                          const SizedBox(height: 20),
                          EditInput(
                            widget: Row(
                              children: [
                                Expanded(
                                    flex: 2,
                                    child: Text(
                                      "CCCD",
                                      style: AppStyles.medium(),
                                    )),
                                Expanded(
                                    flex: 5,
                                    child: (!widget.checkEdit)
                                        ? AppTextFields(
                                            hint: '',
                                            controller: TextEditingController(text: (user.user.idCardNo != null) ? "${user.user.idCardNo}" : ""),
                                            onChanged: (name) {
                                              user.user.idCardNo = name;
                                            },
                                          )
                                        : (user.user.idCardNo != null)
                                            ? Text("${user.user.idCardNo}", style: AppStyles.appTextStyle())
                                            : const Text("")),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),
                          EditInput(
                            widget: Row(
                              children: [
                                Expanded(
                                    flex: 2,
                                    child: Text(
                                      "Địa chỉ",
                                      style: AppStyles.medium(),
                                    )),
                                Expanded(
                                    flex: 5,
                                    child: (!widget.checkEdit)
                                        ? AppTextFields(
                                            hint: '',
                                            controller: TextEditingController(text: (user.user.addRess != null) ? "${user.user.addRess}" : ""),
                                            onChanged: (name) {
                                              user.user.addRess = name;
                                            },
                                          )
                                        : (user.user.addRess != null)
                                            ? Text("${user.user.addRess}", style: AppStyles.appTextStyle())
                                            : const Text("")),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),
                          EditInput(
                            widget: Row(
                              children: [
                                Expanded(
                                    flex: 2,
                                    child: Text(
                                      "Ngành",
                                      style: AppStyles.medium(),
                                    )),
                                Expanded(
                                    flex: 5,
                                    child: (!widget.checkEdit)
                                        ? DropdownSearch<Careers>(
                                            mode: Mode.MENU,
                                            maxHeight: 350,
                                            showSearchBox: true,
                                            onFind: (String? filter) => getListCareers(context),
                                            itemAsString: (Careers? u) => "${u!.name}",
                                            dropdownSearchDecoration: styleDropDown,
                                            selectedItem: selectedItem,
                                            onChanged: (value) {
                                              selectedItem = value!;
                                              user.user.height = value.id;
                                              user.user.career = value.name;
                                            },
                                          )
                                        : (user.user.career != null)
                                            ? Text("${user.user.career}", style: AppStyles.appTextStyle())
                                            : const Text("")),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),
                          EditInput(
                            widget: Row(
                              children: [
                                Expanded(
                                    flex: 2,
                                    child: Text(
                                      "CV",
                                      style: AppStyles.medium(),
                                    )),
                                Expanded(
                                  flex: 5,
                                  child: (!widget.checkEdit)
                                      ? IconButton(
                                          onPressed: () async {
                                            FilePickerResult? result = await FilePicker.platform.pickFiles();

                                            if (result != null) {
                                              String fileName = result.files.first.name;
                                              String path = result.files.first.path ?? "";
                                              await FirebaseStorage.instance.ref('image/cv/$fileName').putFile(File(path));
                                              setState(() {
                                                user.user.cv =
                                                    "https://firebasestorage.googleapis.com/v0/b/store-image-a4f19.appspot.com/o/image%2Favatar%2F$fileName?alt=media";
                                              });
                                            }
                                          },
                                          icon: Icon(Icons.upload))
                                      : (user.user.cv != null)
                                          ? Row(
                                              children: [
                                                TextButton(
                                                    onPressed: () {},
                                                    child: Text(
                                                      "Đã tải CV (Nhấn để tải xuống)",
                                                      style: AppStyles.appTextStyle(color: colorBlack),
                                                    )),
                                              ],
                                            )
                                          : Text(""),
                                )
                              ],
                            ),
                          ),
                          const SizedBox(height: 60),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              child: Column(
                children: <Widget>[
                  const SizedBox(height: 25),
                  Center(
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: maincolor, width: 5),
                        borderRadius: BorderRadius.circular(120),
                        color: maincolor
                      ),
                      child: (user.user.avatar == "" || user.user.avatar == null)
                          ? ClipOval(
                              //  clipper:C,
                              child: Image.network('https://scr.vn/wp-content/uploads/2020/07/Avatar-Facebook-tr%E1%BA%AFng.jpg',
                                  width: 200, height: 200, fit: BoxFit.cover),
                            )
                          : ClipOval(
                              //  clipper:C,
                              child: Image.network(user.user.avatar!, width: 200, height: 200, fit: BoxFit.cover),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }
}
