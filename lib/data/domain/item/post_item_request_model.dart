class PostItemRequestModel {
  PostItemRequestModel({
    required this.Name,
    required this.CategoryID,
     this.Unit,
     this.Unit2,
     this.Unit2Factor,
     this.Unit2Base,
     this.Unit3,
     this.Unit3Factor,
     this.Unit3Base,
     this.PackSize,
     this.Rate,
     this.MinStock,
     this.MaxStock,
     this.HSNNo,
     this.ExtName,
     this.DefaultStore,
     this.DetailDesc,
    required this.Creator,
    required this.CreatorMachine,
     this.Photo,
  });

  late final String Name;
  late final String? CategoryID;
  late final String? Unit;
  late final String? Unit2;
  late final String? Unit2Factor;
  late final String? Unit2Base;
  late final String? Unit3;
  late final String? Unit3Factor;
  late final String? Unit3Base;
  late final String? PackSize;
  late final String? Rate;
  late final String? MinStock;
  late final String? MaxStock;
  late final String? HSNNo;
  late final String? ExtName;
  late final String? DefaultStore;
  late final String? DetailDesc;
  late final String? Creator;
  late final String? CreatorMachine;
  late final String? Photo;

  PostItemRequestModel.fromJson(Map<String, dynamic> json){
    Name = json['Name'];
    CategoryID = json['Category_ID'];
    Unit = json['Unit'];
    Unit2 = json['Unit2'];
    Unit2Factor = json['Unit2_Factor'];
    Unit2Base = json['Unit2_Base'];
    Unit3 = json['Unit3'];
    Unit3Factor = json['Unit3_Factor'];
    Unit3Base = json['Unit3_Base'];
    PackSize = json['Pack_Size'];
    Rate = json['Rate'];
    MinStock = json['Min_Stock'];
    MaxStock = json['Max_Stock'];
    HSNNo = json['HSN_No'];
    ExtName = json['Ext_Name'];
    DefaultStore = json['Default_Store'];
    DetailDesc = json['Detail_Desc'];
    Creator = json['Creator'];
    CreatorMachine = json['Creator_Machine'];
    Photo = json['Photo'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['Name'] = Name;
    _data['Category_ID'] = CategoryID;
    _data['Unit'] = Unit;
    _data['Unit2'] = Unit2;
    _data['Unit2_Factor'] = Unit2Factor;
    _data['Unit2_Base'] = Unit2Base;
    _data['Unit3'] = Unit3;
    _data['Unit3_Factor'] = Unit3Factor;
    _data['Unit3_Base'] = Unit3Base;
    _data['Pack_Size'] = PackSize;
    _data['Rate'] = Rate;
    _data['Min_Stock'] = MinStock;
    _data['Max_Stock'] = MaxStock;
    _data['HSN_No'] = HSNNo;
    _data['Ext_Name'] = ExtName;
    _data['Default_Store'] = DefaultStore;
    _data['Detail_Desc'] = DetailDesc;
    _data['Creator'] = Creator;
    _data['Creator_Machine'] = CreatorMachine;
    _data['Photo'] = Photo;
    return _data;
  }
}
