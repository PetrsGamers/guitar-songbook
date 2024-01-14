import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:guitar_app/entities/chord.dart';
import 'package:guitar_app/screens/create/song_submit_validator.dart';

class AddMetadata extends StatefulWidget {
  const AddMetadata(
      {super.key, required this.nextScreenCallback, required this.onSubmit});
  final Function(bool) nextScreenCallback;
  final Function(String, String, String, String, String) onSubmit;

  @override
  State<AddMetadata> createState() => _AddMetadataState();
}

class _AddMetadataState extends State<AddMetadata> {
  String _dropdownSongKeyValue = Chord.circleOfFifths.first;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _controllerSongName = TextEditingController();
  final TextEditingController _controllerMusician = TextEditingController();
  final TextEditingController _controllerBPM = TextEditingController();
  final TextEditingController _controllerYear = TextEditingController();

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
                _buildSongSubmitForm(),
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
                            if (!_formKey.currentState!.validate()) {
                              return;
                            }
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text(
                                        'Submitting Data, thanks for contributing :)')));
                            widget.onSubmit(
                                _controllerSongName.text,
                                _controllerMusician.text,
                                _controllerBPM.text,
                                _controllerYear.text,
                                _dropdownSongKeyValue);
                            widget.nextScreenCallback(true);
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

  Form _buildSongSubmitForm() {
    return Form(
        key: _formKey,
        child: Column(children: [
          TextFormField(
              validator: SongSubmitValidator.validateInputDefault,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(), hintText: 'Song Name'),
              controller: _controllerSongName),
          TextFormField(
              validator: SongSubmitValidator.validateInputDefault,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(), hintText: 'Musician / band'),
              controller: _controllerMusician),
          TextFormField(
              validator: SongSubmitValidator.validateBPM,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: const InputDecoration(
                  border: OutlineInputBorder(), hintText: 'Song BPM'),
              controller: _controllerBPM),
          TextFormField(
              validator: SongSubmitValidator.validateYear,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Year (release date)'),
              controller: _controllerYear),
          SizedBox(
            width: 400,
            child: DropdownButton(
                value: _dropdownSongKeyValue,
                items: Chord.songKeys
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _dropdownSongKeyValue = value!;
                  });
                }),
          )
        ]));
  }
}
