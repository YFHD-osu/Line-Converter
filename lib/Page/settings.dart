import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:line_converter/core/database.dart';
import 'package:line_converter/page/home.dart';
import 'package:provider/provider.dart';

import 'package:line_converter/widgets.dart';
import 'package:line_converter/provider/theme.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  PrefsCache prefs = PrefsCache.fromMap({});
  late final sectionList = [
    const AccountSection(),
    const ThemeSection(),
    const SheetSection(),
    const HighLightSection()
  ];

  @override
  void initState() {
    super.initState();
    FireStore.instance.getPrefs();
  }

  Widget _appBar(BuildContext context) {
    final theme = Theme.of(context);
    return AppBar(
      elevation: 0,
      centerTitle: false,
      excludeHeaderSemantics: true,
      surfaceTintColor: theme.colorScheme.background,
      backgroundColor: theme.colorScheme.background.withOpacity(0.75),
      titleSpacing: 0,
      leadingWidth: 50,
      title: const Text("設定"),
      flexibleSpace: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 7, sigmaY: 7),
          child: Container(color: Colors.transparent))
      )
    );
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      resizeToAvoidBottomInset: false,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50),
        child: _appBar(context)
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: ListView.separated(
          itemCount: sectionList.length,
          itemBuilder:(context, index) => sectionList[index],
          separatorBuilder:(context, _) => const SizedBox(height: 10),
        )
      )
    );
  }
}

class ThemeSection extends StatefulWidget {
  const ThemeSection({super.key});

  @override
  State<ThemeSection> createState() => _ThemeSectionState();
}

class _ThemeSectionState extends State<ThemeSection> {
  late final ThemeProvider provider;
  ThemeMode currentTheme = ThemeMode.dark;

  void providerSetState() => setState(() {});

  @override
  void initState() {
    fetchTheme();
    super.initState();
  }

  @override
  void dispose() {
    provider.removeListener(providerSetState);
    super.dispose();
  }

  void fetchTheme() async {
    provider = Provider.of<ThemeProvider>(context, listen: false);
    currentTheme = await provider.fetch();
    provider.addListener(providerSetState);
  }
  
  @override
  Widget build(BuildContext context) {
    return SectionBase(
      title: "佈景主題",
      icon: Icons.display_settings,
      child: LayoutBuilder(
        builder: (context, constraint) {
          final double width = (constraint.maxWidth - 20) / 3;
          return Row(
            children: [
              ThemeButton(
                size: width,
                theme: ThemeMode.system,
              ),
              const SizedBox(width: 10),
              ThemeButton(
                size: width,
                theme: ThemeMode.dark,
              ),
              const SizedBox(width: 10),
              ThemeButton(
                size: width,
                theme: ThemeMode.light
              )
            ]
          );
        }
      )
    );
  }
}

class ThemeButton extends StatelessWidget {
  final double size;
  final ThemeMode theme;

  const ThemeButton({
    super.key,
    required this.size,
    required this.theme,
  });

  Border? getBorder(BuildContext context) {
    final provider = Provider.of<ThemeProvider>(context, listen: false);
    return (provider.theme == theme) ?
      Border.all(width: 3, color: Colors.green) : 
      Border.all(width: 3, color: Colors.transparent);  
  }

  String getThemeName(ThemeMode theme) {
    switch (theme.index) {
      case 0: return "系統";
      case 1: return "亮色";
      case 2: return "深色";
    }
    return "錯誤";
  }

  ThemeData getThemeData(ThemeMode theme, BuildContext context) {
    switch (theme.index) {
      case 0:
        final int platformBright = MediaQuery.of(context).platformBrightness.index;
        return (platformBright == 0) ? ThemePack.dark : ThemePack.light;
      case 1: return ThemePack.light;
      case 2: return ThemePack.dark;
    }
    return ThemePack.dark;
  }

  @override
  Widget build(BuildContext context) {
    final themeData = getThemeData(theme, context);
    final provider = Provider.of<ThemeProvider>(context, listen: false);

    return Theme(
      data: themeData,
      child: Material(
        clipBehavior: Clip.hardEdge,
        borderRadius: BorderRadius.circular(10),
        child: InkWell(
          child: AnimatedContainer(
            curve: Curves.easeInOut,
            width: size, height: size,
            duration: const Duration(milliseconds: 150),
            decoration: BoxDecoration(
              border: getBorder(context),
              borderRadius: BorderRadius.circular(10),
            ),
            child: ThemeIcon(
              title: getThemeName(theme)
            ),
          ),
          onTap: () async {
            await provider.toggle(theme);
          }
        )
      )
    );
  }
}

