enum TypeEnum { sales, spg }

extension TypeEnumExtension on TypeEnum {
  String get name {
    switch (this) {
      case TypeEnum.spg:
        return "sales";
      case TypeEnum.sales:
        return "spg";
      default:
        return "";
    }
  }
}
