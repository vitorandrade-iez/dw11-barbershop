import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

// Uma simples implementação manual do loader que não depende das APIs específicas do AsyncState
class AppLoader {
  static OverlayEntry? _entry;

  static void show(BuildContext context) {
    _entry?.remove();
    _entry = OverlayEntry(
      builder: (context) => Container(
        color: const Color(0x80000000),
        child: Center(
          child: LoadingAnimationWidget.threeArchedCircle(
            color: Colors.white,
            size: 60,
          ),
        ),
      ),
    );

    Overlay.of(context).insert(_entry!);
  }

  static void hide() {
    _entry?.remove();
    _entry = null;
  }
}

// Extension method para facilitar o uso
extension Loader on BuildContext {
  void showLoader() => AppLoader.show(this);
  void hideLoader() => AppLoader.hide();
}
