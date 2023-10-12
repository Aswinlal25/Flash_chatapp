class Message {
   late final String told;
  late final String msg;
  late final String readed;
  late final String formId;
  late final String sent;
  late final Type type;
  Message({
    required this.told,
    required this.msg,
    required this.readed,
    required this.type,
    required this.formId,
    required this.sent,
  });
 

  Message.fromJson(Map<String, dynamic> json) {
    told = json['told'].toString();
    msg = json['msg'].toString();
    readed= json['readed'].toString();
    type = json['type'].toString() == Type.image.name ? Type.image : Type.text;
    formId = json['formId'].toString();
    sent = json['sent'].toString();
  }

  get isOnline => null;

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};

    data['told'] = told;
    data['msg'] = msg;
    data['readed'] = readed;
    data['type'] = type.name;
    data['formId'] = formId;
    data['sent'] = sent;
    return data;
  }
}

enum Type { text, image }