class ThemeIcon extends StatelessWidget {
  const ThemeIcon({
    super.key, 
    required this.title
  });

  final String title;

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    return LayoutBuilder(
      builder: (context, constraints) {
        final double maxHeight = constraints.maxHeight;
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            color: themeData.scaffoldBackgroundColor,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    "Aa",
                    style: TextStyle(
                      fontSize: maxHeight / 3.0415,
                      color: themeData.textTheme.titleLarge!.color,
                    )
                  ),
                  const Spacer(),
                  Container(
                    height: maxHeight / 3.0415,
                    width: maxHeight / 3.0415,
                    margin: const EdgeInsets.only(bottom: 5),
                    decoration: BoxDecoration(
                      color: themeData.colorScheme.surface,
                      borderRadius: BorderRadius.circular(10)
                    )
                  )
                ],
              ),
              Container(
                height: maxHeight / 24.332,
                margin: EdgeInsets.only(bottom: maxHeight / 24.332),
                decoration: BoxDecoration(
                  color: themeData.colorScheme.primary,
                  borderRadius: BorderRadius.circular(10)
                )
              ),
              Container(
                height: maxHeight / 24.332,
                margin: EdgeInsets.only(bottom: maxHeight / 24.332),
                decoration: BoxDecoration(
                  color: themeData.colorScheme.primary,
                  borderRadius: BorderRadius.circular(10)
                )
              ),
              Container(
                height: maxHeight / 24.332,
                decoration: BoxDecoration(
                  color: themeData.colorScheme.primary,
                  borderRadius: BorderRadius.circular(10)
                )
              ),
              Expanded(
                child: Center(
                  child: Text(title, style: TextStyle(
                    fontSize: maxHeight / 4.8664,
                    color: themeData.textTheme.labelLarge!.color,
                  ))
                )
              )
            ],
          )
        );
      }
    );
  }
}

class SheetSection extends StatefulWidget {

  const SheetSection({super.key});
  @override
  State<SheetSection> createState() => _SheetSectionState();
}

class _SheetSectionState extends State<SheetSection> {

  Future _onCredential(NavigatorState navigator) async {
    final prefs = FireStore.instance.prefs;
    final controller = TextEditingController(text: prefs.credential);
    await navigator.push(MaterialPageRoute(builder:(context) =>
      FullscreenTextBox(heroTag: " ", controller: controller)));
    prefs.credential = controller.text;
    FireStore.instance.setPrefs(prefs);
    setState(() {});
  }

  Future _onSheetTitle() async {
    await showDialog(context: context, builder:(context) => const SheetTitleDialog());
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final navigator = Navigator.of(context);
    return SectionBase(
      title: "表單設定",
      icon: Icons.edit_document,
      child: Column(
        children: [
          const SizedBox(height: 5),
          Row(
            children: [
              const Icon(Icons.account_box_outlined, size: 45),
              const SizedBox(width: 5),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(text: "服務帳號憑證\n",
                      style: theme.textTheme.labelLarge),
                    TextSpan(text: FireStore.instance.prefs.clientEmail??"尚未設定",
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: Colors.grey,
                        overflow: TextOverflow.ellipsis
                      ))
                  ]
                )
              ),
              const Spacer(),
              CupertinoButton(
                minSize: 0,
                padding: const EdgeInsets.symmetric(horizontal: 10),
                onPressed: () => _onCredential(navigator),
                child: const Text("編輯", style: TextStyle(color: Colors.green))
              )
            ]
          ),
          Row(
            children: [
              const Icon(Icons.edit, size: 45),
              const SizedBox(width: 5),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(text: "寫入表單名稱\n",
                      style: theme.textTheme.labelLarge),
                    TextSpan(text: "接車表",
                      style: theme.textTheme.labelSmall?.copyWith(color: Colors.grey))
                  ]
                )
              ),
              const Spacer(),
              CupertinoButton(
                minSize: 0,
                padding: const EdgeInsets.symmetric(horizontal: 10),
                onPressed: _onSheetTitle,
                child: const Text("變更", style: TextStyle(color: Colors.green))
              )
            ]
          )
        ]
      ),
    );
  }
}

