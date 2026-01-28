import 'package:flutter/material.dart';

/// =======================================================
/// КОНСПЕКТ (ТЕОРИЯ)
///
/// 1. Анимация во Flutter — это плавное изменение UI во времени:
///    размера, позиции, прозрачности, цвета и т.д.
///
///    Когда применять:
///    - кнопки
///    - загрузка
///    - переходы
///    - изменение состояния UI
///
///    Ошибки:
///    1) Делать анимацию ради красоты без смысла
///    2) Слишком длинная или резкая анимация
///
/// -------------------------------------------------------
/// 2. Implicit-анимации (AnimatedContainer, AnimatedOpacity, AnimatedAlign)
///
///    Flutter сам анимирует переход между старыми и новыми значениями.
///
///    Когда применять:
///    - простые UI-анимации
///    - карточки
///    - кнопки
///
///    Ошибки:
///    1) Забыть setState()
///    2) Анимировать слишком много элементов
///
/// -------------------------------------------------------
/// 3. Duration и Curve
///
///    Duration — длительность анимации
///    Curve — характер движения (плавно, резко, с отскоком)
///
///    Ошибки:
///    1) Duration слишком большой (5 сек)
///    2) Curve не подходит под смысл анимации
///
/// -------------------------------------------------------
/// 4. Анимации состояний UI (pressed / loading / change)
///
///    Показывают:
///    - нажатие
///    - загрузку
///    - смену состояния
///
///    Ошибки:
///    1) Кнопка активна во время loading
///    2) Резкая смена без анимации
/// =======================================================

class AnimationAllDemo extends StatefulWidget {
  const AnimationAllDemo({super.key});

  @override
  State<AnimationAllDemo> createState() => _AnimationAllDemoState();
}

class _AnimationAllDemoState extends State<AnimationAllDemo> {
  // Для базовой анимации
  double boxSize = 100;

  // Для opacity
  bool visible = true;

  // Для curve demo
  double width = 100;

  // Для UI state animation
  bool isLoading = false;

  void startLoading() async {
    setState(() {
      isLoading = true;
    });

    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Flutter Animations Demo")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [

            /// =========================
            /// 1. БАЗОВАЯ АНИМАЦИЯ
            /// =========================
            const Text("1. Basic Animation (AnimatedContainer)"),
            const SizedBox(height: 10),

            AnimatedContainer(
              duration: const Duration(seconds: 1),
              width: boxSize,
              height: boxSize,
              color: Colors.blue,
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  boxSize = boxSize == 100 ? 200 : 100;
                });
              },
              child: const Text("Change Size"),
            ),

            const Divider(height: 40),

            /// =========================
            /// 2. IMPLICIT ANIMATION
            /// =========================
            const Text("2. Implicit Animation (AnimatedOpacity)"),
            const SizedBox(height: 10),

            AnimatedOpacity(
              duration: const Duration(seconds: 1),
              opacity: visible ? 1.0 : 0.0,
              child: const Text(
                "Hello Flutter",
                style: TextStyle(fontSize: 24),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  visible = !visible;
                });
              },
              child: const Text("Toggle Opacity"),
            ),

            const Divider(height: 40),

            /// =========================
            /// 3. DURATION + CURVE
            /// =========================
            const Text("3. Duration & Curve"),
            const SizedBox(height: 10),

            AnimatedContainer(
              duration: const Duration(milliseconds: 800),
              curve: Curves.easeInOut,
              width: width,
              height: 60,
              color: Colors.green,
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  width = width == 100 ? 250 : 100;
                });
              },
              child: const Text("Animate with Curve"),
            ),

            const Divider(height: 40),

            /// =========================
            /// 4. UI STATE ANIMATION (LOADING)
            /// =========================
            const Text("4. UI State Animation (Loading)"),
            const SizedBox(height: 10),

            AnimatedSwitcher(
              duration: const Duration(milliseconds: 500),
              child: isLoading
                  ? const CircularProgressIndicator(key: ValueKey(1))
                  : ElevatedButton(
                      key: const ValueKey(2),
                      onPressed: startLoading,
                      child: const Text("Send"),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
