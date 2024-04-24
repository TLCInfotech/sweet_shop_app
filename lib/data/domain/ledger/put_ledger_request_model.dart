class PutLedgerRequestModel {
  String? name;
  String? groupID;
  String? contactPerson;
  String? address;
  String? district;
  String? state;
  String? pinCode;
  String? country;
  String? contactNo;
  String? email;
  String? panNo;
  String? adharNo;
  String? gstNo;
  String? cinNo;
  String? fssaiNo;
  String? outstandingLimit;
  String? outstandingLimitType;
  String? bankName;
  String? bankBranch;
  String? ifscCode;
  String? accountNo;
  String? acHolderName;
  String? hsnNo;
  String? gstRate;
  String? cgstRate;
  String? sgstRate;
  String? cessRate;
  String? addCessRate;
  String? taxCategory;
  String? Tax_Type;
  String? tcsApplicable;
  String? extName;
  String? remark;
  final List<int>? Photo;
  final List<int>? panCardImage;
  final List<int>? adharCardImage;
  final List<int>? gstImage;
  String? modifier;
  String? modifierMachine;
  String? companyId;

  PutLedgerRequestModel({
    this.name,
    this.groupID,
    this.contactPerson,
    this.address,
    this.district,
    this.state,
    this.pinCode,
    this.country,
    this.contactNo,
    this.email,
    this.panNo,
    this.adharNo,
    this.gstNo,
    this.cinNo,
    this.fssaiNo,
    this.outstandingLimit,
    this.outstandingLimitType,
    this.bankName,
    this.bankBranch,
    this.ifscCode,
    this.accountNo,
    this.acHolderName,
    this.hsnNo,
    this.gstRate,
    this.cgstRate,
    this.sgstRate,
    this.cessRate,
    this.addCessRate,
    this.taxCategory,
    this.Tax_Type,
    this.tcsApplicable,
    this.extName,
    this.remark,
    this.Photo,
    this.panCardImage,
    this.adharCardImage,
    this.gstImage,
    this.modifier,
    this.modifierMachine,
    this.companyId,
  });

  Map<String, dynamic> toJson() {
    return {
      'Company_ID':companyId??'',
      'Name': name ?? '',
      'Group_ID': groupID ?? '',
      'Contact_Person': contactPerson ?? '',
      'Address': address ?? '',
      'District': district ?? '',
      'State': state ?? '',
      'Pin_Code': pinCode ?? '',
      'Country': country ?? '',
      'Contact_No': contactNo ?? '',
      'EMail': email ?? '',
      'PAN_No': panNo ?? '',
      'Adhar_No': adharNo ?? '',
      'GST_No': gstNo ?? '',
      'CIN_No': cinNo ?? '',
      'FSSAI_No': fssaiNo ?? '',
      'Outstanding_Limit': outstandingLimit ?? '',
      'Outstanding_Limit_Type': outstandingLimitType ?? '',
      'Bank_Name': bankName ?? '',
      'Bank_Branch': bankBranch ?? '',
      'IFSC_Code': ifscCode ?? '',
      'Account_No': accountNo ?? '',
      'AC_Holder_Name': acHolderName ?? '',
      'HSN_No': hsnNo ?? '',
      'Tax_Rate': gstRate ?? '',
      'CGST_Rate': cgstRate ?? '',
      'SGST_Rate': sgstRate ?? '',
      'Cess_Rate': cessRate ?? '',
      'Add_Cess_Rate': addCessRate ?? '',
      'Tax_Category': taxCategory ?? '',
      'Tax_Type': Tax_Type ?? '',
      'TCS_Applicable': tcsApplicable ?? '',
      'Ext_Name': extName ?? '',
      'Remark': remark ?? '',
      'Photo': Photo ?? null,
      'PAN_Card_Image': panCardImage ?? '',
      'Adhar_Card_Image': adharCardImage ?? '',
      'GST_Image': gstImage ?? '',
      'Modifier': modifier ?? '',
      'Modifier_Machine': modifierMachine ?? '',
    };
  }
}
