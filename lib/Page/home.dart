import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:line_converter/core/database.dart';
import 'package:line_converter/page/join.dart';
import 'package:line_converter/page/data_view.dart';
import 'package:line_converter/page/settings.dart';
import 'package:line_converter/core/typing.dart';
import 'package:line_converter/widgets.dart';

final morningKey = GlobalKey();
final eveningKey = GlobalKey();

class NavigationItem extends BottomNavigationBarItem{
  static BoxDecoration activeDecoration = BoxDecoration(
    color: Colors.green[200],
    shape: BoxShape.rectangle,
    borderRadius: const BorderRadius.all(Radius.circular(15))
  ); //Active BottomNavigationBarItem style

  NavigationItem({required icon, required super.label}) : 
  super(
    icon: Icon(icon),
    activeIcon: Container(
      width: 50,
      height: 25,
      decoration: activeDecoration,
      child: Icon(icon, color: Colors.black)
    )
  );
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _controller = PageController();

  Widget _appBar() {
    final theme = Theme.of(context);
    return AppBar(
      elevation: 0,
      centerTitle: false,
      excludeHeaderSemantics: true,
      surfaceTintColor: theme.colorScheme.background,
      backgroundColor: theme.colorScheme.background.withOpacity(0.75),
      leadingWidth: 0,
      titleSpacing: 0,
      title: Row(
        children: [
          Container(
            height: 40, width: 40,
            clipBehavior: Clip.hardEdge,
            margin: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.red
            ),
            child: Image.asset("assets/logo.png", fit: BoxFit.fitHeight)
          ),
          const Text("車表轉換"),
        ]
      ),
      actions: [
        FireStore.instance.loggedIn ? const SizedBox() : TextButton(
          child: Text("登入", style: theme.textTheme.titleMedium),
          onPressed: () async {
            final update = await showDialog<bool?>(
              context: context,
              builder: (context) => const AccountDialog()
            );
            if (update??false) setState(() {});
          }
        ),
        IconButton(
          icon: const Icon(Icons.add),
          onPressed: () async {
            await Navigator.of(context).push(MaterialPageRoute(builder: (context) => const JoinPage()));
            morningKey.currentState?.setState(() {});
            eveningKey.currentState?.setState(() {});
            setState(() {});
          }
        ),
        IconButton(
          icon: const Icon(Icons.settings),
          onPressed: () async {
            await Navigator.of(context).push(MaterialPageRoute(builder: (context) => const SettingPage()));
            morningKey.currentState?.setState(() {});
            eveningKey.currentState?.setState(() {});
            setState(() {});
          }
        )
      ],
      flexibleSpace: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 7, sigmaY: 7),
          child: Container(color: Colors.transparent))
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      bottom: true,
      child: Scaffold(
        extendBodyBehindAppBar: true,
        resizeToAvoidBottomInset: false,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(50),
          child: _appBar()
        ),
        body: SizedBox.expand(
          child: Column(
            children: [
              const SizedBox(height: 50),
              Padding(
                padding: const EdgeInsets.fromLTRB(5, 10, 5, 10),
                child: SizedBox(
                  width: double.infinity,
                  child: ModeSwitch(
                    onChange: (value) {
                      _controller.animateToPage(
                        value.index, 
                        duration: const Duration(milliseconds: 350),
                        curve: Curves.easeInOut
                      );
                    }
                  )
                )
              ),
              Expanded(
                child: PageView(
                  controller: _controller,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    DataView(key: morningKey, type: MessageType.morning),
                    DataView(key: eveningKey, type: MessageType.evening),
                  ]
                ) 
              )
            ]
          )
        )
      )
    );
  }
}


const Map<MessageType, Color> skyColors = <MessageType, Color>{
  MessageType.morning: Colors.green,
  MessageType.evening: Colors.green
};

class ModeSwitch extends StatefulWidget {
  final Function(MessageType)? onChange;

  const ModeSwitch({super.key, this.onChange});

  @override
  State<ModeSwitch> createState() => ModeSwitchState();
}

class ModeSwitchState extends State<ModeSwitch> {
  MessageType selected = MessageType.morning;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 3),
      child: CupertinoSlidingSegmentedControl<MessageType>(
        groupValue: selected,
        thumbColor: skyColors[selected]!,
        backgroundColor: theme.inputDecorationTheme.fillColor!,
        onValueChanged: (MessageType? value) {
          if (value != null) {
            setState(() {selected = value;});
            widget.onChange?.call(value);
          }
        },
        children: <MessageType, Widget>{
          MessageType.morning: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text('早班車', style: theme.textTheme.labelLarge)
          ),
          MessageType.evening: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text('晚班車', style: theme.textTheme.labelLarge)
          )
        }
      )
    );
  }
}

class IndexTile extends StatelessWidget {
  final DataDocs data;
  final List weekString = ['', '一', '二', '三', '四', '五', '六', '日'];

  IndexTile({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Material(
      clipBehavior: Clip.hardEdge,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        child: Stack(
          alignment: Alignment.bottomLeft,
          children: [
            SizedBox(
              height: 100,
              child: Ink.image(
                fit: BoxFit.fitWidth,
                image: const AssetImage('assets/img_breakfast.jpg')
              )
            ),
            Container(
              padding: const EdgeInsets.only(right: 5, left: 5),
              decoration: BoxDecoration(
                color: theme.inputDecorationTheme.fillColor,
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(15)
                )
              ),
              child: Text(
                '${data.timestamps.year}年${data.timestamps.month}月${data.timestamps.day}日 (${weekString[data.timestamps.weekday]})',
                style: Theme.of(context).textTheme.labelLarge),
            )
          ]
        ),
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => DataViewPage(data: data)))
      )
    );
  }
}

