import '../enums/CommandEnums.dart';

class CommandData {
  CommandEnum? _command;
  String? _data;

  CommandEnum? get command => _command;

  String? get data => _data;

  CommandData.constructCommand(CommandEnum val) {
    this._command = val;
    this._data = "";
  }

  CommandData.constructMessage(String val) {
    this._command = CommandEnum.message;
    this._data = val;
  }

  CommandData.clearMessage() {
    this._command = CommandEnum.clearMessage;
    this._data = "";
  }

  CommandData.construct(CommandEnum val1, String val2) {
    this._command = val1;
    this._data = val2;
  }

  bool isMessage() {
    return _command == CommandEnum.message;
  }
}
