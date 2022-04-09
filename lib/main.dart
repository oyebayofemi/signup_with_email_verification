import 'package:email_auth/email_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:signup_with_email_verification/auth.config.dart';
import 'package:signup_with_email_verification/sigup.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.green,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late EmailAuth emailAuth;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    emailAuth = new EmailAuth(sessionName: "Test Session");
    emailAuth.config(remoteServerConfiguration);
  }

  sendOTP(String email) async {
    if (await emailAuth.config(remoteServerConfiguration)) {
      var res = await emailAuth.sendOtp(recipientMail: email, otpLength: 6);
      if (res) {
        print("Verification Code Sent!");
      } else {
        print("Failed to send the verification code");
      }
    }
  }

  verifyOTP(String email, String otp) async {
    showAlertDialog(context);
    if (await emailAuth.config(remoteServerConfiguration)) {
      var res = emailAuth.validateOtp(recipientMail: email, userOtp: otp);
      if (res) {
        print("Email Verified!");
        Navigator.pop(context);
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SignUpWidget(),
            ));
      } else {
        print("Invalid Verification Code");
      }
    }
  }

  showAlertDialog(BuildContext context) {
    AlertDialog alert = AlertDialog(
      content: new Row(
        children: [
          CircularProgressIndicator(),
          Container(margin: EdgeInsets.only(left: 5), child: Text("Loading")),
        ],
      ),
    );
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final TextEditingController _emailController = TextEditingController();
    final TextEditingController _optcontroller = TextEditingController();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("VERIFY YOUR UNIVERSITY"),
      ),
      body: Column(
        children: [
          Text(
            "Please enter your",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            "college/university email address",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: Colors.black38,
            ),
          ),
          SizedBox(
            height: 38,
          ),
          TextField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              hintText: "Enter email",
            ),
          ),
          SizedBox(
            height: 10,
          ),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () async {
                await sendOTP(_emailController.text);
              },
              style: ButtonStyle(
                foregroundColor:
                    MaterialStateProperty.all<Color>(Colors.purple),
                backgroundColor:
                    MaterialStateProperty.all<Color>(Colors.orange),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
              ),
              child: Padding(
                padding: EdgeInsets.all(14),
                child: Text(
                  'send the code',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 30,
          ),
          TextField(
            controller: _optcontroller,
            keyboardType: TextInputType.number,
            obscureText: true,
            decoration: InputDecoration(
              hintText: "Enter the 6 digit code",
              labelText: "Verification Code",
            ),
          ),
          SizedBox(
            height: 30.0,
          ),
          ElevatedButton(
              child: Text("Verify Code"),
              onPressed: () async {
                await verifyOTP(_emailController.text, _optcontroller.text);
              })
        ],
      ),
    );
  }
}
