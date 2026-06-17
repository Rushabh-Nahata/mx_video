/// Sort order options shared across library, browser, and search results.
enum SortOrder { name, nameDesc, date, dateDesc, size, sizeDesc, duration }

extension SortOrderLabel on SortOrder {
  String get label => switch (this) {
        SortOrder.name => 'Name (A–Z)',
        SortOrder.nameDesc => 'Name (Z–A)',
        SortOrder.date => 'Date (Oldest)',
        SortOrder.dateDesc => 'Date (Newest)',
        SortOrder.size => 'Size (Smallest)',
        SortOrder.sizeDesc => 'Size (Largest)',
        SortOrder.duration => 'Duration',
      };
}
