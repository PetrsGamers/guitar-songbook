import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:guitar_app/entities/chord.dart';

class AddMetadata extends StatefulWidget {
  const AddMetadata(
      {super.key, required this.nextScreenCallback, required this.onSubmit});
  final Function(bool) nextScreenCallback;
  final Function(String, String, String, String, String) onSubmit;

  @override
  State<AddMetadata> createState() => _AddMetadataState();
}

class _AddMetadataState extends State<AddMetadata> {
  String dropdownSongKeyValue = Chord.circleOfFifths.first;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _controllerSongName = TextEditingController();
  final TextEditingController _controllerMusician = TextEditingController();
  final TextEditingController _controllerBPM = TextEditingController();
  final TextEditingController _controllerYear = TextEditingController();

  String? validateInputDefault(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter some text';
    }
    return null;
  }

  String? validateBPM(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter some number';
    }
    if (int.parse(value) < 30 || int.parse(value) > 200) {
      return "Enter valid range from 30 to 200";
    }
    return null;
  }

  String? validateYear(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter some number';
    }
    if (int.parse(value) < 0 || int.parse(value) > DateTime.now().year) {
      return "Enter valid range from 0 to ${DateTime.now().year}";
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Align(
        alignment: Alignment.center,
        child: Padding(
          padding: const EdgeInsets.only(top: 32),
          child: SizedBox(
            width: 400,
            child: Column(
              children: [
                Form(
                    key: _formKey,
                    child: Column(children: [
                      TextFormField(
                          validator: validateInputDefault,
                          decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: 'Song Name'),
                          controller: _controllerSongName),
                      TextFormField(
                          validator: validateInputDefault,
                          decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: 'Musician / band'),
                          controller: _controllerMusician),
                      TextFormField(
                          validator: validateBPM,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: 'Song BPM'),
                          controller: _controllerBPM),
                      TextFormField(
                          validator: validateYear,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: 'Year (release date)'),
                          controller: _controllerYear),
                      SizedBox(
                        width: 400,
                        child: DropdownButton(
                            value: dropdownSongKeyValue,
                            items: Chord.songKeys
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                dropdownSongKeyValue = value!;
                              });
                            }),
                      )
                    ])),
                //const Spacer(),
                Padding(
                  padding: const EdgeInsets.only(top: 16, bottom: 46),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      OutlinedButton(
                          onPressed: () {
                            widget.nextScreenCallback(false);
                          },
                          child: const Text("Cancel everything")),
                      ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text(
                                          'Submitting Data, thanks for contributing :)')));
                              widget.onSubmit(
                                  _controllerSongName.text,
                                  _controllerMusician.text,
                                  _controllerBPM.text,
                                  _controllerYear.text,
                                  dropdownSongKeyValue);
                              widget.nextScreenCallback(true);
                            }
                          },
                          child: const Text("Submit song!")),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