class DataView extends StatefulWidget {
  final MessageType type;

  const DataView({super.key, required this.type});

  @override
  State<DataView> createState() => _DataViewState();
}

class _DataViewState extends State<DataView> {
  List<DataDocs> data = [];

  Widget _empty() {
    final mediaQuery = MediaQuery.of(context);
    return SizedBox(
      width: double.infinity,
      height: mediaQuery.size.height - 190,
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.all_inbox_rounded, size: 300),
          Text('尚無資料')
        ]
      )
    );
  }

  Widget _tiles() => Padding(
    padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
    child: ClipRRect(
      clipBehavior: Clip.hardEdge,
      borderRadius: BorderRadius.circular(15),
      child: ListView.separated(
        padding: EdgeInsets.zero,
        itemCount: data.length,
        separatorBuilder: (context, index) => const SizedBox(height: 10),
        itemBuilder: (context, index) {
          return IndexTile(data: data[index]);
        }
      )
    )
  );

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: FireStore.instance.getData(widget.type),
      builder:(context, snapshot) {
        data = snapshot.data??[];
        if (data.isEmpty) return _empty();
        return _tiles();
      },
    );
  }
}

class AccountDialog extends StatefulWidget {
  const AccountDialog({
    super.key,
    this.isLogin = true
  });

  final bool isLogin;

  @override
  State<AccountDialog> createState() => _AccountDialogState();
}

class _AccountDialogState extends State<AccountDialog> {
  String? description;
  late bool autoLogin = false, loginMode = widget.isLogin;
  final email = TextEditingController();
  final username = TextEditingController();
  final password = TextEditingController();

  Future _registerClick() async {
    setState(() => description = null);
    final response = await FireStore.instance.register(username.text ,email.text, password.text, null, autoLogin);
    if (response.success) {_pop(true); return;}
    setState(() => description = response.description);
  }

  Future _loginClick() async {
    setState(() => description = null);
    final response = await FireStore.instance.login(email.text, password.text, autoLogin);
    if (response.success) {_pop(true); return;}
    setState(() => description = response.description);
  }

  void _pop(value) => Navigator.of(context).pop(value);

  Widget _loginDialog() {
    final theme = Theme.of(context);
    final mediaQuery = MediaQuery.of(context);
    
    return AlertDialog(
      key: const ValueKey<int>(0),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('登入'),
          Text('註冊或登入帳號已享有免費的雲端儲存空間', 
            style: theme.textTheme.labelSmall?.copyWith(color: Colors.grey))
        ]
      ),
      content: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            SizedBox(
              width: mediaQuery.size.width - 150,
              child: CupertinoTextBox(
                title: "帳號", controller: email,)
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: mediaQuery.size.width - 150,
              child: CupertinoTextBox(
                title: "密碼", controller: password, obscureText: true)
            ),
            const SizedBox(height: 5),
            description==null ? const SizedBox() : Text("$description",
              style: theme.textTheme.labelSmall?.copyWith(color: Colors.red)),
            const SizedBox(height: 5),
            FancySwitch(
              isEnable: autoLogin,
              title: "自動登入",
              lore: "保存這次的登入資訊以利下次自動登入",
              onChange: (value) => setState(() => autoLogin = value),
            )            
          ]
        )
      ),
      actions: <Widget>[
        CupertinoButton(
          minSize: 0,
          padding: EdgeInsets.zero,
          onPressed: () => setState(() => loginMode = false),
          child: const Text('註冊', style: TextStyle(color: Colors.green)),
        ),
        const SizedBox(width: 20),
        CupertinoButton(
          minSize: 0,
          padding: EdgeInsets.zero,
          onPressed: _loginClick,
          child: const Text('登入', style: TextStyle(color: Colors.green)),
        ),
      ]
    );
  }

  Widget _registerDialog() {
    final theme = Theme.of(context);
    final mediaQuery = MediaQuery.of(context);
    
    return AlertDialog(
      key: const ValueKey<int>(1),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('註冊'),
          Text('註冊或登入帳號已享有免費的雲端儲存空間', 
            style: theme.textTheme.labelSmall?.copyWith(color: Colors.grey))
        ]
      ),
      content: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            SizedBox(
              width: mediaQuery.size.width - 150,
              child: CupertinoTextBox(
                title: "名稱", controller: username)
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: mediaQuery.size.width - 150,
              child: CupertinoTextBox(
                title: "帳號", controller: email,)
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: mediaQuery.size.width - 150,
              child: CupertinoTextBox(
                title: "密碼", controller: password, obscureText: true)
            ),
            const SizedBox(height: 5),
            description==null ? const SizedBox() : Text("$description",
              style: theme.textTheme.labelSmall?.copyWith(color: Colors.red)),
            const SizedBox(height: 5),
            FancySwitch(
              isEnable: autoLogin,
              title: "自動登入",
              lore: "保存這次的登入資訊以利下次自動登入",
              onChange: (value) => setState(() => autoLogin = value),
            )
          ],
        ),
      ),
      actions: <Widget>[
        CupertinoButton(
          minSize: 0,
          padding: EdgeInsets.zero,
          onPressed: _registerClick,
          child: const Text('註冊', style: TextStyle(color: Colors.green)),
        )
      ]
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 350),
      child: loginMode ? _loginDialog() : _registerDialog()
    );
  }
}