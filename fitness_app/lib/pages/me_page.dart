import 'dart:async';

import 'package:fitness_app/helpers/BMR.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:convert';
import 'dart:io';

class MePage extends StatefulWidget {
  const MePage({super.key});

  @override
  State<MePage> createState() => _MePageState();

}

class _MePageState extends State<MePage> {

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    readPersonalFile();
    readWeightFile();
    readBMRFile();
    Timer(Duration(milliseconds: 250), (() {
      setState(() {
        isLoading = false;
      });
      }));
    //resetWeightFile();
    

  } 

  void dropDownCallback(String? selectedValue){ //For dropdown menu
    if (selectedValue is String && _editEnabled){
      setState(() {
        _dropdownValue = selectedValue;
      });
    }
  }

  bool verifyPersonalInputs(){
    
    if(!RegExp(r'^[A-Za-z]+$').hasMatch(_nameTextController.text)){
      final snackBar = SnackBar(content: Text('Enter a valid name'),
              duration: Duration(seconds: 2));
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return false;
    }
    else if(!RegExp(r'^[0-9]+$').hasMatch(_ageTextController.text)){
      final snackBar = SnackBar(content: Text('Enter a valid age'),
              duration: Duration(seconds: 2));
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return false;
    }
    else if(_dropdownValue == null){
      final snackBar = SnackBar(content: Text('You must select a gender'),
              duration: Duration(seconds: 2));
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return false;
    }
    else if(!RegExp(r'^(\d*\.)?\d+$').hasMatch(_heightTextController.text)){
      final snackBar = SnackBar(content: Text('Height can only contain numbers'),
              duration: Duration(seconds: 2));
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return false;
    }
    else{
      return true;
    }
    
  }

  bool verifyWeightInput(){

    if(!RegExp(r'^(\d*\.)?\d+$').hasMatch(_weightTextController.text)){
      final snackBar = SnackBar(content: Text('Weight can only contain numbers'),
              duration: Duration(seconds: 2));
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return false;
    }
    
    return true;
  }

  //Personal File Stuff//////////////////////////////////////////////////////////////////////
  // Save personal Info.
  Future<void> savePersonalInfo(String name, String age, String? gender, String height) async {

    var personalMap={
      "name":name,
      "age":age,
      "gender":gender,
      "height":height
    };

    String encodedPersonalInfo = jsonEncode(personalMap);

    final personalInfoFile = await _localPersonalFile;

    personalInfoFile.writeAsString(encodedPersonalInfo);
  
  }

  Future<File> get _BMRFile async {
  final path = await _localPath;
  return File('$path/BMR.txt');
  }

  Future<void> readBMRFile() async {
  try {
    final file = await _BMRFile;

    // Read the file
    final contents = await file.readAsString();
    
    setState(() {
      _BMRTextController.text = contents;
    });

    
    } catch (e) {
    // If encountering an error, return 0
    }
  }

  Future<void> saveBMRInfo(int BMR) async {

    final file = await _BMRFile;
    file.writeAsString(BMR.toString());
  
  }

  //Read Personal info file
  Future<void> readPersonalFile() async {
  try {
    final file = await _localPersonalFile;

    // Read the file
    final contents = await file.readAsString();
    Map<String, dynamic> decodedContents = await jsonDecode(contents);

    // Fill in details
    _nameTextController.text = decodedContents["name"];
    _ageTextController.text = decodedContents["age"];
    setState(() {
      _dropdownValue = decodedContents["gender"];
    });
    _heightTextController.text = decodedContents["height"];
    } catch (e) {
    // If encountering an error, return 0
    }
  }

  // Get app document directory
  Future<String> get _localPath async {
  final directory = await getApplicationDocumentsDirectory();

  return directory.path;
  }

  // Get file directory
  Future<File> get _localPersonalFile async {
  final path = await _localPath;
  return File('$path/userPersonalInfo.json');
  }
  //Personal File Stuff//////////////////////////////////////////////////////////////////////

  //Weight File Stuff////////////////////////////////////////////////////////////////////////

  Future<void> resetWeightFile() async{
    final file = await _localWeightFile;
    file.writeAsString("[]");
  }

  Future<void> saveWeightInfo(String weight) async {

    final file = await _localWeightFile;

    try{
      final contents = await file.readAsString();
    }
    catch(e){
      final file = await _localWeightFile;
      file.writeAsString("[]");

    }

    final contents = await file.readAsString();

    List<dynamic> decodedContents = await jsonDecode(contents);
    
    DateTime now = DateTime.now();
    DateTime date = DateTime(now.year, now.month);
    String formattedDate = date.toString().substring(0,10);
    
    var weightMap={
      "weight":weight,
      "date":formattedDate
    };

    bool dateInSave = false;

    if(decodedContents.isEmpty){
      decodedContents.add(weightMap);
    }
    else{
      for(var element in decodedContents){
        if(element["date"] == formattedDate){
          dateInSave = true;
          break;
        }
      }
      if(!dateInSave){
        decodedContents.add(weightMap);
      }
    }

    for(var i = 0; i < decodedContents.length; i++){
      if(decodedContents[i]["date"] == formattedDate){
        decodedContents[i] = weightMap;
      }
    }

    String encodedWeightInfo = jsonEncode(decodedContents);

    print(encodedWeightInfo);

    final weightFile = await _localWeightFile;

    weightFile.writeAsString(encodedWeightInfo);
  
  }

  Future<File> get _localWeightFile async {
  final path = await _localPath;
  return File('$path/weightInfo.json');
  }

  Future<void> readWeightFile() async {
  try {
    final file = await _localWeightFile;

    // Read the file
    final contents = await file.readAsString();
    List<dynamic> decodedContents = await jsonDecode(contents);

    DateTime now = DateTime.now();
    DateTime date = DateTime(now.year, now.month);
    String formattedDate = date.toString().substring(0,10);

    for(var element in decodedContents){
      if(formattedDate == element["date"]){
        _weightTextController.text = element["weight"];
      }
    }

    } catch (e) {
      final file = await _localWeightFile;
      file.writeAsString("[]");
    }
  }

  //Weight File Stuff////////////////////////////////////////////////////////////////////////

  setBMR(){
    // ignore: non_constant_identifier_names
    int BMR = BMRCalculator(int.parse(_ageTextController.text), _dropdownValue.toString(),
     double.parse(_heightTextController.text), double.parse(_weightTextController.text)).getBMR();

    saveBMRInfo(BMR);
    readBMRFile();
    
  }

  final _nameTextController = TextEditingController();
  final _ageTextController = TextEditingController();
  final _heightTextController = TextEditingController();
  final _weightTextController = TextEditingController();
  //Text editing controllers
  final _BMRTextController = TextEditingController();
  
  bool _editEnabled = false;
  bool _updateEnabled = false;
  bool _notUpdateEnabled = true;

  String? _dropdownValue;

  // ignore: non_constant_identifier_names

  @override
  Widget build(BuildContext context) => Scaffold(
      resizeToAvoidBottomInset : false,

    body: Stack(

    children: [
      
      SingleChildScrollView(
      
      child: Column(
        
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[

        Padding(padding: EdgeInsets.symmetric(vertical: 10)),

        Center(
          child: Text("WELCOME BACK",
          style: TextStyle(fontSize: 40))
          ),

        SizedBox( //For no picture
          width: double.infinity,

          child: IconButton(
            icon: Icon(Icons.person),
            iconSize: 100,
            onPressed: () {

            } ,
          )
        ),

        Center(
          child: Text("About Me:",
            style: TextStyle(fontSize: 25)) 
        ),  

        SizedBox(
          width: 450,
          height: 300,
          child: ListView(
            padding: EdgeInsets.zero,
            children: [

              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)
                ),
                child: ListTile(
                  visualDensity:VisualDensity(horizontal: 0, vertical: -1),
                  title: Text("Name"),
                  trailing: SizedBox(
                    width: 120,
                    height: 25,
                    child: TextField(
                      controller: _nameTextController,
                      maxLength: 10,
                      decoration: InputDecoration(
                        counterText: "",
                      ),      
                      enabled: _editEnabled,
                      textAlignVertical: TextAlignVertical.bottom,
                      textAlign: TextAlign.center,     
                    )
                  )   
                )
              ),

              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)
                ),
                child: ListTile(
                  visualDensity:VisualDensity(horizontal: 0, vertical: -1),
                  title: Text("Age"),
                  trailing: SizedBox(
                      width: 120,
                      height: 25,
                      child: TextField(
                        maxLength: 3,
                        decoration: InputDecoration(
                        counterText: "",
                          ),    
                        keyboardType: TextInputType.datetime,
                        controller: _ageTextController,
                        enabled: _editEnabled,                 
                        textAlign: TextAlign.center,       
                    )
                  )      
                )
              ),

              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)
                ),
                child: ListTile(
                  visualDensity:VisualDensity(horizontal: 0, vertical: -1),
                  title: Text("Gender"),
                  trailing: SizedBox(
                    width: 120,
                    height: 60,
                    child: IgnorePointer(
                      ignoring: !_editEnabled,         
                      child: DropdownButtonFormField( 
                        alignment: Alignment.center,
                        decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(horizontal: 15),
                        hintText: "Gender",
                      ),
                    
                      items: const [
                        DropdownMenuItem(value: "Male", child: Text("Male")),
                        DropdownMenuItem(value: "Female", child: Text("Female")),
                        DropdownMenuItem(value: "Other", child: Text("Other")),
                      
                      ],
                      onChanged: dropDownCallback,
                      value: _dropdownValue                                          
                      ) 
                    ) 
                  )
                )
              ),

              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)
                ),
                child: ListTile(
                  visualDensity:VisualDensity(horizontal: 0, vertical: -1),
                  title: Text("Height (cm)"),
                  trailing: SizedBox(
                      width: 120,
                      height: 25,
                      child: TextField(
                        keyboardType: TextInputType.number,
                        textAlignVertical: TextAlignVertical.bottom,
                        controller: _heightTextController,
                        enabled: _editEnabled,
                        textAlign: TextAlign.center,         
                    )
                  ) 
                ),
              ),

              Card(  
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)
                ),      
                child: ListTile(
                  visualDensity:VisualDensity(horizontal: 0, vertical: -1),
                  title: Text("Weight (kg)"),
                  trailing: SizedBox(
                      width: 120,
                      height: 25,
                      child: TextField(
                        keyboardType: TextInputType.number,
                        controller: _weightTextController,
                        enabled: _updateEnabled,
                        textAlignVertical: TextAlignVertical.bottom,
                        textAlign: TextAlign.center,                                          
                    )
                  )
                )
              )
            ],
          )
        ),
        
        Row( //BMR Row
          children: <Widget> [

            Padding(padding: EdgeInsets.symmetric(horizontal: 50)),

            Center(
              child: Text("BMR: ${_BMRTextController.text} Calories",
              style: TextStyle(fontSize: 20))
            ),
        
        
            Padding(padding: EdgeInsets.symmetric(horizontal: 10)), 

            IconButton(icon: Icon(Icons.info,
            size: 20), 
            onPressed: () { 
              const snackBar = SnackBar(content: Text('Calories you burn naturally per day without exercise!'),
              duration: Duration(seconds: 2));
              ScaffoldMessenger.of(context).showSnackBar(snackBar);

             },),

             
          ],
        ),

        Row(
          children: [

            Padding(padding: EdgeInsets.symmetric(horizontal: 50)),

            Visibility(
              visible: !_editEnabled,
              child: TextButton(
                onPressed: () {
                  setState(() => {_editEnabled = true});
                    },

                    child: Text("Edit Profile"),
                  ),
                ),

            Visibility(
              visible: _editEnabled,
              child: TextButton(
                onPressed: (){
                  if(verifyPersonalInputs()){
                    setState(() => {_editEnabled = false});
                    savePersonalInfo(_nameTextController.text, _ageTextController.text, _dropdownValue, _heightTextController.text);
                    readPersonalFile();
                    setBMR();
                  }
                }, 
                child: Text("Apply"),
              )
            ),

            Padding(padding: EdgeInsets.symmetric(horizontal: 10)),  

            Visibility(
              visible: _notUpdateEnabled,
              child: TextButton(
                onPressed: (){
                    setState(() => {_updateEnabled = true, _notUpdateEnabled = false});         
                }, child: Text("Update Weight"),
              ),
            ),

            Visibility(
              visible: _updateEnabled,
              child: TextButton(
                onPressed: (){
                  if(verifyWeightInput()){
                    setState(() {
                    _updateEnabled = false;
                    _notUpdateEnabled = true;
                    saveWeightInfo(_weightTextController.text);
                    readWeightFile();
                    setBMR();
                    });
                  }
                }, child: Text("Save"),
              ),
            )   
            ],
          ),  
        ]
      )
    ),

    Visibility(
      visible: isLoading,
      child: Container(
        color: Colors.white, // Replace with your desired background color
        child: Center(
          child: CircularProgressIndicator(),
      ))
      )
    ]
    )
  );
}
