import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:job_portal/Services/global_variables.dart';
import 'dart:io';
class SignUp extends StatefulWidget {


  @override
  State<SignUp> createState() => _SingUpState();
}

class _SingUpState extends State<SignUp> with TickerProviderStateMixin{
  late Animation<double> _animation;
  late AnimationController _animationController;
  final TextEditingController _fullNameController=TextEditingController(text: '');
  final TextEditingController _emailTextController =
  TextEditingController(text: '');
  final TextEditingController _passTextController =
  TextEditingController(text: '');

  FocusNode _emailFocusNode=FocusNode();

  FocusNode _passFocusNode=FocusNode();


  final _signUpFormKey =GlobalKey<FormState>();
  File? imageFile;

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
  @override
  void initState() {
    _animationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 20));
    _animation =
        CurvedAnimation(parent: _animationController, curve: Curves.linear);
    _animation.addListener(() {
      setState(() {});
    });
    if (_animationController.status == AnimationStatus.completed) {
      _animationController.reset();
      _animationController.forward();
    }
    _animationController.repeat();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size=MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          CachedNetworkImage(imageUrl:  singupUrlImage,
            placeholder: (context,url)=>Image.asset('assets/images/wallpaper.jpg',
            fit: BoxFit.fill,
            ),
            errorWidget: (context,url,error)=>const Icon(Icons.error),
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.cover,
            alignment: FractionalOffset(_animation.value,0),
          ),
          Container(
            color: Colors.black54,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 80),
              child: ListView   (
                children: [
                  Form(
                    key: _signUpFormKey,
                      child: Column(
                        children: [
                          GestureDetector(
                            onTap: (){

                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child:Container(
                                width: size.width * 0.40,
                                height: size.height * 0.2,
                                decoration: BoxDecoration(
                                  border: Border.all(width: 1,color:Colors.cyanAccent ),
                                  borderRadius: (BorderRadius.circular(40)),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(16.0),
                                  child: imageFile==null
                                    ? const Icon(Icons.camera_enhance_sharp,color: Colors.cyan,size: 30)
                                          :Image.file(imageFile!,fit: BoxFit.fill,)
                                ),
                              ),
                            ),
                          ),
                         SizedBox(height: 20,),
                          TextFormField(
                            textInputAction: TextInputAction.next,
                            onEditingComplete: () =>
                                FocusScope.of(context).requestFocus(),
                            keyboardType: TextInputType.name,
                            controller: _fullNameController,
                            validator: (value) {
                              if (value!.isEmpty ) {
                                return 'The field is messing ';
                              } else {
                                return null;
                              }
                            },
                            style: TextStyle(color: Colors.white),
                            decoration: const InputDecoration(
                              hintText: ' Full Name/Company Name',
                              hintStyle: TextStyle(color: Colors.white),
                              enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white)),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                              ),
                              errorBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.red),
                              ),
                            ),

                          ),
                          SizedBox(height: 20,),
                          TextFormField(
                            textInputAction: TextInputAction.next,
                            onEditingComplete: () =>
                                FocusScope.of(context).requestFocus(_passFocusNode),
                            keyboardType: TextInputType.emailAddress,
                            controller:_emailTextController,
                            validator: (value) {
                              if (value!.isEmpty || !value.contains('@')) {
                                return 'please enter a valid Email address';
                              } else {
                                return null;
                              }
                            },
                            style: TextStyle(color: Colors.white),
                            decoration: const InputDecoration(
                              hintText: 'Email ',
                              hintStyle: TextStyle(color: Colors.white),
                              enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white)),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                              ),
                              errorBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.red),
                              ),
                            ),

                          ),


                        ],
                      )
                  )
                ],
              ),
            ),

          )
        ],
        
      ),

    );
  }
}
