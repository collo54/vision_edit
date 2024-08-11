import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

import '../models/plant_disease_response_model.dart';

abstract class GeminiGenModelPro {
  void initGeminiModel({
    required String genmodel,
  });
  Future<PlantDiseaseResponseModel> generateText(
      {required List<Uint8List> promptImage});
//  Future<String> generateImage({required String prompt});
}

class GeminiGenAiService extends GeminiGenModelPro {
  String get apiKeyGemini => const String.fromEnvironment('GEMINI_KEY');
  late GenerativeModel _geminiModel;
  GenerativeModel get geminiModel => _geminiModel;

  @override
  void initGeminiModel({
    required String genmodel,
  }) {
    try {
      _geminiModel = GenerativeModel(
        model: genmodel,
        apiKey: apiKeyGemini!,
        generationConfig:
            GenerationConfig(responseMimeType: 'application/json'),
        safetySettings: [
          SafetySetting(HarmCategory.hateSpeech, HarmBlockThreshold.high),
          SafetySetting(HarmCategory.harassment, HarmBlockThreshold.high),
          SafetySetting(HarmCategory.sexuallyExplicit, HarmBlockThreshold.high),
          SafetySetting(HarmCategory.dangerousContent, HarmBlockThreshold.high),
        ],
      );
      // return model;
    } catch (e) {
      Fluttertoast.showToast(
          msg: "error initGeminiModel: $e",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.blueAccent,
          textColor: Colors.white,
          fontSize: 16.0);
      if (kDebugMode) {
        print('Error initializing GenerativeModel: $e');
      }
      rethrow;
    }
  }

  @override
  Future<PlantDiseaseResponseModel> generateText(
      {required List<Uint8List> promptImage}) async {
    try {
      const prompt =
          'What plant is this and what disease is present, if none present say no disease present. if no plant detected say no plant detected. What is the disease danger to humans and livestock if none say no dangers? How is the disease caused? What are the preventive measures for the disease? Finally What are the treatment for the disease? Format response using this JSON schema:\n\n'
          'Response = {\n'
          ' "Plant": string ,\n'
          '  "Disease": string,\n'
          '  "Human and Livestock Danger": string,\n'
          '  "Cause of Disease": string,\n'
          '  "Preventative Measures": string[]\n'
          '  "Treatment": string[]\n'
          '}\n'
          'Return: Response';
      final mainText = TextPart(prompt);
      // final additionalTextParts =
      //     prompt.additionalTextInputs.map((t) => TextPart(t));
      final imagesParts = <DataPart>[];

      for (var cameraImageBytes in promptImage) {
        imagesParts.add(DataPart('image/jpeg', cameraImageBytes));
      }

      final response = await _geminiModel.generateContent([
        Content.multi([mainText, ...imagesParts])
      ]);
      if (kDebugMode) {
        print(response.text);
      }
      final plantDiseaseResponseModel =
          PlantDiseaseResponseModel.fromJson(jsonDecode(response.text!));

      return plantDiseaseResponseModel;
    } catch (e) {
      Fluttertoast.showToast(
          msg: "error generateIext: $e",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.blueAccent,
          textColor: Colors.white,
          fontSize: 16.0);
      if (kDebugMode) {
        print('Error generating text from gemini: $e');
      }
      rethrow;
    }
  }

  // @override
  // Future<String> generateImage({required String prompt}) {
  //   // TODO: implement generateImage
  //   _geminiModel.
  //   throw UnimplementedError();
  // }
}
