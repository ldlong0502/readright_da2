import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:miniplayer/miniplayer.dart';

import '../../blocs/player_cubit.dart';
import '../../util/resizable.dart';
import 'max_player_audio_book.dart';
import 'mini_audio_book.dart';

class CustomMiniPlayer extends StatelessWidget {
  const CustomMiniPlayer({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PlayerCubit, int>(
      builder: (cc, state) {
        final playerCubit = cc.read<PlayerCubit>();
        return playerCubit.currentAudioBook == null ? Container() : AnimatedPositioned(
          bottom: playerCubit.isMiniPlayer ? kBottomNavigationBarHeight + 10 : 0,
          left: playerCubit.isMiniPlayer ? 15 : 0,
          right: playerCubit.isMiniPlayer ? 15 : 0,
          duration: const Duration(milliseconds: 0),
          child: Miniplayer(
              minHeight: Resizable.size(context, 60),
              onDismiss: () {
                playerCubit.dismissMiniPlayer();
              },
              elevation: 8,
              controller: playerCubit.controller,
              maxHeight: Resizable.height(context),
              builder: (height, percentage) {
                if(playerCubit.isFirstOpenMax) {
                  playerCubit.openMaxPlayer();
                  playerCubit.setFirstOpenMax(false);
                }
                if (percentage > 0.2 && playerCubit.isMiniPlayer) {
                  playerCubit.openMaxPlayer();
                }
                else if (percentage < 0.2 && !playerCubit.isMiniPlayer) {
                  playerCubit.openMiniPlayer();
                }
                if(percentage < 0.2) {
                  return const MiniPlayerAudioBook();
                }
                return const MaxPlayerAudioBook();
              }
          ),
        );
      },
    );
  }
}