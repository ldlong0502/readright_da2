import 'package:ebook/blocs/recently_play_cubit.dart';
import 'package:ebook/provider/local_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:just_audio/just_audio.dart';
import 'package:miniplayer/miniplayer.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

import '../configs/configs.dart';
import '../models/audio_book.dart';
import '../models/duration_state.dart';
import '../services/history_services.dart';
import '../services/sound_service.dart';

class PlayerCubit extends Cubit<int> {
  PlayerCubit(this.context) : super(0);
  final BuildContext context;
  bool isMiniPlayer = true;
  bool isHideBottomNavigator = false;
  double speed = 1;
  final MiniplayerController controller = MiniplayerController();
  final soundService = SoundService.instance;
  bool isPlay = false;
  ProcessingState status = ProcessingState.idle;
  bool isLoading = false;
  bool isFirstOpenMax = true;
  int indexChapter = 0;
  AudioBook? currentAudioBook;
  DurationState durationState = const DurationState(
      progress: Duration.zero, buffered: Duration.zero, total: Duration.zero);
  PersistentTabController persistentTabController = PersistentTabController();
  load() {}

  updateHideBottomNavigator(bool value) {
    isHideBottomNavigator = value;
    emitState();
  }

  init() {
    isPlay = false;
    isFirstOpenMax = true;
    status = ProcessingState.idle;
    isLoading = false;
    indexChapter = 0;
    currentAudioBook = null;
    durationState = const DurationState(
        progress: Duration.zero, buffered: Duration.zero, total: Duration.zero);
  }

  emitState() {
    if (isClosed) return;
    emit(state + 1);
  }
  setFirstOpenMax(bool value) {
    isFirstOpenMax = value;
    emitState();
  }
  openMaxPlayer() {
    isMiniPlayer = false;
    controller.animateToHeight(state: PanelState.MAX);
    emit(state + 1);
  }

  openMiniPlayer() {
    isMiniPlayer = true;
    controller.animateToHeight(state: PanelState.MIN);
    emit(state + 1);
  }
  bool checkPermissionBeforeListen(AudioBook audioBook  , int value) {
    if(audioBook.listMp3.isEmpty) {
      Fluttertoast.showToast(msg: 'Không có chương nào để phát');
      return false;
    }
    if(currentAudioBook!= null && audioBook.id == currentAudioBook!.id &&  value == indexChapter) {
      Fluttertoast.showToast(msg: 'Bạn đang nghe chương này');
      return false;
    }
    return true;
  }
  listen(AudioBook audioBook  , [int value = 0 , int historyDuration = 0]) async {
    if( !checkPermissionBeforeListen(audioBook, value)) {
      return;
    }
    var temp = await LocalProvider.instance.getString('audio_speed');
    if(temp.isNotEmpty) {
      speed = double.parse(temp);
    }
    updateHistory();
    isFirstOpenMax = true;
    isLoading = true;
    emitState();
    currentAudioBook = audioBook;
    indexChapter = value;

    final duration = await soundService.setUrl(audioBook.listMp3[indexChapter].url, Duration(milliseconds: historyDuration) );
    durationState = durationState.copyWith(total: duration);
    isLoading = false;
    emitState();
    soundService.player!.positionStream.listen((event) {
      durationState = durationState.copyWith(progress: event);
      emitState();
    });
    soundService.player!.bufferedPositionStream.listen((event) {
      durationState = durationState.copyWith(buffered: event);
      emitState();
    });
    soundService.player!.playerStateStream.listen((event) {
      isPlay = event.playing;
      status = event.processingState;
      if (!isLoading && status == ProcessingState.completed) {
        soundService.stop();
        if(indexChapter == currentAudioBook!.listMp3.length - 1) {
          onSeek(Duration.zero);
        }
        else {
          changeChapter(indexChapter + 1);
        }
      }
      emitState();
    });
    play();
  }

  play()  {
    soundService.play();
  }
  pause()  {
    soundService.pause();
  }
  dismissMiniPlayer() async {
    updateHistory();
    init();
    await soundService.stop();
    soundService.dispose();
    emitState();
  }

  onSeek(Duration duration) async {
    await soundService.seek(duration);
  }
  void seekPrevious(Duration duration) async {
    Duration newPosition = durationState.progress - duration;
    await soundService.seek(newPosition);
  }
  void seekNext(Duration duration) async {
    Duration newPosition = durationState.progress + duration;
    await soundService.seek(newPosition);
  }


  void changeChapter (int index) {
    listen(currentAudioBook! , index);
  }
  updateHistory() async {
    if(currentAudioBook != null) {
      await HistoryService.instance.updateNewHistory(currentAudioBook!, indexChapter, durationState.progress.inMilliseconds);
      AppConfigs.contextApp!.read<RecentlyPlayCubit>().load();
    }
  }
  void setSpeed (double value) async {
    await LocalProvider.instance.setString('audio_speed', value.toString());

    speed = value;
    emitState();
  }
}