class SheetTitleDialog extends StatefulWidget {
  const SheetTitleDialog({super.key});

  @override
  State<SheetTitleDialog> createState() => _SheetTitleDialogState();
}

class _SheetTitleDialogState extends State<SheetTitleDialog> {
  List<String> titleList = [];
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('選擇表單工作區'),
      content: ListView(
        children: const  [
          Text("TODO")
        ]
      ),
      actions: <Widget>[
        TextButton(
          child: const Text('Approve'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}

class AccountSection extends StatefulWidget {
  const AccountSection({super.key});

  @override
  State<AccountSection> createState() => _AccountSectionState();
}

class _AccountSectionState extends State<AccountSection> {

  Future<void> _logoutClick() async {
    await FireStore.instance.logout();
    setState(() {});
  }

  Future<void> _loginClick(bool isLogin) async {
    final update = await showDialog<bool?>(
      context: context,
      builder: (context) => AccountDialog(isLogin: isLogin)
    );
    if (update??false) setState(() {});
  }

  Widget _loginWidget() {
    final theme = Theme.of(context);
    return Column(
      children: [
        Row(
          children: [
            Container(
              width: 80, height: 80,
              clipBehavior: Clip.hardEdge,
              margin: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(15)),
              child: Image.network(FireStore.instance.imageUrl)
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(FireStore.instance.username??"", style: theme.textTheme.titleLarge),
                Text(FireStore.instance.email??"", style: theme.textTheme.labelMedium),
              ]
            ),
            const Spacer(),
            CupertinoButton(
              child: const Text("編輯", style: TextStyle(color: Colors.green)),
              onPressed: () {}
            )
          ],
        ),
        SizedBox(
          height: 40, width: double.infinity,
          child: TextButton(
            style: const ButtonStyle(
              backgroundColor: MaterialStatePropertyAll(Colors.red)
            ),
            onPressed: _logoutClick,
            child: const Text("登出")
          )
        )
      ]
    );
  }

  Widget _logoutWidget() {
    return Column(
      children: [
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: SizedBox(
                height: 40,
                child: TextButton(
                  onPressed: () => _loginClick(true),
                  child: const Text("登入")
                )
              )
            ),
            const SizedBox(width: 10),
            Expanded(
              child: SizedBox(
                height: 40,
                child: TextButton(
                  onPressed: () => _loginClick(false),
                  child: const Text("註冊")
                )
              )
            )
          ]
        )
      ]
    );
  }

  @override
  Widget build(BuildContext context) {
    final isLogin = FireStore.instance.loggedIn;

    return SectionBase(
      title: "帳號資訊", 
      icon: Icons.account_circle,
      child: isLogin ? _loginWidget() : _logoutWidget(),
    );
  }
}

class HighLightSection extends StatelessWidget {
  const HighLightSection({super.key});

  Future _onCredential(NavigatorState navigator) async {
    final prefs = FireStore.instance.prefs;
    final controller = TextEditingController(text: prefs.highlight);
    await navigator.push(MaterialPageRoute(builder:(context) =>
      FullscreenTextBox(heroTag: " ", controller: controller)));
    prefs.highlight = controller.text;
    await FireStore.instance.setPrefs(prefs);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SectionBase(
      title: "醒目標示",
      icon: Icons.highlight,
      child: Row(
        children: [
          const Icon(Icons.edit, size: 45),
          const SizedBox(width: 5),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(text: "變更醒目標示人員\n",
                  style: theme.textTheme.labelLarge),
                TextSpan(text: "用空格隔開每個人名",
                  style: theme.textTheme.labelSmall?.copyWith(color: Colors.grey))
              ]
            )
          ),
          const Spacer(),
          CupertinoButton(
            minSize: 0,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            onPressed: () => _onCredential(Navigator.of(context)),
            child: const Text("變更", style: TextStyle(color: Colors.green))
          )
        ]
      )
    );
  }
}

class SectionBase extends StatelessWidget {
  final Widget child;
  final String title;
  final IconData icon;

  const SectionBase({super.key, required this.child, required this.title, required this.icon});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.fromLTRB(10, 5, 10 ,10),
      decoration: BoxDecoration(
        color: theme.colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(10)
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(icon, size: 35),
              const SizedBox(width: 5),
              Text(title, style: theme.textTheme.bodyLarge)
            ]
          ),
          child
        ]
      ),
    );
  }
}