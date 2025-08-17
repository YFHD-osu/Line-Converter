
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:line_converter/core/database.dart';

class RollCall extends StatefulWidget {
  const RollCall({super.key});

  @override
  State<RollCall> createState() => _RollCallState();
}

class _RollCallState extends State<RollCall> {
  Widget _appBar() {
    final theme = Theme.of(context);
    return AppBar(
      elevation: 0,
      titleSpacing: 0,
      leadingWidth: 0,
      centerTitle: false,
      excludeHeaderSemantics: true,
      surfaceTintColor: theme.colorScheme.surfaceDim,
      backgroundColor: theme.colorScheme.surfaceDim.withValues(alpha: 0.75),
      title: Row(
        children: [
          Container(
            height: 40, width: 40,
            clipBehavior: Clip.hardEdge,
            margin: const EdgeInsets.only(left: 10, right: 5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Image.asset("assets/logo.png", fit: BoxFit.fitHeight)
          ),
          const Text("人員點名")
        ]
      ),
      actions: [
        FireStore.instance.loggedIn ? const SizedBox() : TextButton(
          child: Text("登入", style: theme.textTheme.titleMedium),
          onPressed: () async {
          }
        ),
        IconButton(
          icon: const Icon(Icons.add),
          onPressed: () async {
            setState(() {});
          }
        ),
        IconButton(
          icon: const Icon(Icons.settings),
          onPressed: () async {
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
    final theme = Theme.of(context);
    final mediaQuery = MediaQuery.of(context);
    final sideWidth = (mediaQuery.size.width - 30) * 0.5;

    return Scaffold(
      extendBodyBehindAppBar: true,
      resizeToAvoidBottomInset: false,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50),
        child: _appBar()
      ),
      body: SizedBox.expand(
        child: Column(
          children: [
            const SizedBox(height: 60),
            Row(
              children: [
                const SizedBox(width: 10),
                Container(
                  width: sideWidth,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(10)
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 3),
                  child: Text("男性", style: theme.textTheme.titleLarge),
                ),
                const SizedBox(width: 10),
                Container(
                  width: sideWidth,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.pink,
                    borderRadius: BorderRadius.circular(10)
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 3),
                  child: Text("女性", style: theme.textTheme.titleLarge),
                )
              ]
            ),
            const SizedBox(height: 10),
            const Expanded(
              child: SingleChildScrollView(
                child: Row(
                  children: [
                    SizedBox(width: 10),
                    PersonCard(),
                    SizedBox(width: 10),
                    PersonCard()
                  ]
                )
              )
            )
          ]
        )
      )
    );
  }
}

class PersonCard extends StatefulWidget {
  const PersonCard({super.key});

  @override
  State<PersonCard> createState() => _PersonCardState();
}

class _PersonCardState extends State<PersonCard> {
  
  Widget _personBox() {
    final mediaQuery = MediaQuery.of(context);
    final sideWidth = (mediaQuery.size.width - 30) * 0.5;

    final theme = Theme.of(context);

    return SizedBox(
      width: sideWidth,
      child: TextButton(
        style: ButtonStyle(
          padding: const WidgetStatePropertyAll(EdgeInsets.all(20)),
          backgroundColor: WidgetStatePropertyAll(theme.colorScheme.primaryContainer)
        ),
        onPressed: () {},
        child: const Column(
          children: [
            Text("磁吸太厚"),
            SizedBox(height: 10),
            Text("簽到時間: -2024/12/32")
          ]
        )
      )
    );
  }
  
  @override
  Widget build(BuildContext context) {
    // final mediaQuery = MediaQuery.of(context);
    // final sideWidth = (mediaQuery.size.width - 30) * 0.5;

    return SizedBox(
      child: Wrap(
        spacing: 10,
        direction: Axis.vertical,
        children: [
          _personBox(),
          _personBox(),
          _personBox(),
          _personBox(),
          _personBox(),
          _personBox(),
          _personBox(),
          _personBox(),
          _personBox(),
          _personBox()
        ]
      )
    );
  }
}