import 'dart:async';
import 'package:flutter/material.dart';
import 'package:ssh/ssh.dart';
import 'package:flare_flutter/flare_actor.dart';

mixin M {}
class C = Container with M;
class txtCtrl = TextEditingController with M;

class SSHClientApp extends StatefulWidget {
  @override
  _SSHClientAppState createState() => _SSHClientAppState();
}

class _SSHClientAppState extends State<SSHClientApp> {
  var _result = '', result, client, set = false, anim = 'dormido';
  txtCtrl host = txtCtrl();
  txtCtrl user = txtCtrl();
  txtCtrl pass = txtCtrl();
  txtCtrl cmd = txtCtrl();

  setHost() {
    client = new SSHClient(
      host: host.text,
      port: 22,
      username: user.text,
      passwordOrKey: pass.text,
    );
    setState(() => anim = 'buscando');
    sshConnect();
  }

  Future<void> testSSH() async {
    result = await client.execute("pwd");
    setState(() => _result = '(pwd) # $result');
  }

  clearScr() => setState(() => _result = '');

  Future<void> sshConnect() async {
    result = await client.connect();
    setState(() {
      set = result == "session_connected" ? true : false;
      anim = 'reposo';
    });
  }

  @override
  Widget build(ctx) {
    var wdt = MediaQuery.of(context).size.width;
    InputDecoration inDec(hint) => InputDecoration(hintText: hint);

    Widget btnRow() => Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        FlatButton(child: Text('Test'), onPressed: set ? testSSH : null),
        FlatButton(child: Text('Clear'), onPressed: set ? clearScr : null),
        FlatButton(child: Text('Set'), onPressed: setHost),
      ],
    );

    Widget buildTF(txtCtrl ctrl, bool set, String hint,
        [bool isPass = false]) =>
        TextField(
          controller: ctrl,
          enabled: !set,
          decoration: inDec(hint),
          obscureText: isPass,
        );

    Widget showAnim(String anim) => FlareActor(
      'assets/robot.flr',
      alignment: Alignment.centerLeft,
      animation: anim,
      fit: BoxFit.cover,
    );

    return Scaffold(
      appBar: AppBar(
        leading: showAnim(anim),
        title: Text('SSH Client'),
      ),
      body: ListView(
        shrinkWrap: true,
        padding: EdgeInsets.all(15.0),
        children: <Widget>[
          Text("Connection settings"),
          Wrap(
            alignment: WrapAlignment.spaceAround,
            children: <Widget>[
              C(width: wdt / 2.5, child: buildTF(host, set, 'host')),
              C(width: wdt / 4, child: buildTF(user, set, 'user')),
              C(width: wdt / 4, child: buildTF(pass, set, 'pass', true)),
            ],
          ),
          btnRow(),
          C(
            alignment: Alignment.center,
            child: TextField(
              autocorrect: false,
              controller: cmd,
              enabled: set,
              decoration: inDec('cmd'),
              onEditingComplete: () async {
                setState(() => anim = 'buscando');
                result = await client.execute('${cmd.text}');
                setState(() {
                  _result += '(${cmd.text}) # $result';
                  cmd.text = '';
                  anim = 'reposo';
                });
              },
            ),
          ),
          Text(_result),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.clear),
        onPressed: () => setState(
              () {
            _result = '';
            cmd.text = '';
            set = !set;
            anim = 'dormido';
          },
        ),
      ),
    );
  }
}
