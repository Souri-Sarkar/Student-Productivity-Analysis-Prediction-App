import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: PredictionScreen(),
    );
  }
}

class PredictionScreen extends StatefulWidget {
  @override
  _PredictionScreenState createState() => _PredictionScreenState();
}

class _PredictionScreenState extends State<PredictionScreen> {

  final studyController = TextEditingController();
  final phoneController = TextEditingController();
  final socialController = TextEditingController();
  final youtubeController = TextEditingController();
  final gamingController = TextEditingController();
  final stressController = TextEditingController();
  final focusController = TextEditingController();

  String result = "";

  Future getPrediction() async {
    var url = Uri.parse("http://127.0.0.1:8000/predict");
    var response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "study_hours_per_day": double.parse(studyController.text),
        "phone_usage_hours": double.parse(phoneController.text),
        "social_media_hours": double.parse(socialController.text),
        "youtube_hours": double.parse(youtubeController.text),
        "gaming_hours": double.parse(gamingController.text),
        "stress_level": double.parse(stressController.text),
        "focus_score": double.parse(focusController.text)
      }),
    );

    print(response.statusCode);
    print(response.body);
    var data = jsonDecode(response.body);

    setState(() {
      result = data["prediction"].toString();
    });
  }

  Widget buildTextField(String label, TextEditingController controller) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(labelText: label),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Productivity Predictor")),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: ListView(
          children: [

            buildTextField("Study Hours", studyController),
            buildTextField("Phone Usage", phoneController),
            buildTextField("Social Media", socialController),
            buildTextField("YouTube", youtubeController),
            buildTextField("Gaming", gamingController),
            buildTextField("Stress Level", stressController),
            buildTextField("Focus Score", focusController),

            SizedBox(height: 20),

            ElevatedButton(
              onPressed: getPrediction,
              child: Text("Predict"),
            ),

            SizedBox(height: 20),

            Text("Prediction: $result",
                style: TextStyle(fontSize: 20))
          ],
        ),
      ),
    );
  }
}