# AnywhereOverlay
`anywhere_overlay` is a Flutter package that provides a simple and flexible way to show overlays anywhere in your app's UI.

## Getting Started
To use this package, add `anywhere_overlay` as a dependency in your `pubspec.yaml` file.

```yaml
dependencies:
  anywhere_overlay: ^1.0.0
```

## Import
```dart
import 'package:anywhere_overlay/anywhere_overlay.dart';
```

## Usage
in your MaterialApp/CupertinoApp initialize AnywhereOverlay :

```dart
MaterialApp(
      home: const Scaffold(
        body: Center(
          child: Text('Hello World!'),
        ),
      ),
      // Add This Line To Initialize AnyWhereOverlay
      builder: AnyWhereOverlay.init(),
    )
```
### Show OverLay
whenever you want to show the overlay call `AnyWhereOverlay.show(Widget child)` method
```dart
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
            // Method To show Overlay
            AnyWhereOverlay.show(
              barrierDismissible: true,
              child: Container(
                height: 100,
                width: 100,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(.5),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const CircularProgressIndicator(strokeWidth: 2),
              ),
            );
          },
          child: const Text("Show Overlay"),
        ),
      ),
    );
  }
}
```

### Dismiss OverLay
whenever you want to dismiss the overlay call `AnyWhereOverlay.dismiss()` Method
```dart
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
            // Method To show Overlay
            AnyWhereOverlay.show(
              child: Container(
                height: 100,
                width: 100,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(.5),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const CircularProgressIndicator(strokeWidth: 2),
              ),
            );

            Future.delayed(
              const Duration(seconds: 2),
              () {
                // Method To Hide Overlay
                AnyWhereOverlay.dismiss();
              },
            );
          },
          child: const Text("Show Overlay"),
        ),
      ),
    );
  }
}
```

## Styling
Package Offers Three Configurations

1. **animationDuration:** Duration Of Opacity Animation While Showing Or Dismissing The Overlay, **Default:** `200 milliseconds`.
1. **overlayBgColor:** Color of Overlay Background, **Default:** `Colors.black.withOpacity(.70)`.
1. **alignment**: Alignment for The Top/Child Widget, **Default:** `Alignment.center`

### To configure There are Three Ways,
1. While Calling init method
    ```dart
    void main() {
      runApp(const MainApp());
    }

    class MainApp extends StatelessWidget {
      const MainApp({super.key});

      @override
      Widget build(BuildContext context) {
        return MaterialApp(
          home: const HomeWidget(),
          builder: AnyWhereOverlay.init(),
        );
      }
    }
    ```

1. Using `AnyWhereOverlay.configure()` Method
    ```dart
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
                // Configuring Overlay Settings Using Configure Method
                AnyWhereOverlay.configure(
                  alignment: Alignment.bottomCenter,
                  animationDuration: const Duration(milliseconds: 500),
                  overlayBgColor: Colors.black.withOpacity(.5),
                );

                // Method To show Overlay
                AnyWhereOverlay.show(
                  child: Container(
                    height: 100,
                    width: 100,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(.5),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const CircularProgressIndicator(strokeWidth: 2),
                  ),
                );

                Future.delayed(
                  const Duration(seconds: 2),
                  () {
                    // Method To Hide Overlay
                    AnyWhereOverlay.dismiss();
                  },
                );
              },
              child: const Text("Show Overlay"),
            ),
          ),
        );
      }
    }
    ```
1. Using instance
    ```dart
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
                // Configuring Overlay Settings Using Instance
                final AnyWhereOverlay instance = AnyWhereOverlay.instance;
                instance.overlayBgColor = Colors.red.withOpacity(.5);
                instance.animationDuration = const Duration(seconds: 1);
                instance.alignment = Alignment.topCenter;

                // Method To show Overlay
                AnyWhereOverlay.show(
                  child: Container(
                    height: 100,
                    width: 100,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(.5),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const CircularProgressIndicator(strokeWidth: 2),
                  ),
                );

                Future.delayed(
                  const Duration(seconds: 2),
                  () {
                    // Method To Hide Overlay
                    AnyWhereOverlay.dismiss();
                  },
                );
              },
              child: const Text("Show Overlay"),
            ),
          ),
        );
      }
    }
    ```

> instance.overlayBgColor, instance.animationDuration, instance.alignment All are static Fields changing by any method will result the change globally

## Additional Arguments
### 1. *barrierDismissible* in show method *(default false)*
if set to true, user can dismiss the overlay by tapping the Outside the top widget

  ```dart
  AnyWhereOverlay.show(
                barrierDismissible: true,
                child: Container(
                  height: 100,
                  width: 100,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(.5),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const CircularProgressIndicator(strokeWidth: 2),
                ),
              )
  ```

### 2. *showAnimation* in dismiss dismiss method *(default true)*
sets weather to show closing animation on dismiss method, if set to false, overlay will close immediately, without any animation

  ```dart
  AnyWhereOverlay.dismiss(showAnimation: false);
  ```

> showAnimation and barrierDismissible arguments are not static, one must set these explicitly every time