import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutUs extends StatefulWidget {
  const AboutUs({super.key});

  @override
  State<AboutUs> createState() => _AboutUsState();
}

class _AboutUsState extends State<AboutUs> {
  final Uri _url = Uri.parse('https://eprayuktisewa.assam.gov.in/');
  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    return Scaffold(
      bottomNavigationBar: nicBottomBar(),
      appBar: AppBar(
        leading: GestureDetector(
          child: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.white,
          ),
          onTap: () {
            Navigator.pop(context);
          },
        ),
        title: Text("About Us"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
                height: height * 0.3,
                width: width,
                color: Color(0xff724bfb),
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      "lib/assets/eplogov2.png",
                      scale: 3,
                    ),
                  ],
                )),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: RichText(
                text: TextSpan(
                  style: TextStyle(
                      color: Colors.black, fontSize: 16), // Default text style
                  children: <TextSpan>[
                    const TextSpan(
                      text: "ePrayuktiSewa is a Framework:",
                    ),
                    TextSpan(
                      text: "\nhttps://eprayuktisewa.assam.gov.in",
                      style: TextStyle(color: Colors.blue),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          _launchUrl();
                        },
                    ),
                    const TextSpan(
                        text:
                            "\n\nDeveloped by: \nNational Informatics Centre, Assam State Centre.Three services are offered through the ePrayuktiSewa.\nThe services are delivered in a very short time period.",
                        style: TextStyle(fontSize: 16)),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget nicBottomBar() {
    return Container(
      child: Image.asset(
        'lib/assets/bottomLogo.png',
      ),
    );
  }

  Future<void> _launchUrl() async {
    if (!await launchUrl(_url)) {
      throw Exception('Could not launch $_url');
    }
  }
}
