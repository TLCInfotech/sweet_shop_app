class PostItemCategoryRequestModel {
  PostItemCategoryRequestModel({
    String? Name,
   // int? Parent_ID,
    int? Seq_No,
    String? Creator,
    String? Creator_Machine,}){
    _Name = Name;
   // _Parent_ID = Parent_ID;
    _Seq_No = Seq_No;
    _Creator = Creator;
    _Creator_Machine = Creator_Machine;
  }

  PostItemCategoryRequestModel.fromJson(dynamic json) {
    _Name = json['Name'];
  //  _Parent_ID = json['Parent_ID'];
    _Seq_No = json['Seq_No'];
    _Creator = json['Creator'];
    _Creator_Machine = json['Creator_Machine'];
  }
  String? _Name;
  //int? _Parent_ID;
  int? _Seq_No;
  String? _Creator;
  String? _Creator_Machine;

  String? get Name => _Name;
 // int? get Parent_ID => _Parent_ID;
  int? get Seq_No => _Seq_No;
  String? get Creator => _Creator;
  String? get Creator_Machine => _Creator_Machine;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['Name'] = _Name;
    //map['Parent_ID'] = _Parent_ID;
    map['Seq_No'] = _Seq_No;
    map['Creator'] = _Creator;
    map['Creator_Machine'] = _Creator_Machine;
    return map;
  }

}