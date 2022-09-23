import 'package:booking_app/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:booking_app/constants.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _rememberMe = false;

  var formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController nameController = TextEditingController();

  Future<Map<String, dynamic>?> userData() async {
    return (await FirebaseFirestore.instance.collection('users').
    doc("signed-up").get()).data();
  }

  DatabaseService databaseService = DatabaseService();

  String validateEmail(String? value) {
    String pattern =
        r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]"
        r"{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]"
        r"{0,253}[a-zA-Z0-9])?)*$";
    RegExp regex = RegExp(pattern);
    if (value == null || value.isEmpty || !regex.hasMatch(value))
      return 'Please enter a valid email address';
    else
      return '';
  }

  // EMAIL WIDGET
  Widget _buildEmailTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Email',
          style: kLabelStyle,
        ),
        SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationStyle,
          height: 60.0,
          // TEXT FIELD IS FOR THE PLACE TO ENTER EMAIL
          child: TextFormField(
            controller: emailController,
            keyboardType: TextInputType.emailAddress,
            style: TextStyle(
              color: Colors.black,
              fontFamily: 'OpenSans',
            ),
            validator: (value){

              if(onLoginScreen){
                if(validateEmail(value) != ''){
                  return validateEmail(value);
                }
                else{
                  if(emailFound){
                    print("EMAIL FOUND");
                    return null;
                  }
                  else{
                    return "Email not found";
                  }
                }
              }
              else{
                if(validateEmail(value) != ''){
                  return validateEmail(value);
                }
                else{
                  return null;
                }
              }
            },
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(
                Icons.email,
                color: Colors.black,
              ),
              hintText: 'Enter your email',
              hintStyle: kHintTextStyle,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNameTF() {
    if(!onLoginScreen){
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Full Name',
            style: kLabelStyle,
          ),
          SizedBox(height: 10.0),
          Container(
            alignment: Alignment.centerLeft,
            decoration: kBoxDecorationStyle,
            height: 60.0,
            // TEXT FIELD IS FOR THE PLACE TO ENTER EMAIL
            child: TextFormField(
              controller: nameController,
              keyboardType: TextInputType.emailAddress,
              style: TextStyle(
                color: Colors.black,
                fontFamily: 'OpenSans',
              ),
              decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.only(top: 14.0),
                prefixIcon: Icon(
                  Icons.email,
                  color: Colors.black,
                ),
                hintText: 'Enter your name',
                hintStyle: kHintTextStyle,
              ),
            ),
          ),
        ],
      );
    }
    else{
      return Container();
    }
  }


  bool passwordFound = false;

  bool validatePassword(AsyncSnapshot<dynamic> snapshot){
    int idx = 0;

    passwordFound = false;

    while(idx <= snapshot.data['total-user-amount']){
      if(snapshot.data['$idx']['password'] == passwordController.text) {
        setState(() {
          passwordFound = true;
          userLoggedInIndex = idx;
        });
        break;
      }
      idx++;
    }
    if(passwordFound){
      return true;
    }
    else{
      return false;
    }
  }


  bool emailFound = false;
  bool validateEmailEntered(AsyncSnapshot<dynamic> snapshot){

    print("BEFORE STARTING LOOP: $emailFound");

    emailFound = false;

    int idx = 0;
    while(idx <= snapshot.data['total-user-amount']){
      if(snapshot.data['$idx']['email'] == emailController.text) {
        print("SET STATE EMAIL FOUND");
        setState(() {
          emailFound = true;
          userLoggedInIndex = idx;
          userLoggedInEmail = emailController.text;
        });
        break;
      }
      idx++;
    }
    if(emailFound){
      return true;
    }
    else{
      return false;
    }
  }

  // PASSWORD WIDGET
  Widget _buildPasswordTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Password',
          style: kLabelStyle,
        ),
        SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationStyle,
          height: 60.0,
          // TEXT FIELD IS FOR THE PLACE TO ENTER PASSWORD
          child: TextFormField(
            controller: passwordController,
            obscureText: true,
            style: TextStyle(
              color: Colors.black,
              fontFamily: 'OpenSans',
            ),
            validator: (value){
              if(onLoginScreen){
                if(passwordFound){
                  print("PASSWORD FOUND");
                  return null;
                }
                else{
                  return "Please enter a valid password";
                }
              }
              else{
                if(value!.length < 4){
                  return 'Please enter a password greater than 4';
                }
                else{
                  return null;
                }
              }
            },
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(
                Icons.lock,
                color: Colors.black,
              ),
              hintText: 'Enter your password',
              hintStyle: kHintTextStyle,
            ),
          ),
        ),
      ],
    );
  }

  // FORGOT PASSWORD BUTTON
  Widget _buildForgotPasswordBtn() {
    return Container(
      alignment: Alignment.centerRight,
      child: FlatButton(
        onPressed: () => print('Forgot Password Button Pressed'),
        padding: EdgeInsets.only(right: 0.0),
        child: Text(
          'Forgot Password?',
          style: kLabelStyle,
        ),
      ),
    );
  }

  // REMEMBER ME WIDGET
  Widget _buildRememberMeCheckbox() {
    return Container(
      height: 20.0,
      child: Row(
        children: <Widget>[
          Theme(
            data: ThemeData(unselectedWidgetColor: Colors.black),
            child: Checkbox(
              value: _rememberMe,
              checkColor: Colors.green,
              activeColor: Colors.black,
              onChanged: (value) {
                setState(() {
                  _rememberMe = value!;
                });
              },
            ),
          ),
          Text(
            'Remember me',
            style: TextStyle(
              color: Colors.black
            ),
          ),
        ],
      ),
    );
  }

  // LOGIN BUTTON
  Widget _buildLoginBtn() {


    print("1");

    return FutureBuilder(
      future: userData(),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if(snapshot.connectionState == ConnectionState.done){
          if(snapshot.hasError){
            return const Text("There is an error");
          }
          else if(snapshot.hasData){
            print("2");
            return Container(
              padding: EdgeInsets.symmetric(vertical: 25.0),
              width: double.infinity,
              child: RaisedButton(
                elevation: 5.0,
                // THIS FUNCTION CONTROLS WHAT HAPPENS AFTER LOGIN BUTTON IS PRESSED
                onPressed: () async {


                  passwordFound = validatePassword(snapshot);
                  emailFound = validateEmailEntered(snapshot);

                  FocusScope.of(context).unfocus();
                  final isValid = formKey.currentState!.validate();

                  if(isValid){

                    print("IS VALID INFO");

                    formKey.currentState!.save();

                    if(!onLoginScreen){


                      print('1');

                      await databaseService.signUpUser(
                        nameController.text,
                        emailController.text,
                        passwordController.text,
                        snapshot.data['total-user-amount'] + 1,
                      );

                      print('2');

                      setState(() {
                        onLoginScreen = true;
                        emailFound = false;
                        passwordFound = false;
                      });
                    }
                    else{
                      setState(() {
                        loggedIn = true;
                        userLoggedInName = nameController.text;
                        userLoggedInEmail = emailController.text;
                      });

                      Navigator.pushNamed(context, '/payment');
                    }
                  }

                  print('Login Button Pressed');
                },
                padding: EdgeInsets.all(15.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
                color: Colors.lightBlue,
                child: Text(
                  onLoginScreen?'Login':'Sign up',
                  style: TextStyle(
                    color: Colors.white,
                    letterSpacing: 1.5,
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'OpenSans',
                  ),
                ),
              ),
            );
          }
        }
        return const Text("Please wait");
      },

    );
  }


  Widget _buildSignInWithText() {
    return Column(
      children: <Widget>[
        Text(
          '- OR -',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w400,
          ),
        ),
        SizedBox(height: 20.0),
        Text(
          'Sign in with',
          style: kLabelStyle,
        ),
      ],
    );
  }

  // GOOGLE OR FACEBOOK LOGIN BUTTON FUNCTION
  Widget _buildSocialBtn(Function onTap, AssetImage logo) {
    return GestureDetector(
      onTap: onTap(), // IN CHARGE OF WHAT HAPPENS WHEN ONE OF THE BUTTONS IS PRESSED
      child: Container(
        height: 60.0,
        width: 60.0,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              offset: Offset(0, 2),
              blurRadius: 6.0,
            ),
          ],
          image: DecorationImage(
            image: logo,
          ),
        ),
      ),
    );
  }

  Widget _buildSocialBtnRow() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 30.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          _buildSocialBtn(
                () => print('Login with Facebook'),
            AssetImage(
              'assets/all_images/facebook.jpg',
            ),
          ),
          _buildSocialBtn(
                () => print('Login with Google'),
            AssetImage(
              'assets/all_images/google.jpg',
            ),
          ),
        ],
      ),
    );
  }

  //SIGN UP BUTTON
  Widget _buildSignupBtn() {
    return GestureDetector(
      onTap: () {
        setState(() {
          onLoginScreen = false;
        });
      },
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: 'Don\'t have an Account? ',
              style: TextStyle(
                color: Colors.black,
                fontSize: 18.0,
                fontWeight: FontWeight.w400,
              ),
            ),
            TextSpan(
              text: 'Sign Up',
              style: TextStyle(
                color: Colors.black,
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }


  // BUILD FUNCTION
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: Form(
          key: formKey,
          child: GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: Stack(
              children: <Widget>[
                Container(
                  height: double.infinity,
                  child: SingleChildScrollView(
                    physics: AlwaysScrollableScrollPhysics(),
                    padding: EdgeInsets.symmetric(
                      horizontal: 40.0,
                      vertical: 90.0,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          'Welcome to Servnn!',
                          style: GoogleFonts.lato(textStyle: TextStyle(
                            color: Colors.black,
                            fontSize: 30.0,
                            fontWeight: FontWeight.bold,
                          ),),
                        ),
                        SizedBox(height: 10,),
                        Text(
                          onLoginScreen?'Login':'Sign up',
                          style: TextStyle(
                            color: Colors.black,
                            fontFamily: 'OpenSans',
                            fontSize: 25.0,
                            // fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 30.0),
                        _buildNameTF(),
                        SizedBox(height: 30.0),
                        _buildEmailTF(),
                        SizedBox(
                          height: 30.0,
                        ),
                        _buildPasswordTF(),
                        _buildForgotPasswordBtn(),
                        _buildRememberMeCheckbox(),
                        _buildLoginBtn(),
                        _buildSignInWithText(),
                        _buildSocialBtnRow(),
                        _buildSignupBtn(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}