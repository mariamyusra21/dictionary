import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

import 'model.dart';
import 'service.dart';

void main() {
  runApp(App());
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController controller = TextEditingController();
  final FlutterTts tts = FlutterTts();
  late String? text;

  Text_to_speech(text) {
    tts.setLanguage('en-UK');
    tts.setSpeechRate(0.4);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dictionary App'),
        centerTitle: true,
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.all(10),
              height: MediaQuery.of(context).size.height,
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: controller,
                            decoration: const InputDecoration(
                              label: Text(
                                'Search Word',
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.w700),
                              ),
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            if (controller.text.isNotEmpty) {
                              setState(() {});
                            }
                          },
                          icon: const Icon(Icons.search),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  controller.text.isEmpty
                      ? const SizedBox(child: Text('Search for something'))
                      : FutureBuilder(
                          future: DictionaryService()
                              .getMeaning(word: controller.text),
                          builder: (context,
                              AsyncSnapshot<List<DictionaryModel>> snapshot) {
                            print("Data $snapshot");
                            if (snapshot.hasData) {
                              return Expanded(
                                child: ListView(
                                  children: List.generate(snapshot.data!.length,
                                      (index) {
                                    final data = snapshot.data![index];
                                    return Container(
                                      child: Column(
                                        children: [
                                          Container(
                                            child: ListTile(
                                              title: Text(
                                                data.word!,
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 22),
                                              ),
                                              subtitle: Text(
                                                  data.phonetics![index].text!),
                                              trailing: TextButton(
                                                  onPressed: () {
                                                    String? word = data.word;
                                                    tts.setLanguage('en-UK');
                                                    tts.setSpeechRate(0.4);
                                                    tts.speak(word!);
                                                  },
                                                  child: Text('UK Accent')),
                                            ),
                                          ),
                                          Container(
                                            child: ListTile(
                                              title: Text(
                                                data
                                                    .meanings![index]
                                                    .definitions![index]
                                                    .definition!,
                                                style: TextStyle(fontSize: 20),
                                              ),
                                              subtitle: Text(
                                                data.meanings![index]
                                                    .partOfSpeech!,
                                                style: TextStyle(
                                                    fontSize: 20,
                                                    fontStyle: FontStyle.italic,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  }),
                                ),
                              );
                            } else if (snapshot.hasError) {
                              return Text(snapshot.error.toString());
                            } else {
                              return const CircularProgressIndicator();
                            }
                          },
                        )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
