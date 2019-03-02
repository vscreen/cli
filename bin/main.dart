import 'dart:io';
import 'dart:async';
import 'package:vscreen_client_core/vscreen.dart' as vscreen;

import 'dart:convert';

Stream readLine() =>
    stdin.transform(Utf8Decoder()).transform(new LineSplitter());

void processCommand(String line) {}

main(List<String> arguments) async {
  Map<String, dynamic> config = {
    "url": "192.168.0.22",
    "port": 8080,
    "password": "poop"
  };

  var bloc = vscreen.VScreenBloc();
  var player = bloc.player;
  bloc.connect(config["url"], config["port"]);

  ProcessSignal.sigint.watch().listen((ProcessSignal signal) {
    print("cleaning up");
    bloc.dispose();
    exit(0);
  });

  player.listen((playerState) {
    if (playerState is vscreen.NewPlayerInfo) {
      print("Title        : ${playerState.title}");
      print("Thumbnail URL: ${playerState.thumbnail}");
      print("Position     : ${playerState.position}");
      print("Playing      : ${playerState.playing}");
    }
  });

  readLine().listen((line) {
    var splitted = line.split(" ");
    var op = splitted[0];

    switch (op) {
      case "play":
        bloc.play();
        break;
      case "pause":
        bloc.pause();
        break;
      case "stop":
        bloc.stop();
        break;
      case "next":
        bloc.next();
        break;
      case "add":
        var url = splitted[1];
        bloc.add(url);
        break;
      case "seek":
        double position = double.tryParse(splitted[1]) ?? 0.0;
        bloc.seek(position);
        break;
    }
  }).onDone(() {
    print("cleaning up...");
    bloc.dispose();
  });
}
