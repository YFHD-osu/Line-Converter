import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:line_converter/Page/join.dart';
import 'package:provider/provider.dart';

import 'package:line_converter/provider/theme.dart';

class SettingPage extends StatelessWidget {
  SettingPage({super.key});

  final sectionList = [
    const SizedBox(),
    const ThemeSection(),
    TargetSheet()
  ];

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
      title: Text("設定", style: theme.textTheme.titleMedium),
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
        padding: const EdgeInsets.symmetric(horizontal: 5),
        child: ListView.separated(
          itemCount: sectionList.length,
          itemBuilder:(context, index) => sectionList[index],
          separatorBuilder:(context, _) => const SizedBox(height: 5),
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
    final themeData = Theme.of(context);
    return Container(
      padding: const EdgeInsets.fromLTRB(10, 5, 10 ,10),
      decoration: BoxDecoration(
        color: themeData.colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(10)
      ),
      child: Column(
        children: [
          const Row(
            children: [
              Icon(Icons.display_settings, size: 30),
              SizedBox(width: 5),
              Text("佈景主題")
            ],
          ),
          const SizedBox(height: 5),
          LayoutBuilder(
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
                ],
              );
            }
          ),
        ],
      ),
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

class TargetSheet extends StatefulWidget {
  const TargetSheet({super.key});

  @override
  State<TargetSheet> createState() => _TargetSheetState();
}

class _TargetSheetState extends State<TargetSheet> {
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
          const Row(
            children: [
              Icon(Icons.edit_document, size: 30),
              SizedBox(width: 5),
              Text("表單設定")
            ]
          ),
          const SizedBox(height: 5),
          Row(
            children: [
              const Icon(Icons.account_box_outlined, size: 45),
              const SizedBox(width: 5),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(text: "服務帳號憑證\n",
                      style: theme.textTheme.labelMedium),
                    TextSpan(text: "yfhdtw@gmail.com",
                      style: theme.textTheme.labelSmall?.copyWith(color: Colors.grey))
                  ]
                )
              ),
              const Spacer(),
              CupertinoButton(
                minSize: 0,
                padding: const EdgeInsets.symmetric(horizontal: 10),
                onPressed: () {},
                child: Text("編輯", 
                  style: theme.textTheme.labelMedium?.copyWith(color: Colors.green)),
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
                      style: theme.textTheme.labelMedium),
                    TextSpan(text: "接車表",
                      style: theme.textTheme.labelSmall?.copyWith(color: Colors.grey))
                  ]
                )
              ),
              const Spacer(),
              CupertinoButton(
                minSize: 0,
                padding: const EdgeInsets.symmetric(horizontal: 10),
                onPressed: () async {
                  Navigator.of(context)
                  .push(MaterialPageRoute(builder:(context) =>
                    FullscreenTextBox(
                      heroTag: " ", controller: TextEditingController(),
                    )));
                },
                child: Text("變更", 
                  style: theme.textTheme.labelMedium?.copyWith(color: Colors.green)),
              )
            ]
          )
        ]
      )
    );
  }
}

class CertificateDialog extends StatefulWidget {
  const CertificateDialog({super.key});

  @override
  State<CertificateDialog> createState() => _CertificateDialogState();
}

class _CertificateDialogState extends State<CertificateDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('AlertDialog Title'),
      content: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Text("asdf"),
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