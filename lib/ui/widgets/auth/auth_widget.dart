import 'package:flutter/material.dart';
import 'package:themoviedb/ui/theme/app_button_style.dart';

class AuthWidget extends StatefulWidget {
  AuthWidget({Key? key}) : super(key: key);

  @override
  _AuthWidgetState createState() => _AuthWidgetState();
}

class _AuthWidgetState extends State<AuthWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login to your account'),
      ),
      body: ListView(
        children: [
          SizedBox(
            height: 25,
          ),
          _HeaderWidget(),
        ],
      ),
    );
  }
}

class _HeaderWidget extends StatelessWidget {
  const _HeaderWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textStyle = const TextStyle(
      color: Colors.black,
      fontSize: 16,
    );
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 25,
          ),
          _FormWidget(),
          SizedBox(
            height: 25,
          ),
          Text(
              'Чтобы пользоваться правкой и возможностями рейтинга TMDb, а также получить персональные рекомендации, необходимо войти в свою учётную запись. Если у вас нет учётной записи, её регистрация является бесплатной и простой. Нажмите здесь,чтобы начать. ',
              style: textStyle),
          TextButton(
            onPressed: () {},
            child: Text('нажмите здесь'),
            style: AppButtonStyle.linkButtonStyle,
          ),
          SizedBox(
            height: 25,
          ),
          Text(
            'Если Вы зарегистрировались, но не получили письмо для подтверждения,нажмите здесь , чтобы отправить письмо повторно.',
            style: textStyle,
          ),
          TextButton(
            onPressed: () {},
            child: Text('нажмите здесь'),
            style: AppButtonStyle.linkButtonStyle,
          ),
        ],
      ),
    );
  }
}

class _FormWidget extends StatefulWidget {
  _FormWidget({Key? key}) : super(key: key);

  @override
  __FormWidgetState createState() => __FormWidgetState();
}

class __FormWidgetState extends State<_FormWidget> {
  final _loginTextController = TextEditingController(text: 'admin');
  final _passwordTextController = TextEditingController(text: 'admin');
  String? errorText;
  void _auth() {
    final login = _loginTextController.text;
    final password = _passwordTextController.text;
    if (login == 'admin' && password == 'admin') {
      errorText = null;

      final navigator = Navigator.of(context);
      navigator.pushReplacementNamed('/main_screen');
      // navigator.pushNamed('/main_screen');
    } else {
      errorText = 'не верный текст или пароль';
    }
    setState(() {});
  }

  void _resetPassword() {
    print('reset password');
  }

  @override
  Widget build(BuildContext context) {
    final textStyle = const TextStyle(
      color: Color(0xFF212529),
      fontSize: 16,
    );
    final textFildDecorator = const InputDecoration(
        border: OutlineInputBorder(),
        isCollapsed: true,
        contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10));
    final errorText = this.errorText;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (errorText != null) ...[
          Text(
            errorText,
            style: TextStyle(fontSize: 17, color: Colors.red),
          ),
          SizedBox(
            height: 20,
          ),
        ],
        Text(
          'UserName',
          style: textStyle,
        ),
        SizedBox(
          height: 5,
        ),
        TextField(
          controller: _loginTextController,
          decoration: textFildDecorator,
        ),
        SizedBox(
          height: 25,
        ),
        Text(
          'Password',
          style: textStyle,
        ),
        SizedBox(
          height: 5,
        ),
        TextField(
          controller: _passwordTextController,
          decoration: textFildDecorator,
          obscureText: true,
        ),
        SizedBox(
          height: 25,
        ),
        Row(
          children: [
            TextButton(
              style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all(Color.fromRGBO(1, 180, 228, 1)),
                  foregroundColor: MaterialStateProperty.all(Colors.white),
                  padding: MaterialStateProperty.all(
                      EdgeInsets.symmetric(horizontal: 15)),
                  textStyle: MaterialStateProperty.all(TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ))),
              onPressed: _auth,
              child: Text('Войти'),
            ),
            SizedBox(
              width: 30,
            ),
            TextButton(
              style: AppButtonStyle.linkButtonStyle,
              onPressed: _resetPassword,
              child: Text(
                'cбросить пароль',
              ),
            ),
          ],
        )
      ],
    );
  }
}
