class PostLedgerRequestModel {
  String? name;
  String? groupID;
  String? Lang;
  String? contactPerson;
  String? address;
  String? district;
  String? state;
  String? pinCode;
  String? country;
  String? contactNo;
  String? eMail;
  String? pANNo;
  String? adharNo;
  String? gSTNo;
  String? cINNo;
  String? fSSAINo;
  String? outstandingLimit;
  String? outstandingLimitType;
  String? bankName;
  String? bankBranch;
  String? iFSCCode;
  String? accountNo;
  String? aCHolderName;
  String? hSNNo;
  String? gSTRate;
  String? cGSTRate;
  String? sGSTRate;
  String? cessRate;
  String? addCessRate;
  String? taxCategory;
  String? gSTType;
  String? tCSApplicable;
  String? extName;
  String? Tax_Type;
  String? remark;
  List<int>? photo;
  List<int>? pANCardImage;
  List<int>? adharCardImage;
  List<int>? gSTImage;
  String? creator;
  String? creatorMachine;
  String? companyId;

  PostLedgerRequestModel(
      {this.name,
        this.groupID,
        this.contactPerson,
        this.address,
        this.Lang,
        this.district,
        this.state,
        this.pinCode,
        this.country,
        this.contactNo,
        this.eMail,
        this.pANNo,
        this.adharNo,
        this.gSTNo,
        this.cINNo,
        this.fSSAINo,
        this.outstandingLimit,
        this.outstandingLimitType,
        this.bankName,
        this.bankBranch,
        this.iFSCCode,
        this.accountNo,
        this.aCHolderName,
        this.hSNNo,
        this.gSTRate,
        this.cGSTRate,
        this.sGSTRate,
        this.cessRate,
        this.addCessRate,
        this.taxCategory,
        this.gSTType,
        this.tCSApplicable,
        this.extName,
        this.Tax_Type,
        this.remark,
        this.photo,
        this.pANCardImage,
        this.adharCardImage,
        this.gSTImage,
        this.creator,
        this.creatorMachine,
        this.companyId
      });

  PostLedgerRequestModel.fromJson(Map<String, dynamic> json) {
    companyId=json['Company_ID'];
    name = json['Name'];
    Lang = json['Name_Locale'];
    groupID = json['Group_ID'];
    contactPerson = json['Contact_Person'];
    address = json['Address'];
    district = json['District'];
    state = json['State'];
    pinCode = json['Pin_Code'];
    country = json['Country'];
    contactNo = json['Contact_No'];
    eMail = json['EMail'];
    pANNo = json['PAN_No'];
    adharNo = json['Adhar_No'];
    gSTNo = json['GST_No'];
    cINNo = json['CIN_No'];
    Tax_Type = json['Tax_Type'];
    fSSAINo = json['FSSAI_No'];
    outstandingLimit = json['Outstanding_Limit'];
    outstandingLimitType = json['Outstanding_Limit_Type'];
    bankName = json['Bank_Name'];
    bankBranch = json['Bank_Branch'];
    iFSCCode = json['IFSC_Code'];
    accountNo = json['Account_No'];
    aCHolderName = json['AC_Holder_Name'];
    hSNNo = json['HSN_No'];
    gSTRate = json['GST_Rate'];
    cGSTRate = json['CGST_Rate'];
    sGSTRate = json['SGST_Rate'];
    cessRate = json['Cess_Rate'];
    addCessRate = json['Add_Cess_Rate'];
    taxCategory = json['Tax_Category'];
    gSTType = json['GST_Type'];
    tCSApplicable = json['TCS_Applicable'];
    extName = json['Ext_Name'];
    remark = json['Remark'];
    photo = json['Photo'].cast<int>();
    pANCardImage = json['PAN_Card_Image'].cast<int>();
    adharCardImage = json['Adhar_Card_Image'].cast<int>();
    gSTImage = json['GST_Image'].cast<int>();
    creator = json['Creator'];
    creatorMachine = json['Creator_Machine'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Company_ID'] = this.companyId;
    data['Name'] = this.name;
    data['Name_Locale'] = this.Lang;
    data['Group_ID'] = this.groupID;
    data['Contact_Person'] = this.contactPerson;
    data['Address'] = this.address;
    data['District'] = this.district;
    data['State'] = this.state;
    data['Pin_Code'] = this.pinCode;
    data['Country'] = this.country;
    data['Contact_No'] = this.contactNo;
    data['EMail'] = this.eMail;
    data['PAN_No'] = this.pANNo;
    data['Adhar_No'] = this.adharNo;
    data['GST_No'] = this.gSTNo;
    data['CIN_No'] = this.cINNo;
    data['FSSAI_No'] = this.fSSAINo;
    data['Outstanding_Limit'] = this.outstandingLimit;
    data['Outstanding_Limit_Type'] = this.outstandingLimitType;
    data['Bank_Name'] = this.bankName;
    data['Bank_Branch'] = this.bankBranch;
    data['IFSC_Code'] = this.iFSCCode;
    data['Account_No'] = this.accountNo;
    data['AC_Holder_Name'] = this.aCHolderName;
    data['HSN_No'] = this.hSNNo;
    data['GST_Rate'] = this.gSTRate;
    data['CGST_Rate'] = this.cGSTRate;
    data['SGST_Rate'] = this.sGSTRate;
    data['Cess_Rate'] = this.cessRate;
    data['Add_Cess_Rate'] = this.addCessRate;
    data['Tax_Category'] = this.taxCategory;
    data['GST_Type'] = this.gSTType;
    data['TCS_Applicable'] = this.tCSApplicable;
    data['Ext_Name'] = this.extName;
    data['Remark'] = this.remark;
    data['Photo'] = this.photo;
    data['PAN_Card_Image'] = this.pANCardImage;
    data['Adhar_Card_Image'] = this.adharCardImage;
    data['GST_Image'] = this.gSTImage;
    data['Creator'] = this.creator;
    data['Creator_Machine'] = this.creatorMachine;
    return data;
  }
}
