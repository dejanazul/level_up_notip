import 'package:flutter/material.dart';
import 'package:level_up_2/services/api_service.dart';

class TranslateScreen extends StatefulWidget {
  const TranslateScreen({super.key});

  @override
  State<TranslateScreen> createState() => _TranslateScreenState();
}

class _TranslateScreenState extends State<TranslateScreen> {
  TextEditingController input = TextEditingController();
  String translate = '';
  String source = 'id';
  String target = 'en';

  ApiService apiService = ApiService();

  Future<void> translateInput(String userInput, String src, String trg) async {
    if (userInput.isEmpty || userInput == '') {
      setState(() {
        translate = '';
      });
      return;
    }
    try {
      String translatedText = await apiService.translate(userInput, src, trg);
      setState(() {
        translate = translatedText;
      });
    } catch (e) {
      print("Error: $e");
    }
  }

  @override
  void dispose() {
    super.dispose();
    input.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Translator'),
        foregroundColor: Colors.white,
        backgroundColor: const Color(0xff1e1e1e),
      ),
      backgroundColor: const Color(0xff121212),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: Column(
            children: [
              const SizedBox(height: 32),

              // Input Textfield
              TextField(
                controller: input,
                maxLines: 8,
                cursorColor: Colors.amberAccent,
                style: const TextStyle(
                  fontSize: 16,
                  fontFamily: 'Poppins',
                  color: Colors.white,
                ),
                decoration: const InputDecoration(
                  enabledBorder: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(16)),
                      borderSide: BorderSide(color: Colors.amberAccent)),
                  focusedBorder: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(16)),
                      borderSide: BorderSide(color: Colors.amberAccent)),
                  hintText: 'Enter your text here',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xff121212),
                    shape: const RoundedRectangleBorder(
                      side: BorderSide(color: Colors.amberAccent),
                      borderRadius:
                          BorderRadius.vertical(bottom: Radius.circular(12)),
                    ),
                  ),
                  onPressed: () => translateInput(input.text, source, target),
                  child: const Text(
                    'Translate',
                    style: TextStyle(
                        color: Colors.amberAccent, fontFamily: 'Poppins'),
                  ),
                ),
              ),

              // TRANSLATE BUTTON
              SizedBox(
                height: 80,
                width: 140,
                child: Stack(
                  children: [
                    AnimatedPositioned(
                        curve: Curves.easeInOut,
                        duration: const Duration(milliseconds: 300),
                        left: 0,
                        top: source == 'id' ? 0 : 40,
                        bottom: source == 'en' ? 0 : 40,
                        child: Container(
                          decoration: const BoxDecoration(
                              color: Color(0xff2d2d2d), shape: BoxShape.circle),
                          width: 40,
                          height: 40,
                          child: const Center(
                              child: Text(
                            'ID',
                            style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.bold),
                          )),
                        )),
                    AnimatedPositioned(
                        curve: Curves.easeInOut,
                        duration: const Duration(milliseconds: 300),
                        right: 0,
                        bottom: source == 'id' ? 0 : 40,
                        top: source == 'en' ? 0 : 40,
                        child: Container(
                          decoration: const BoxDecoration(
                              color: Color(0xff2d2d2d), shape: BoxShape.circle),
                          width: 40,
                          height: 40,
                          child: const Center(
                              child: Text(
                            'EN',
                            style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.bold),
                          )),
                        )),
                    Positioned(
                        right: 30,
                        child: InkWell(
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          onTap: () {
                            setState(() {
                              if (source == 'id' && target == 'en') {
                                source = 'en';
                                target = 'id';
                              } else {
                                source = 'id';
                                target = 'en';
                              }
                            });
                          },
                          child: Container(
                            decoration: const BoxDecoration(
                                color: Colors.amberAccent,
                                shape: BoxShape.circle),
                            width: 80,
                            height: 80,
                            child: const Icon(
                              Icons.compare_arrows,
                              size: 52,
                            ),
                          ),
                        )),
                  ],
                ),
              ),

              Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Color(0xff2d2d2d),
                  borderRadius: BorderRadius.all(Radius.circular(16)),
                ),
                child: SizedBox(
                  width: double.infinity,
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 12.0),
                          child: Text(
                            'Translated Text:',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontFamily: 'Poppins'),
                          ),
                        ),
                        Text(
                          translate,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontFamily: 'Poppins',
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}
