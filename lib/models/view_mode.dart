/// Controls whether the library renders items as a grid or a list.
enum ViewMode { grid, list }

extension ViewModeIcon on ViewMode {
  bool get isGrid => this == ViewMode.grid;
}
