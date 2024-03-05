class CompanyRequestModel {
  String name;
  String? contactPerson;
  String address;
  String? address2;
  String? district;
  String? state;
  String? pinCode;
  String? country;
  String? bankName;
  String? ifscCode;
  String? contactNo;
  String? email;
  String? panNo;
  List<int>? photo;
  String? extName;
  String? adharNo;
  String? gstNo;
  String? fssaiNo;
  String? declaration;
  String? jurisdiction;
  String? cinNo;
  String? panCardImage;
  String? adharCardImage;
  String? gstImage;
  String creator;
  String creatorMachine;

  CompanyRequestModel({
    required this.name,
    this.contactPerson,
    required this.address,
     this.address2,
     this.district,
     this.state,
     this.pinCode,
     this.country,
    this.bankName,
    this.ifscCode,
    this.contactNo,
    this.email,
     this.panNo,
    this.photo,
    this.extName,
    this.adharNo,
    this.gstNo,
    this.fssaiNo,
    this.declaration,
    this.jurisdiction,
    this.cinNo,
    this.panCardImage,
    this.adharCardImage,
    this.gstImage,
    required this.creator,
    required this.creatorMachine,
  });

  Map<String, dynamic> toJson() {
    return {
      'Name': name,
      'Contact_Person': contactPerson ?? null,
      'Address': address,
      'Address2': address2,
      'District': district,
      'State': state,
      'Pin_Code': pinCode,
      'Country': country,
      'Bank_Name': bankName ?? null,
      'IFSC_Code': ifscCode ?? null,
      'Contact_No': contactNo ?? null,
      'EMail': email ?? null,
      'PAN_No': panNo,
      'Photo': photo ?? null,
      'Ext_Name': extName ?? null,
      'Adhar_No': adharNo ?? null,
      'GST_No': gstNo ?? null,
      'FSSAI_No': fssaiNo ?? null,
      'Declaration': declaration ?? null,
      'Jurisdiction': jurisdiction ?? null,
      'CIN_No': cinNo ?? null,
      'PAN_Card_Image': panCardImage ?? null,
      'Adhar_Card_Image': adharCardImage ?? null,
      'GST_Image': gstImage ?? null,
      'Creator': creator,
      'Creator_Machine': creatorMachine,
    };
  }
}
