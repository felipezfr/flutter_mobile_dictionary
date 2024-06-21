import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../../../core/alert/alerts.dart';
import '../../../core/states/base_state.dart';
import '../interactor/controller/home_controller.dart';

enum Page {
  wordList,
  history,
  favoriteWordList,
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final controller = Modular.get<HomeController>();
  Page page = Page.wordList;

  @override
  void initState() {
    super.initState();
    getWordList();
    controller.addListener(listener);
  }

  void getWordList() {
    switch (page) {
      case Page.wordList:
        controller.getWordList();
        break;
      case Page.history:
        controller.getHistoryWordList();
        break;
      case Page.favoriteWordList:
        controller.getFavoriteWordList();
        break;
    }
  }

  void listener() {
    if (controller.value case ErrorState(:final exception)) {
      Alerts.showFailure(context, exception.message);
    }
  }

  @override
  void dispose() {
    controller.removeListener(listener);
    scrollController.dispose();
    super.dispose();
  }

  int scrollCount = 1;
  ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    scrollController.addListener(() {
      var nextPageTrigger = scrollController.position.maxScrollExtent - 1;
      if (scrollController.position.pixels > nextPageTrigger) {
        scrollCount++;
        setState(() {});
      }
    });

    final String titleLabel;
    switch (page) {
      case Page.wordList:
        titleLabel = 'Word list';
        break;
      case Page.history:
        titleLabel = 'History list';

        break;
      case Page.favoriteWordList:
        titleLabel = 'Favorites list';

        break;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 22.0, vertical: 26),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      page = Page.wordList;
                    });
                    controller.getWordList();
                  },
                  child: const Text('Word List'),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      page = Page.history;
                    });
                    controller.getHistoryWordList();
                  },
                  child: const Text('History'),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      page = Page.favoriteWordList;
                    });
                    controller.getFavoriteWordList();
                  },
                  child: const Text('Favorites'),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                titleLabel,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 10),
            ValueListenableBuilder(
              valueListenable: controller,
              builder: (context, state, child) {
                return switch (state) {
                  SuccessState<List<String>>() => Expanded(
                      child: GridView.builder(
                        controller: scrollController,
                        itemCount: 20 * scrollCount < state.data.length
                            ? 20 * scrollCount
                            : state.data.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 6,
                          mainAxisSpacing: 6,
                        ),
                        itemBuilder: (context, index) {
                          final word = state.data[index];
                          return InkWell(
                            onTap: () async {
                              await Modular.to.pushNamed('/word_detail/$word');
                              getWordList();
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.black,
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Center(
                                child: Text(
                                  word,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ErrorState() => const SizedBox.shrink(),
                  _ => const Center(
                      child: CircularProgressIndicator(),
                    )
                };
              },
            ),
          ],
        ),
      ),
    );
  }
}
