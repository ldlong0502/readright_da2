import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:ebook/blocs/player_cubit.dart';
import 'package:ebook/components/network_custom_image.dart';
import 'package:ebook/configs/constants.dart';
import 'package:ebook/theme/theme_config.dart';
import 'package:ebook/views/audio_books/audio_book_detail_screen.dart';
import 'package:ebook/views/audio_books/detail_audio_book.dart';
import 'package:ebook/views/audio_books/player_row_controls.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:marquee/marquee.dart';
import 'package:shimmer/shimmer.dart';

import '../../app_routes.dart';
import '../../configs/configs.dart';
import '../../models/audio_book.dart';
import '../../util/navigator_custom.dart';
import '../../util/resizable.dart';

class MaxPlayerAudioBook extends StatelessWidget {
  const MaxPlayerAudioBook({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PlayerCubit, int>(
      builder: (context, state) {
        final cubit = context.read<PlayerCubit>();
        return Scaffold(
          extendBodyBehindAppBar: true,
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.transparent,
            leading: IconButton(
              icon: const Icon(
                Icons.keyboard_arrow_down_outlined,
                color: Colors.white,
              ),
              onPressed: () {
                cubit.openMiniPlayer();
              },
            ),
            actions: [
              IconButton(
                icon: const Icon(
                  Icons.more_vert_outlined,
                  color: Colors.white,
                ),
                onPressed: () async {
                  cubit.openMiniPlayer();
                  await Future.delayed(const Duration(seconds: 1));
                  popToAudioBookDetail(
                      AppConfigs.contextApp!, cubit.currentAudioBook!);
                },
              ),
            ],
          ),
          body: SingleChildScrollView(
            child: Container(
              height: Resizable.height(context),
              width: Resizable.width(context),
              decoration: linearDecoration,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: kToolbarHeight + 30,
                  ),
                  NetworkImageCustom(
                    borderRadius: BorderRadius.circular(20),
                    url: cubit.currentAudioBook!.image,
                    height: Resizable.size(context, 300),
                    width: Resizable.size(context, 200),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    height: 50,
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: Resizable.padding(context, 30)),
                      child: Marquee(
                        text: cubit.currentAudioBook!.title,
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          fontSize: Resizable.font(context, 20),
                        ),
                        scrollAxis: Axis.horizontal,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        blankSpace: 20.0,
                        velocity: 10.0,
                        pauseAfterRound: const Duration(milliseconds: 500),
                        startPadding: 10.0,
                        accelerationDuration: const Duration(milliseconds: 100),
                        accelerationCurve: Curves.linear,
                        decelerationDuration: const Duration(milliseconds: 100),
                        decelerationCurve: Curves.easeOut,
                      ),
                    ),
                  ),
                  Text(
                      cubit.currentAudioBook!.listMp3[cubit.indexChapter].title,
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                        fontSize: Resizable.font(context, 15),
                      )),
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    height: 50,
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: ProgressBar(
                      barHeight: 8,
                      baseBarColor: Colors.white38,
                      bufferedBarColor: Colors.grey,
                      progressBarColor: Colors.white,
                      thumbColor: Colors.white,
                      timeLabelTextStyle: const TextStyle(
                          color: Colors.white, fontWeight: FontWeight.w600),
                      progress: cubit.isLoading
                          ? Duration.zero
                          : cubit.durationState.progress,
                      buffered: cubit.isLoading
                          ? Duration.zero
                          : cubit.durationState.buffered,
                      total: cubit.isLoading
                          ? Duration.zero
                          : cubit.durationState.total,
                      onSeek: (value) {
                        cubit.onSeek(value);
                      },
                    ),
                  ),
                  PlayerRowControl(
                    cubit: cubit,
                  ),
                  Expanded(
                      child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Flexible(
                          child: GestureDetector(
                        onTap: () {
                          // Dialogs.showChapter(context, cubit);
                        },
                        child: const Column(
                          children: [
                            Icon(
                              Icons.menu_open,
                              size: 30,
                              color: Colors.white,
                            ),
                            Text(
                              'Chương',
                              style: TextStyle(color: Colors.white),
                            )
                          ],
                        ),
                      )),
                      const Flexible(
                          child: Column(
                        children: [
                          Icon(
                            Icons.speed,
                            size: 30,
                            color: Colors.white,
                          ),
                          Text(
                            '1.0x',
                            style: TextStyle(color: Colors.white),
                          )
                        ],
                      ))
                    ],
                  )),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void popToAudioBookDetail(BuildContext context, AudioBook audioBook) {
    final newRouteName = AppRoutes.audioBookDetail + audioBook.id.toString();
    bool isNewRouteSameAsCurrent = false;

    Navigator.popUntil(context, (route) {
      if (route.settings.name == newRouteName) {
        isNewRouteSameAsCurrent = true;
      }
      return true;
    });

    if (!isNewRouteSameAsCurrent) {
      if (context.mounted) {
        NavigatorCustom.pushNewScreen(AppConfigs.contextApp!,
            AudioBookDetailScreen(audioBook: audioBook), newRouteName);
      }
    } else {
      Navigator.popUntil(context, ModalRoute.withName(newRouteName));
    }
  }
}
