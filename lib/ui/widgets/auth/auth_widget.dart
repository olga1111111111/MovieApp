import 'package:flutter/material.dart';
import 'package:themoviedb/ui/theme/app_button_style.dart';
import 'package:themoviedb/ui/widgets/auth/auth_model.dart';

class AuthWidget extends StatefulWidget {
  const AuthWidget({Key? key}) : super(key: key);

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

class _FormWidget extends StatelessWidget {
  const _FormWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = AuthProvaider.read(context)?.model;
    final textStyle = const TextStyle(
      color: Color(0xFF212529),
      fontSize: 16,
    );
    final textFildDecorator = const InputDecoration(
      border: OutlineInputBorder(),
      isCollapsed: true,
      contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _ErrorMessageWidget(),
        Text(
          'UserName',
          style: textStyle,
        ),
        const SizedBox(
          height: 5,
        ),
        TextField(
          controller: model?.loginTextController,
          decoration: textFildDecorator,
        ),
        const SizedBox(
          height: 25,
        ),
        Text(
          'Password',
          style: textStyle,
        ),
        const SizedBox(
          height: 5,
        ),
        TextField(
          controller: model?.passwordTextController,
          decoration: textFildDecorator,
          obscureText: true,
        ),
        const SizedBox(
          height: 25,
        ),
        Row(
          children: [
            _AuthButtonWidget(),
            SizedBox(
              width: 30,
            ),
            TextButton(
              style: AppButtonStyle.linkButtonStyle,
              onPressed: () {},
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

class _AuthButtonWidget extends StatelessWidget {
  const _AuthButtonWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = AuthProvaider.watch(context)?.model;
    const color = Color.fromRGBO(1, 180, 228, 1);
    final onPressed = // чтобы кнопка была не активная после одного нажатия авторизации
        model?.canStartAuth == true ? () => model?.auth(context) : null;
    final child = model?.isAuthProgress == true
        ? SizedBox(
            height: 20,
            width: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
            ),
          )
        : Text('Войти');
    return ElevatedButton(
      style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(color),
          foregroundColor: MaterialStateProperty.all(Colors.white),
          padding:
              MaterialStateProperty.all(EdgeInsets.symmetric(horizontal: 15)),
          textStyle: MaterialStateProperty.all(TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ))),
      onPressed: onPressed,
      child: child,
    );
  }
}

class _ErrorMessageWidget extends StatelessWidget {
  const _ErrorMessageWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final errorMassage = AuthProvaider.watch(context)?.model.errorMessage;
    // shrink схлопнется и пустое место покажет
    if (errorMassage == null) return SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Text(
        errorMassage,
        style: TextStyle(fontSize: 17, color: Colors.red),
      ),
    );
  }
}
