import 'package:easy_localization/easy_localization.dart';
import 'package:fluent_ui/fluent_ui.dart' hide Page;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pilot_s3/pages/home_page/home_page.dart';
import 'package:pilot_s3/storage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  Storage storage = Storage();
  runApp(EasyLocalization(
      supportedLocales: const [Locale('en'), Locale('ru')],
      path: 'assets/translations',
      child: MyApp(
        storage: storage,
      )));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.storage});

  final Storage storage;

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider.value(
      value: storage,
      child: FluentApp(
        title: 'PilotS3',
        themeMode: ThemeMode.system,
        debugShowCheckedModeBanner: false,
        localizationsDelegates: context.localizationDelegates,
        supportedLocales: context.supportedLocales,
        locale: context.locale,
        darkTheme: FluentThemeData(
          brightness: Brightness.dark,
          accentColor: Colors.blue,
          visualDensity: VisualDensity.standard,
          focusTheme: FocusThemeData(
            glowFactor: is10footScreen(context) ? 2.0 : 0.0,
          ),
        ),
        theme: FluentThemeData(
          accentColor: Colors.blue,
          visualDensity: VisualDensity.standard,
          focusTheme: FocusThemeData(
            glowFactor: is10footScreen(context) ? 2.0 : 0.0,
          ),
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => HomePage(
                storage: storage,
              )
        },
      ),
    );
  }
}
