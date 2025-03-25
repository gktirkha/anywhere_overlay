import 'package:anywhere_overlay/anywhere_overlay.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const HomeWidget(),
      // Initialize The Overlay
      builder: AnyWhereOverlay.init(
        // Configuring Overlay Properties
        animationDuration: const Duration(milliseconds: 150),
        alignment: Alignment.bottomCenter,
        overlayBgColor: Colors.blue.withAlpha(70),
      ),
    );
  }
}

class HomeWidget extends StatelessWidget {
  const HomeWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // Displaying Overlay
            // Overlay Will Have The Properties As Defined in init method
            AnyWhereOverlay.show(child: const LoadingWidget());

            Future.delayed(
              const Duration(seconds: 2),
              () async {
                // Dismissing Overlay
                await AnyWhereOverlay.dismiss();

                // Changing Properties using configure method
                AnyWhereOverlay.configure(
                  overlayBgColor: Colors.pink.withAlpha(70),
                  alignment: Alignment.center,
                );
                AnyWhereOverlay.show(child: const LoadingWidget());

                Future.delayed(
                  const Duration(seconds: 2),
                  () async {
                    // Animation will not pe played during dismiss
                    await AnyWhereOverlay.dismiss();

                    // changing property using instance
                    AnyWhereOverlay.instance.overlayBgColor =
                        Colors.deepPurple.withAlpha(70);
                    AnyWhereOverlay.instance.alignment = Alignment.topCenter;

                    // Making Overlay dismissible
                    AnyWhereOverlay.show(
                      child: const LoadingWidget(),
                      barrierDismissible: true,
                    );
                    Future.delayed(
                      const Duration(seconds: 2),
                      () {
                        AnyWhereOverlay.configure(
                          // Configuring Overlay Properties
                          animationDuration: const Duration(milliseconds: 150),
                          alignment: Alignment.bottomCenter,
                          overlayBgColor: Colors.blue.withAlpha(70),
                        );
                      },
                    );
                  },
                );
              },
            );
          },
          child: const Text("Start"),
        ),
      ),
    );
  }
}

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      width: 100,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withAlpha(50),
        borderRadius: BorderRadius.circular(12),
      ),
      child: const CircularProgressIndicator(strokeWidth: 2),
    );
  }
}
