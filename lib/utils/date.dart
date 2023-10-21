extension DateTimeExtension on DateTime {
  String timeAgo() {
    final difference = DateTime.now().difference(this);
    if (difference.inDays > 365) {
      return "${(difference.inDays / 365).floor()} años";
    } else if (difference.inDays > 30) {
      return "${(difference.inDays / 30).floor()} meses";
    } else if (difference.inDays > 7) {
      return "${(difference.inDays / 7).floor()} semanas";
    } else if (difference.inDays > 0) {
      return "${difference.inDays} dias";
    } else if (difference.inHours > 0) {
      return "${difference.inHours} horas";
    } else if (difference.inMinutes > 0) {
      return "${difference.inMinutes} minutos";
    } else if (difference.inSeconds > 0) {
      return "${difference.inSeconds} segundos";
    } else {
      return "Ahora";
    }
  }

  String beautify() {
    return "${this.day}/${this.month}/${this.year}";
  }

  DateTime nextMonth() {
    return DateTime(this.year, this.month + 1, this.day);
  }

  String readable() {
    return "${this.monthName()} ${this.day}, ${this.year}";
  }

  String monthName() {
    switch (this.month) {
      case 1:
        return "Enero";
      case 2:
        return "Febrero";
      case 3:
        return "Marzo";
      case 4:
        return "Abril";
      case 5:
        return "Mayo";
      case 6:
        return "Junio";
      case 7:
        return "Julio";
      case 8:
        return "Agosto";
      case 9:
        return "Septiembre";
      case 10:
        return "Octubre";
      case 11:
        return "Noviembre";
      case 12:
        return "Diciembre";
    }
    return "";
  }

  String dayName() {
    switch (this.weekday) {
      case 1:
        return "Lunes";
      case 2:
        return "Martes";
      case 3:
        return "Miercoles";
      case 4:
        return "Jueves";
      case 5:
        return "Viernes";
      case 6:
        return "Sabado";
      case 7:
        return "Domingo";
    }
    return "";
  }
}
