import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:infoctess_koneqt/env.dart';

Future<String> getCompletions(String prompt) async {
  // var prompt = inputController.text;
  var url = Uri.parse('https://api.openai.com/v1/completions');
  var headers = {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $OPEN_AI_KEY',
  };
  var body = jsonEncode({
    'prompt': prompt,
    "model": "text-davinci-003",
    // "model": "gpt-3.5-turbo",
    "temperature": 0.2,
    "max_tokens": 256,
    // "max_tokens": 1000,
    // "top_p": 0.2,
    "frequency_penalty": 0,
    "presence_penalty": 0,
    "stop": null
  });

  if (prompt.length < 5) {
    return "Please enter an accurate prompt.";
  }
  var response = await http.post(url, headers: headers, body: body);

  if (response.statusCode == 200) {
    var responseData = jsonDecode(response.body);
    var completions = responseData['choices'][0]['text'];
    return completions;
  }
  if (response.statusCode == 400) {
    return "Please enter an accurate prompt.";
  }
  return "Error. Please try again.";
}

Future<List<String>> getGenerations(String prompt) async {
  var url = Uri.parse('https://api.openai.com/v1/images/generations');
  var headers = {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $OPEN_AI_KEY',
  };
  var body = jsonEncode({"prompt": prompt, "n": 4, "size": "256x256"});

  var response = await http.post(url, headers: headers, body: body);

  if (response.statusCode == 200) {
    var responseData = jsonDecode(response.body);
    List<String> images = [];

    for (var i = 0; i < responseData['data'].length; i++) {
      images.add(responseData['data'][i]['url']);
    }

    return images;
  }

  // Provide more informative error messages
  if (response.statusCode == 400) {
    throw Exception("Please enter an accurate prompt.");
  }
  throw Exception("Error. Please try again.");
}
