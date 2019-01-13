import 'dart:io';
import 'package:vscreen_client_core/vscreen_client_core.dart';

main(List<String> arguments) {
  Map<String, dynamic> config = {
    "url": "192.168.0.32",
    "port": 8080,
    "password": "poop"
  };

  if (arguments.length == 0) {
    print("[error] usage: <command> args...");
    exit(-1);
  }

  var vscreen = VScreen(config["url"], config["port"]);
  vscreen.auth(config["password"]);

  var op = arguments[0];

  switch (op) {
    case "play":
      vscreen.play();
      break;
    case "pause":
      vscreen.pause();
      break;
    case "next":
      vscreen.next();
      break;
    case "add":
      var url = arguments[1];
      vscreen.add(url);
      break;
    case "seek":
      double position = double.tryParse(arguments[1]) ?? 0.0;
      vscreen.seek(position);
      break;
  }

  vscreen.dispose();
}
