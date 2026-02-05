import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

void main() {
  runApp(const MyApp());
}

/* =========================================================
   ROOT
========================================================= */
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Animations Lab',
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.blue),
      home: const HomeScreen(),
    );
  }
}

/* =========================================================
   HOME MENU
========================================================= */
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final items = [
      ('Staggered Animation', const StaggeredDemo()),
      ('Hero (List → Details)', const HeroListScreen()),
      ('AnimatedList', const AnimatedListDemo()),
      ('Onboarding PageView', const OnboardingScreen()),
      ('AnimatedSwitcher', const SwitcherDemo()),
      ('Lottie Demo', const LottieDemo()),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Flutter Animations')),
      body: ListView.builder(
        itemCount: items.length,
        itemBuilder: (_, i) => ListTile(
          title: Text(items[i].$1),
          trailing: const Icon(Icons.arrow_forward),
          onTap: () {
            Navigator.push(
              context,
              _fadeSlideRoute(items[i].$2),
            );
          },
        ),
      ),
    );
  }
}

/* =========================================================
   1. STAGGERED ANIMATION (Interval)
========================================================= */
class StaggeredDemo extends StatefulWidget {
  const StaggeredDemo({super.key});

  @override
  State<StaggeredDemo> createState() => _StaggeredDemoState();
}

class _StaggeredDemoState extends State<StaggeredDemo>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> fade;
  late Animation<Offset> slide;
  late Animation<double> scale;

  @override
  void initState() {
    super.initState();
    controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 2));

    fade = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: controller,
        curve: const Interval(0.0, 0.4, curve: Curves.easeIn),
      ),
    );

    slide = Tween(begin: const Offset(0, 0.3), end: Offset.zero).animate(
      CurvedAnimation(
        parent: controller,
        curve: const Interval(0.3, 0.7, curve: Curves.easeOut),
      ),
    );

    scale = Tween(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: controller,
        curve: const Interval(0.6, 1.0, curve: Curves.elasticOut),
      ),
    );

    controller.forward();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Staggered Animation')),
      body: Center(
        child: FadeTransition(
          opacity: fade,
          child: SlideTransition(
            position: slide,
            child: ScaleTransition(
              scale: scale,
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Text(
                  'Staggered',
                  style: TextStyle(color: Colors.white, fontSize: 22),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/* =========================================================
   2. HERO LIST → DETAILS
========================================================= */
class HeroListScreen extends StatelessWidget {
  const HeroListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Hero List')),
      body: ListView.builder(
        itemCount: 5,
        itemBuilder: (_, i) => ListTile(
          leading: Hero(
            tag: 'avatar_$i',
            child: CircleAvatar(child: Text('$i')),
          ),
          title: Text('Item $i'),
          onTap: () {
            Navigator.push(
              context,
              _fadeSlideRoute(HeroDetailsScreen(index: i)),
            );
          },
        ),
      ),
    );
  }
}

class HeroDetailsScreen extends StatelessWidget {
  final int index;
  const HeroDetailsScreen({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Details')),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Hero(
            tag: 'avatar_$index',
            child: CircleAvatar(radius: 60, child: Text('$index')),
          ),
          const SizedBox(height: 24),
          AnimatedOpacity(
            opacity: 1,
            duration: const Duration(milliseconds: 600),
            child: const Text(
              'Smooth details appearance',
              style: TextStyle(fontSize: 18),
            ),
          ),
        ],
      ),
    );
  }
}

/* =========================================================
   3. ANIMATED LIST
========================================================= */
class AnimatedListDemo extends StatefulWidget {
  const AnimatedListDemo({super.key});

  @override
  State<AnimatedListDemo> createState() => _AnimatedListDemoState();
}

class _AnimatedListDemoState extends State<AnimatedListDemo> {
  final listKey = GlobalKey<AnimatedListState>();
  final items = <int>[];
  int counter = 0;

  void addItem() {
    items.insert(0, counter++);
    listKey.currentState!.insertItem(0);
  }

  void removeItem() {
    if (items.isEmpty) return;
    final removed = items.removeAt(0);
    listKey.currentState!.removeItem(
      0,
      (context, animation) => SizeTransition(
        sizeFactor: animation,
        child: ListTile(title: Text('Removed $removed')),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AnimatedList'),
        actions: [
          IconButton(onPressed: addItem, icon: const Icon(Icons.add)),
          IconButton(onPressed: removeItem, icon: const Icon(Icons.remove)),
        ],
      ),
      body: AnimatedList(
        key: listKey,
        initialItemCount: items.length,
        itemBuilder: (_, i, animation) => SizeTransition(
          sizeFactor: animation,
          child: ListTile(title: Text('Item ${items[i]}')),
        ),
      ),
    );
  }
}

/* =========================================================
   4. ONBOARDING PAGEVIEW
========================================================= */
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final controller = PageController();
  int index = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: PageView(
              controller: controller,
              onPageChanged: (i) => setState(() => index = i),
              children: const [
                Center(child: Text('Welcome')),
                Center(child: Text('Learn')),
                Center(child: Text('Start')),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              3,
              (i) => AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: const EdgeInsets.all(6),
                width: index == i ? 20 : 8,
                height: 8,
                decoration: BoxDecoration(
                  color: index == i ? Colors.blue : Colors.grey,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

/* =========================================================
   5. ANIMATED SWITCHER
========================================================= */
class SwitcherDemo extends StatefulWidget {
  const SwitcherDemo({super.key});

  @override
  State<SwitcherDemo> createState() => _SwitcherDemoState();
}

class _SwitcherDemoState extends State<SwitcherDemo> {
  bool toggle = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('AnimatedSwitcher')),
      body: Center(
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 500),
          transitionBuilder: (child, animation) =>
              ScaleTransition(scale: animation, child: child),
          child: toggle
              ? Container(
                  key: const ValueKey(1),
                  width: 120,
                  height: 120,
                  color: Colors.blue,
                )
              : Container(
                  key: const ValueKey(2),
                  width: 120,
                  height: 120,
                  color: Colors.red,
                ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => setState(() => toggle = !toggle),
        child: const Icon(Icons.swap_horiz),
      ),
    );
  }
}

/* =========================================================
   6. LOTTIE
========================================================= */
class LottieDemo extends StatelessWidget {
  const LottieDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Lottie')),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Lottie.asset('assets/lottie/loading.json', height: 120),
          const SizedBox(height: 16),
          Lottie.asset('assets/lottie/success.json', height: 120),
        ],
      ),
    );
  }
}

/* =========================================================
   CUSTOM PAGE ROUTE (Fade + Slide)
========================================================= */
PageRouteBuilder _fadeSlideRoute(Widget page) {
  return PageRouteBuilder(
    transitionDuration: const Duration(milliseconds: 400),
    pageBuilder: (_, __, ___) => page,
    transitionsBuilder: (_, animation, __, child) {
      final slide =
          Tween(begin: const Offset(0, 0.1), end: Offset.zero).animate(animation);
      return FadeTransition(
        opacity: animation,
        child: SlideTransition(position: slide, child: child),
      );
    },
  );
}