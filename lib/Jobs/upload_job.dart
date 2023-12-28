import 'package:flutter/material.dart';

import '../widgets/bottom_nav_bar.dart';

class UploadJobNow extends StatefulWidget {
  @override
  State<UploadJobNow> createState() => _UploadJobNowState();
}

class _UploadJobNowState extends State<UploadJobNow> {
  final _formKey = GlobalKey<FormState>();
  Widget _textTitle({required String label}) {
    return Padding(
      padding: EdgeInsets.all(5.0),
      child: Text(
        label,
        style: TextStyle(
          color: Colors.black,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _textFormFields({
    required String valueKey,
    required TextEditingController controller,
    required bool enabled,
    required Function fet,
    required int maxLength,
  }) {
    return Padding(
      padding: EdgeInsets.all(5),
      child: InkWell(
        onTap: () {
          fet();
        },
        child: TextFormField(
            validator: (value) {
              if (value!.isEmpty) {
                return 'Value is Missing';
              }
              return null;
            },
            controller: controller,
            enabled: enabled,
            key: ValueKey(valueKey),
            style: TextStyle(
              color: Colors.white,
            ),
            maxLines: valueKey == 'JobDescription' ? 3 : 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.deepOrange.shade300, Colors.blueAccent],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          stops: const [0.2, 0.9],
        ),
      ),
      child: Scaffold(
        bottomNavigationBar: BottomNavigationBarForApp(indexNum: 2),
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: const Text('Upload Job Now'),
          centerTitle: true,
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.deepOrange.shade300, Colors.blueAccent],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                stops: const [0.2, 0.9],
              ),
            ),
          ),
        ),
        body: Center(
          child: Padding(
            padding: EdgeInsets.all(7.0),
            child: Card(
              color: Colors.white10,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 10.0,
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Padding(
                        padding: EdgeInsets.all(8),
                        child: Text(
                          'Please fill all field',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 40,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Signatra'),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Divider(
                      thickness: 1,
                    ),
                    Padding(
                      padding: EdgeInsets.all(8),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [_textTitle(label: 'Job Category')],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
