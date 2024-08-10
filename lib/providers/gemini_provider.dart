import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vision_edit/services/gemini_service.dart';

// Access your API key as an environment variable (see "Set up your API key" above)
//final apiKey = Platform.environment['GEMINI_KEY'];

// GenerativeModel geminiModel(
//     {required String geminimodel, required String apiKey}) {
//   try {
//     final model = GenerativeModel(
//       model: geminimodel,
//       apiKey: apiKey,
//       generationConfig: GenerationConfig(responseMimeType: 'application/json'),
//       safetySettings: [
//         SafetySetting(HarmCategory.hateSpeech, HarmBlockThreshold.high),
//         SafetySetting(HarmCategory.harassment, HarmBlockThreshold.high),
//         SafetySetting(HarmCategory.sexuallyExplicit, HarmBlockThreshold.high),
//         SafetySetting(HarmCategory.dangerousContent, HarmBlockThreshold.high),
//       ],
//     );
//     return model;
//   } catch (e) {
//     if (kDebugMode) {
//       print('Error initializing GenerativeModel: $e');
//     }
//     rethrow;
//   }
// }

// final geminiProvider = Provider((ref) {
//   return geminiModel(geminimodel: 'gemini-1.5-pro', apiKey: apiKey!);

// });

final geminiProvider = Provider((ref) {
  return GeminiGenAiService();
});
