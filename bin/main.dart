import 'dart:io';
import 'package:vscreen_client_core/vscreen_client_core.dart';

main(List<String> arguments) async {
  Map<String, dynamic> config = {
    "url": "127.0.0.1",
    "port": 8080,
    "password": "poop"
  };

  if (arguments.length == 0) {
    print("[error] usage: <command> args...");
    exit(-1);
  }

  var vscreen = VScreen(config["url"], config["port"]);
  await vscreen.auth(config["password"]);

  var op = arguments[0];

  switch (op) {
    case "play":
      await vscreen.play();
      break;
    case "pause":
      await vscreen.pause();
      break;
    case "stop":
      await vscreen.stop();
      break;
    case "next":
      await vscreen.next();
      break;
    case "add":
      var url = arguments[1];
      await vscreen.add(url);
      break;
    case "seek":
      double position = double.tryParse(arguments[1]) ?? 0.0;
      await vscreen.seek(position);
      break;
  }

  await vscreen.close();
}
