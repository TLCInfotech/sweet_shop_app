import 'dart:core';

class PostFranchiseeRequestModel {
  String? name;
  int? companyID;
  String? startDate;
  String? contactPerson;
  String? address;
  String? district;
  String? state;
  String? pinCode;
  String? country;
  String? contactNo;
  String? eMail;
  String? pANNo;
  List<int>? photo;
  String? extName;
  String? adharNo;
  String? gSTNo;
  String? fSSAINo;
  int? outstandingLimit;
  String? outstandingLimitType;
  int? paymentDays;
  String? bankName;
  String? bankBranch;
  String? iFSCCode;
  String? aCHolderName;
  String? accountNo;
  String? declaration;
  String? cINNo;
  List<int>? pANCardImage;
  List<int>? adharCardImage;
  List<int>? gSTImage;
  String? creator;
  String? creatorMachine;
  String? modifier;
  String? modifierMachine;

  PostFranchiseeRequestModel(
      {required this.name,
        required this.companyID,
        this.startDate,
        this.contactPerson,
        required this.address,
        required this.district,
        required this.state,
        required this.pinCode,
        this.country,
        this.contactNo,
        this.eMail,
        this.pANNo,
        this.photo,
        this.extName,
        this.adharNo,
        this.gSTNo,
        this.fSSAINo,
        this.outstandingLimit,
        this.outstandingLimitType,
        this.paymentDays,
        this.bankName,
        this.bankBranch,
        this.iFSCCode,
        this.aCHolderName,
        this.accountNo,
        this.declaration,
        this.cINNo,
        this.pANCardImage,
        this.adharCardImage,
        this.gSTImage,
        this.creator,
        this.creatorMachine,
        this.modifier,
        this.modifierMachine,
      });

  PostFranchiseeRequestModel.fromJson(Map<String, dynamic> json) {
    name = json['Name'];
    companyID = json['Company_ID'];
    startDate = json['Start_Date'];
    contactPerson = json['Contact_Person'];
    address = json['Address'];
    district = json['District'];
    state = json['State'];
    pinCode = json['Pin_Code'];
    country = json['Country'];
    contactNo = json['Contact_No'];
    eMail = json['EMail'];
    pANNo = json['PAN_No'];
    photo = json['Photo'].cast<int>();
    extName = json['Ext_Name'];
    adharNo = json['Adhar_No'];
    gSTNo = json['GST_No'];
    fSSAINo = json['FSSAI_No'];
    outstandingLimit = json['Outstanding_Limit'];
    outstandingLimitType = json['Outstanding_Limit_Type'];
    paymentDays = json['Payment_Days'];
    bankName = json['Bank_Name'];
    bankBranch = json['Bank_Branch'];
    iFSCCode = json['IFSC_Code'];
    aCHolderName = json['AC_Holder_Name'];
    accountNo = json['Account_No'];
    declaration = json['Declaration'];
    cINNo = json['CIN_No'];
    pANCardImage = json['PAN_Card_Image'].cast<int>();
    adharCardImage = json['Adhar_Card_Image'].cast<int>();
    gSTImage = json['GST_Image'].cast<int>();
    creator = json['Creator'];
    creatorMachine = json['Creator_Machine'];
    modifier= json['Modifier'];
    modifierMachine = json['Modifier_Machine'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Name'] = this.name;
    data['Company_ID'] = this.companyID;
    data['Start_Date'] = this.startDate;
    data['Contact_Person'] = this.contactPerson;
    data['Address'] = this.address;
    data['District'] = this.district;
    data['State'] = this.state;
    data['Pin_Code'] = this.pinCode;
    data['Country'] = this.country;
    data['Contact_No'] = this.contactNo;
    data['EMail'] = this.eMail;
    data['PAN_No'] = this.pANNo;
    data['Photo'] = this.photo;
    data['Ext_Name'] = this.extName;
    data['Adhar_No'] = this.adharNo;
    data['GST_No'] = this.gSTNo;
    data['FSSAI_No'] = this.fSSAINo;
    data['Outstanding_Limit'] = this.outstandingLimit;
    data['Outstanding_Limit_Type'] = this.outstandingLimitType;
    data['Payment_Days'] = this.paymentDays;
    data['Bank_Name'] = this.bankName;
    data['Bank_Branch'] = this.bankBranch;
    data['IFSC_Code'] = this.iFSCCode;
    data['AC_Holder_Name'] = this.aCHolderName;
    data['Account_No'] = this.accountNo;
    data['Declaration'] = this.declaration;
    data['CIN_No'] = this.cINNo;
    data['PAN_Card_Image'] = this.pANCardImage;
    data['Adhar_Card_Image'] = this.adharCardImage;
    data['GST_Image'] = this.gSTImage;
    data['Creator'] = this.creator;
    data['Creator_Machine'] = this.creatorMachine;
    data['Modifier'] = modifier;
    data['Modifier_Machine'] = modifierMachine;
    return data;
  }
}
