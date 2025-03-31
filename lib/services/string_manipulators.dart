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

void main() {
  String formattedDate = formatDate("2025-05-26");
  print(formattedDate); // Output: 26th May, 2025
}
