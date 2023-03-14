//Con la notazione extension è possibile aggiungere delle funzioni a delle classi: la cosa bella è che che si possono usare i metodi direttamente sulle istanze delle classi basi
extension CapitalizeString on String {
  String capitalize() {
    if (length > 1) {
      return "${this[0].toUpperCase()}${substring(1)}";
    } else {
      return toUpperCase();
    }
  }
}
