/// Converts a date from `YYYY-MM-DD` format to `DDth Month, YYYY` format.
///
/// Example:
/// ```dart
/// formatDate("2025-05-26"); // Returns: "26th May, 2025"
/// ```
String formatDate(String inputDate) {
  // Parse input date (assumes format "YYYY-MM-DD")
  List<String> parts = inputDate.split('-');
  int year = int.parse(parts[0]);
  int month = int.parse(parts[1]);
  int day = int.parse(parts[2]);

  // Month names
  List<String> months = [
    "",
    "January",
    "February",
    "March",
    "April",
    "May",
    "June",
    "July",
    "August",
    "September",
    "October",
    "November",
    "December",
  ];

  // Get ordinal suffix
  String suffix = "th";
  if (day % 10 == 1 && day != 11)
    suffix = "st";
  else if (day % 10 == 2 && day != 12)
    suffix = "nd";
  else if (day % 10 == 3 && day != 13)
    suffix = "rd";

  return "$day$suffix ${months[month]}, $year";
}

/// Converts a datetime from `YYYY-MM-DD HH:MM:SS.sss` format to
/// `HH:MM AM/PM on DDth Month, YYYY` format.
///
/// Example:
/// ```dart
/// formatDateTime("2025-03-31 12:14:04.000"); // Returns: "12:14 PM on 31st March, 2025"
/// ```
String formatDateTime(String inputDateTime) {
  // Parse input datetime (assumes format "YYYY-MM-DD HH:MM:SS.sss")
  List<String> dateTimeParts = inputDateTime.split(' ');
  String datePart = dateTimeParts[0];
  String timePart = dateTimeParts[1];

  // Extract date components
  List<String> dateParts = datePart.split('-');
  int year = int.parse(dateParts[0]);
  int month = int.parse(dateParts[1]);
  int day = int.parse(dateParts[2]);

  // Extract time components
  List<String> timeParts = timePart.split(':');
  int hour = int.parse(timeParts[0]);
  int minute = int.parse(timeParts[1]);

  // Determine AM/PM and adjust hour
  String period = hour >= 12 ? "PM" : "AM";
  hour = hour % 12 == 0 ? 12 : hour % 12;

  // Month names
  List<String> months = [
    "",
    "January",
    "February",
    "March",
    "April",
    "May",
    "June",
    "July",
    "August",
    "September",
    "October",
    "November",
    "December",
  ];

  // Get ordinal suffix
  String suffix = "th";
  if (day % 10 == 1 && day != 11)
    suffix = "st";
  else if (day % 10 == 2 && day != 12)
    suffix = "nd";
  else if (day % 10 == 3 && day != 13)
    suffix = "rd";

  return "$hour:$minute $period on $day$suffix ${months[month]}, $year";
}
