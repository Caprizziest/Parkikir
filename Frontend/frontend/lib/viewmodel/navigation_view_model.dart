import 'package:flutter_riverpod/flutter_riverpod.dart';

enum NavigationTab { home, history, profile }

class NavigationViewModel extends StateNotifier<NavigationTab> {
  NavigationViewModel() : super(NavigationTab.home);

  void setCurrentTab(NavigationTab tab) {
    state = tab;
  }

  bool isTabActive(NavigationTab tab) {
    return state == tab;
  }
}

final navigationViewModelProvider =
    StateNotifierProvider<NavigationViewModel, NavigationTab>((ref) {
  return NavigationViewModel();
});
