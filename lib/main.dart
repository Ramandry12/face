import 'package:face_recog_flutter/Pages/CreateCase/index.dart';
import 'package:face_recog_flutter/Pages/FindResult/index.dart';
import 'package:flutter/material.dart';
import 'package:face_recog_flutter/Config/index.dart';
import 'package:face_recog_flutter/Component/index.dart';
import 'package:face_recog_flutter/Pages/index.dart';
import 'package:face_recog_flutter/Url/index.dart';
import 'package:face_recog_flutter/StateManager/index.dart';
import 'package:face_recog_flutter/Model/index.dart';
import 'package:flutter/services.dart';

export 'package:face_recog_flutter/Config/index.dart';
export 'package:face_recog_flutter/Pages/index.dart';
export 'package:face_recog_flutter/Url/index.dart';
export 'package:face_recog_flutter/Component/index.dart';
export 'package:face_recog_flutter/StateManager/index.dart';
export 'package:face_recog_flutter/Model/index.dart';

void main() {
  runApp(MainApp());
}

final routes = <String, WidgetBuilder>{
  '/': (BuildContext context) => const SplashScreen(),
  '/Login': (BuildContext context) => const LoginScreen(),
  '/Register': (BuildContext context) => const RegisterScreen(),
  '/Home': (BuildContext context) => const HomeScreen(),
  '/Search': (BuildContext context) => const SearchScreen(),
  '/Stats': (BuildContext context) => const StatsScreen(),
  '/Profile': (BuildContext context) => const ProfileScreen(),
  '/FindPage': (BuildContext context) => const FindPageScreen(),
  '/FindResult': (BuildContext context) => const FindResultScreen(),
  '/EditProfile': (BuildContext context) => const EditProfile(),
  '/EditPassword': (BuildContext context) => const EditPassword(),
  '/AboutPage': (BuildContext context) => const AboutPage(),
  '/PageDetail': (BuildContext context) => const PageDetail(),
  '/CreateCase': (BuildContext context) => const CreateCaseScreen(),
  '/SelectPerson': (BuildContext context) => const SelectPerson(),
  '/LiveTagging': (BuildContext context) => const LiveTaggingScreen(),
};

class MainApp extends StatefulWidget {
  @override
  State<MainApp> createState() => MainAppState();
}

class MainAppState extends State<MainApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.light,
      theme: ThemeData(
        primaryColor: white,
        scaffoldBackgroundColor: white,
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: white,
          alignLabelWithHint: true,
          labelStyle: Helpers.styleInput(),
          hintStyle: Helpers.styleHint(),
          errorStyle: Helpers.errorStyle(),
          contentPadding: defaultInputEdge,
          border: DecoratedInputBorder(
            child: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: BorderSide.none,
            ),
            shadow: defaultBoxShadow,
          ),
          focusColor: basic,
          floatingLabelBehavior: FloatingLabelBehavior.always,
        ),
        pageTransitionsTheme: const PageTransitionsTheme(
          builders: {
            TargetPlatform.android: CustomTransitionBuilder(),
            TargetPlatform.iOS: CustomTransitionBuilder(),
            TargetPlatform.linux: CustomTransitionBuilder(),
            TargetPlatform.macOS: CustomTransitionBuilder(),
            TargetPlatform.windows: CustomTransitionBuilder(),
          },
        ),
        colorScheme: ThemeData().colorScheme.copyWith(
              primary: basic,
              secondary: transparent,
            ),
        textSelectionTheme: const TextSelectionThemeData(
          cursorColor: basic,
        ),
      ),
      initialRoute: '/',
      routes: routes,
      onGenerateRoute: (RouteSettings settings) {
        WidgetBuilder? builder = routes[settings.name];
        return MaterialPageRoute(
          settings: RouteSettings(
            name: settings.name,
          ),
          builder: (BuildContext context) => builder!(context),
        );
      },
    );
  }
}

class CustomTransitionBuilder extends PageTransitionsBuilder {
  const CustomTransitionBuilder();
  @override
  Widget buildTransitions<T>(
      route, context, animation, secondaryAnimation, child) {
    const begin = Offset(0.0, 0.25);
    const end = Offset.zero;
    const curve = Curves.easeIn;
    var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

    return FadeTransition(
      opacity: animation,
      child: SlideTransition(
        position: animation.drive(tween),
        child: child,
      ),
    );
  }
}
