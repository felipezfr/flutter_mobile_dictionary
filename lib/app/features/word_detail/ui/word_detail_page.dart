import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobile_dictionary/app/features/word_detail/interactor/entities/word_detail_entity.dart';
import 'package:flutter_mobile_dictionary/app/features/word_detail/interactor/exceptions/word_detail_not_found_exception.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../../../core/alert/alerts.dart';
import '../../../core/states/base_state.dart';
import '../interactor/controller/word_detail_controller.dart';
import 'widgets/audio_player_widget.dart';

class WordDetailPage extends StatefulWidget {
  final String wordId;

  const WordDetailPage({
    super.key,
    required this.wordId,
  });

  @override
  State<WordDetailPage> createState() => _WordDetailPageState();
}

class _WordDetailPageState extends State<WordDetailPage> {
  final controller = Modular.get<WordDetailController>();
  late AudioPlayer player = AudioPlayer();

  bool isFavorited = false;

  @override
  void initState() {
    super.initState();
    controller.getWordDetail(widget.wordId);
    controller.addHistory(widget.wordId);
    controller.addListener(listener);
    processFavorite(widget.wordId);

    player = AudioPlayer();
    player.setReleaseMode(ReleaseMode.stop);
  }

  void listener() {
    if (controller.value case ErrorState(:final exception)) {
      if (exception is WordDetailNotFoundException) {
        return Alerts.showFailure(context, 'Palavra não encontrada');
      }
      Alerts.showFailure(context, exception.message);
    }
  }

  @override
  void dispose() {
    controller.removeListener(listener);
    super.dispose();
  }

  void processFavorite(String wordId) async {
    isFavorited = await controller.isFavorited(wordId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 22.0, vertical: 26),
        child: Column(
          children: [
            ValueListenableBuilder(
              valueListenable: controller,
              builder: (context, state, child) {
                return switch (state) {
                  SuccessState<WordDetailEntity>() => Column(
                      children: [
                        Container(
                          height: 250,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.black,
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                state.data.word ?? '-',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                              Text(
                                state.data.phonetic ?? '-',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Builder(
                          builder: (context) {
                            String? audioSource;
                            state.data.phonetics?.forEach(
                              (e) => e.audio!.isNotEmpty
                                  ? audioSource = e.audio!
                                  : '',
                            );
                            if (audioSource != null) {
                              return AudioPlayerWidget(
                                  player: player, url: audioSource!);
                            }
                            return const Text('No audio data');
                          },
                        ),
                        const SizedBox(height: 16),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const Text(
                              'Meanings',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: state.data.meanings!.first.definitions!
                                  .map((e) => Text(e.definition ?? ''))
                                  .toList(),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            await controller.toogleFavorite(state.data.word!);
                            setState(() {
                              isFavorited = !isFavorited;
                            });
                          },
                          child: isFavorited
                              ? const Icon(
                                  Icons.star,
                                  color: Colors.amber,
                                )
                              : const Icon(
                                  Icons.star_border,
                                  color: Colors.amber,
                                ),
                        )
                      ],
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
