import 'dart:io';
import 'dart:async';
import 'package:vscreen_client_core/vscreen.dart' as vscreen;

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

  var connection = vscreen.ConnectionBloc();
  var player = vscreen.PlayerBloc();
  connection
      .dispatch(vscreen.Connect(url: config["url"], port: config["port"]));

  ProcessSignal.sigint.watch().listen((ProcessSignal signal) {
    print("cleaning up");
    player.dispose();
    connection.dispose();
    exit(0);
  });

  player.state.listen((playerState) {
    if (playerState is vscreen.NewInfo) {
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
        player.dispatch(vscreen.Play());
        break;
      case "pause":
        player.dispatch(vscreen.Pause());
        break;
      case "stop":
        player.dispatch(vscreen.Stop());
        break;
      case "next":
        player.dispatch(vscreen.Next());
        break;
      case "add":
        var url = splitted[1];
        player.dispatch(vscreen.Add(url));
        break;
      case "seek":
        double position = double.tryParse(splitted[1]) ?? 0.0;
        player.dispatch(vscreen.Seek(position));
        break;
    }
  }).onDone(() {
    print("cleaning up...");
    player.dispose();
    connection.dispose();
  });
}
