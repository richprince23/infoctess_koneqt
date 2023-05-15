import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_quill/flutter_quill.dart' hide Text;
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:infoctess_koneqt/constants.dart';
import 'package:infoctess_koneqt/controllers/events_controller.dart';
import 'package:infoctess_koneqt/env.dart';
import 'package:intl/intl.dart';
import 'package:resize/resize.dart';
import 'package:status_alert/status_alert.dart';

class CreateEvent extends StatefulWidget {
  @override
  _CreateEventState createState() => _CreateEventState();
}

class _CreateEventState extends State<CreateEvent> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _venueController = TextEditingController();
  final TextEditingController _feeController = TextEditingController(text: "0");
  final QuillController _quillController = QuillController.basic();
  final TextEditingController _timeRangeController = TextEditingController();
  late final _content = _quillController.document.toDelta();

  String? _selectedMode;
  bool _isOnline = false;
  bool _isHybrid = false;
  bool _isLoading = false;
  late TimeOfDay _startTime;
  late TimeOfDay _endTime;

  Map<String, String> fontSizes = {
    "16": "16",
    "20": "20",
    "24": "24",
    "28": "28",
    "32": "32",
    "36": "26",
    "40": "40",
    "44": "44",
    "48": "48",
    "52": "52",
  };

  Future<void> _selectTimeRange() async {
    final TimeRange? pickedTimeRange = await showTimeRangePicker(
      context: context,
      initialStartTime: TimeOfDay.now(),
      initialEndTime:
          TimeOfDay.fromDateTime(DateTime.now().add(const Duration(hours: 1))),
    );

    if (pickedTimeRange != null) {
      setState(() {
        _startTime = pickedTimeRange.startTime;
        _endTime = pickedTimeRange.endTime;
        _timeRangeController.text =
            '${_startTime.format(context)} - ${_endTime.format(context)}';
      });
    }
  }

  Future<void> _createEvent() async {
    setState(() {
      _isLoading = true;
    });

    if (_content.isNotEmpty) {
      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) => Center(
          child: Image.asset(
            "assets/images/preload.gif",
            width: 50.w,
            height: 50.w,
          ),
        ),
      );
      // send the news post
      var json = jsonEncode(_content.toJson());
      postNewEvent(
        title: _titleController.text,
        date: _dateController.text,
        venue: _venueController.text,
        fee: double.parse(_feeController.text),
        mode: _selectedMode!,
        body: json,
        imagePath: croppedMedia?.path,
        time: _timeRangeController.text,
      ).then(
        (value) {
          Navigator.pop(context);
          StatusAlert.show(
            context,
            duration: const Duration(seconds: 2),
            title: "Sent",
            titleOptions: StatusAlertTextConfiguration(
              style: TextStyle(
                color: Colors.white,
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            maxWidth: 50.vw,
            configuration: IconConfiguration(
              icon: Icons.check,
              color: Colors.green,
              size: 50.w,
            ),
          );
          setState(() {
            _titleController.clear();
            croppedMedia = null;
            selectedMedia = null;
          });
          Navigator.of(context, rootNavigator: true).pop();
        },
      );
    }

    setState(() {
      _isLoading = false;
    });
  }

  bool isEmtpyText = true;

  XFile? selectedMedia;
  CroppedFile? croppedMedia;

  Future<void> cropImage() async {
    if (selectedMedia != null) {
      final croppedFile = await ImageCropper().cropImage(
        sourcePath: selectedMedia!.path,
        compressFormat: ImageCompressFormat.jpg,
        compressQuality: 20,
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: 'Crop Media',
            toolbarColor: Colors.black,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.ratio3x2,
            lockAspectRatio: false,
            showCropGrid: true,
            hideBottomControls: false,
          ),
          IOSUiSettings(
            title: 'Crop Media',
            rotateButtonsHidden: false,
            rotateClockwiseButtonHidden: false,
          ),
        ],
      );
      if (croppedFile != null) {
        setState(() {
          croppedMedia = croppedFile;
          // selectedMedia = croppedFile as XFile;
        });
      }
    }
  }

  Future<void> uploadImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        selectedMedia = pickedFile;
      });
    }
  }

  void clear() {
    setState(() {
      selectedMedia = null;
      croppedMedia = null;
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _dateController.dispose();
    _venueController.dispose();
    _feeController.dispose();
    _quillController.dispose();
    _timeRangeController.dispose();
    selectedMedia = null;
    croppedMedia = null;
    super.dispose();
  }

  final inputDecoration = InputDecoration(
    contentPadding: const EdgeInsets.all(10),
    labelText: 'News Title',
    fillColor: const Color.fromRGBO(217, 217, 217, 0.6),
    filled: true,
    focusedBorder: UnderlineInputBorder(
      borderSide: BorderSide(
        color: cSec,
        width: 2,
      ),
    ),
    enabledBorder: UnderlineInputBorder(
      borderSide: BorderSide(
        color: cSec.withOpacity(0.8),
        width: 0.5,
      ),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return KeyboardDismissOnTap(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Create Event'),
        ),
        body: _isLoading
            ? Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        Stack(
                          children: [
                            SizedBox(
                              child: AnimatedContainer(
                                margin: EdgeInsets.only(bottom: 10.h),
                                duration: const Duration(milliseconds: 200),
                                height: 30.vh,
                                width: 80.vw,
                                child: (croppedMedia != null ||
                                        selectedMedia != null)
                                    ? _imageCard()
                                    : Image.asset(
                                        "assets/images/placeholder.png",
                                        fit: BoxFit.cover,
                                      ),
                              ),
                            ),
                            Positioned(
                              bottom: 5,
                              right: 0,
                              child: IconButton(
                                style: IconButton.styleFrom(
                                  shape: const CircleBorder(),
                                  elevation: 5,
                                  padding: EdgeInsets.all(12.w),
                                  backgroundColor: cSec,
                                  foregroundColor: Colors.white,
                                ),
                                onPressed: () async {
                                  await uploadImage()
                                      .then((value) => cropImage());
                                },
                                icon: const Icon(Icons.add_a_photo_outlined),
                              ),
                            ),
                          ],
                        ),
                        TextFormField(
                          controller: _titleController,
                          decoration: inputDecoration.copyWith(
                            labelText: 'Event Title',
                            prefixIcon: const Icon(Icons.title),
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter a title';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 10.0.h),
                        TextFormField(
                          controller: _dateController,
                          decoration: inputDecoration.copyWith(
                            labelText: 'Event Date',
                            prefixIcon: const Icon(Icons.date_range),
                          ),
                          readOnly: true,
                          onTap: () async {
                            final date = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime.now(),
                              lastDate: DateTime(2100),
                            );
                            if (date != null) {
                              _dateController.text =
                                  DateFormat('dd/MM/yyyy').format(date);
                            }
                          },
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter a date';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 10.h),
                        TextFormField(
                          controller: _timeRangeController,
                          decoration: inputDecoration.copyWith(
                            labelText: 'Time',
                            prefixIcon: IconButton(
                              icon: const Icon(Icons.access_time),
                              onPressed: _selectTimeRange,
                            ),
                          ),
                          onTap: _selectTimeRange,
                          readOnly: true,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please select a time range';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 10.h),
                        TextFormField(
                          controller: _venueController,
                          decoration: inputDecoration.copyWith(
                            labelText: 'Venue',
                            prefixIcon: const Icon(Icons.location_on),
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter a venue';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 10.h),
                        DropdownButtonFormField<String>(
                          value: _selectedMode,
                          items: const [
                            DropdownMenuItem(
                              value: 'in-person',
                              child: Text('In-person'),
                            ),
                            DropdownMenuItem(
                              value: 'online',
                              child: Text('Online'),
                            ),
                            DropdownMenuItem(
                              value: 'hybrid',
                              child: Text('Hybrid'),
                            ),
                          ],
                          onChanged: (value) {
                            setState(() {
                              _selectedMode = value;
                              _isOnline = value == 'online';
                              _isHybrid = value == 'hybrid';
                            });
                          },
                          decoration: inputDecoration.copyWith(
                            labelText: 'Mode',
                            border: const OutlineInputBorder(),
                            prefixIcon: const Icon(Icons.co_present),
                          ),
                        ),
                        SizedBox(height: 10.h),
                        TextFormField(
                          controller: _feeController,
                          decoration: inputDecoration.copyWith(
                            labelText: 'Fee',
                            prefixIcon: const Icon(Icons.attach_money),
                          ),
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter a fee';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 10.h),
                        SizedBox(
                          child: QuillToolbar.basic(
                            multiRowsDisplay: false,
                            iconTheme: const QuillIconTheme(
                              iconUnselectedColor: Colors.black87,
                            ),
                            axis: Axis.horizontal,
                            controller: _quillController,
                            showAlignmentButtons: true,
                            showCodeBlock: true,
                            showColorButton: true,
                            showClearFormat: true,
                            showBackgroundColorButton: false,
                            showHeaderStyle: false,
                            showLink: true,
                            showQuote: false,
                            showDividers: true,
                            fontSizeValues: fontSizes,
                            showInlineCode: false,
                          ),
                        ),
                        SizedBox(height: 10.h),
                        AnimatedContainer(
                          duration: const Duration(seconds: 0),
                          // height: 30.vh,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(
                              color: cSec,
                            ),
                          ),
                          height: 40.vh,
                          child: QuillEditor(
                            maxHeight: 20.vh,
                            textCapitalization: TextCapitalization.sentences,
                            scrollable: true,
                            expands: true,
                            autoFocus: false,
                            focusNode: FocusNode(),
                            padding: EdgeInsets.all(10.w),
                            scrollController: ScrollController(),
                            controller: _quillController,
                            readOnly: false,
                            customStyles: DefaultStyles(
                              paragraph: DefaultTextBlockStyle(
                                TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.normal,
                                  fontSize: 16.sp,
                                ),
                                const VerticalSpacing(8, 0),
                                const VerticalSpacing(0, 0),
                                null,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 10.h),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: cPri,
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(
                              horizontal: 20.w,
                              vertical: 10.h,
                            ),
                            fixedSize: btnLarge(context),
                          ),
                          onPressed: () {
                            if (_formKey.currentState!.validate() &&
                                _selectedMode != null &&
                                _quillController.document
                                    .toPlainText()
                                    .isNotEmpty) {
                              _createEvent();
                            }
                          },
                          child: Text(
                            'Create Event',
                            style: TextStyle(fontSize: 16.sp),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
      ),
    );
  }

  Widget _image() {
    if (croppedMedia != null) {
      final path = croppedMedia!.path;
      return Image.file(
        File(path),
        fit: BoxFit.cover,
      );
    } else {
      return const SizedBox.shrink();
    }
  }

  Widget _imageCard() {
    return Center(
      child: Stack(
        children: [
          Card(
            child: _image(),
          ),
          Positioned(
            top: 4.h,
            right: 4.w,
            width: 20.w,
            height: 20.h,
            child: IconButton(
              style: IconButton.styleFrom(
                padding: EdgeInsets.all(5.r),
                backgroundColor: Colors.white,
              ),
              onPressed: clear,
              icon: const Icon(CupertinoIcons.clear_thick),
              iconSize: 12.w,
            ),
          ),
        ],
      ),
    );
  }
}

class TimeRange {
  final TimeOfDay startTime;
  final TimeOfDay endTime;

  TimeRange({required this.startTime, required this.endTime});
}

Future<TimeRange?> showTimeRangePicker({
  required BuildContext context,
  required TimeOfDay initialStartTime,
  required TimeOfDay initialEndTime,
}) async {
  TimeOfDay startTime = initialStartTime;
  TimeOfDay endTime = initialEndTime;

  await showTimePicker(
    context: context,
    initialTime: initialStartTime,
    builder: (BuildContext context, Widget? child) {
      return MediaQuery(
        data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
        child: child!,
      );
    },
  ).then((pickedStartTime) {
    if (pickedStartTime != null) {
      startTime = pickedStartTime;
    }
  }).then((value) async => await showTimePicker(
        context: context,
        initialTime: initialEndTime,
        builder: (BuildContext context, Widget? child) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
            child: child!,
          );
        },
      ).then((pickedEndTime) {
        if (pickedEndTime != null) {
          endTime = pickedEndTime;
        }
      }));

  if (startTime != null && endTime != null) {
    return TimeRange(startTime: startTime, endTime: endTime);
  } else {
    return null;
  }
}
