// ========================= Special key settings ========================== //

key.quitKey              = "Not defined";
key.universalArgumentKey = "Not defined";

// ============================= Key bindings ============================== //

key.setGlobalKey('C-a', function (ev) {
    command.beginLine(ev);
}, '行頭へ移動');

key.setGlobalKey('C-e', function (ev) {
    command.endLine(ev);
}, '行末へ');

key.setGlobalKey('C-f', function (ev) {
    command.nextChar(ev);
}, '一文字右へ移動');

key.setGlobalKey('C-b', function (ev) {
    command.previousChar(ev);
}, '一文字左へ移動');

key.setGlobalKey('C-n', function (ev) {
    command.nextLine(ev);
}, '一行下へ');

key.setGlobalKey('C-p', function (ev) {
    command.previousLine(ev);
}, '一行上へ');

key.setGlobalKey('C-d', function (ev) {
    goDoCommand("cmd_deleteCharForward");
}, '次の一文字削除');

key.setGlobalKey('C-h', function (ev) {
    goDoCommand("cmd_deleteCharBackward");
}, '前の一文字を削除');

key.setGlobalKey('M-d', function (ev) {
    command.deleteForwardWord(ev);
}, '次の一単語を削除');

key.setGlobalKey('C-<backspace>', function (ev) {
    command.deleteBackwardWord(ev);
}, '前の一単語を削除');

key.setGlobalKey('C-k', function (ev) {
    command.killLine(ev);
}, 'カーソルから先を一行カット (Kill line)');

key.setGlobalKey('C-u', function (ev) {
    command.beginLine(ev);
    command.killLine(ev);
}, '一行削除');
