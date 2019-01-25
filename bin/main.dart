import 'dart:io';
import 'dart:async';
import 'package:vscreen_client_core/vscreen_client_core.dart';
import 'dart:convert';

Stream readLine() =>
    stdin.transform(Utf8Decoder()).transform(new LineSplitter());

void processCommand(String line) {}

main(List<String> arguments) async {
  Map<String, dynamic> config = {
    "url": "127.0.0.1",
    "port": 8080,
    "password": "poop"
  };

  var vscreenBloc = VScreenBloc();
  vscreenBloc.connection
      .dispatch(Connect(url: config["url"], port: config["port"]));

  ProcessSignal.sigint.watch().listen((ProcessSignal signal) {
    print("cleaning up");
    vscreenBloc.dispose();
    exit(0);
  });

  var playerBloc = vscreenBloc.player;

  playerBloc.state.listen((playerState) {
    print("Title        : ${playerState.title}");
    print("Thumbnail URL: ${playerState.thumbnail}");
    print("Position     : ${playerState.position}");
    print("Playing      : ${playerState.playing}");
  });

  readLine().listen((line) {
    var splitted = line.split(" ");
    var op = splitted[0];

    switch (op) {
      case "play":
        playerBloc.dispatch(Play());
        break;
      case "pause":
        playerBloc.dispatch(Pause());
        break;
      case "stop":
        playerBloc.dispatch(Stop());
        break;
      case "next":
        playerBloc.dispatch(Next());
        break;
      case "add":
        var url = splitted[1];
        playerBloc.dispatch(Add(url));
        break;
      case "seek":
        double position = double.tryParse(splitted[1]) ?? 0.0;
        playerBloc.dispatch(Seek(position));
        break;
    }
  }).onDone(() {
    print("cleaning up...");
    vscreenBloc.dispose();
  });
}
