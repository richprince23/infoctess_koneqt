import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:resize/resize.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Privacy Policy'),
        scrolledUnderElevation: 0.5,
        elevation: 0,
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.w),
        child: SingleChildScrollView(
          child: RichText(
            text: TextSpan(
              style: GoogleFonts.sarabun(
                color: Colors.black,
                fontSize: 16.sp,
              ),
              children: <TextSpan>[
                TextSpan(
                  text:
                      'Privacy Policy for INFOCTESS Koneqt Mobile Application\n\n',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20.sp,
                  ),
                ),
                TextSpan(
                  text: 'Last updated: July 12, 2023\n\n',
                  style: TextStyle(
                    fontStyle: FontStyle.italic,
                    fontSize: 16.sp,
                  ),
                ),
                TextSpan(
                  text:
                      'This Privacy Policy outlines how ARKSoft Inc. ("we," "us," or "our") collects, uses, stores, and protects the personal information of members using the INFOCTESS Koneqt mobile application ("the App"). By using the App, you acknowledge and agree to the practices described in this Privacy Policy.\n\n',
                  style: TextStyle(fontSize: 18.sp),
                ),
                TextSpan(
                  text: '1. Information We Collect\n',
                  style:
                      TextStyle(fontWeight: FontWeight.bold, fontSize: 18.sp),
                ),
                TextSpan(
                  text: '1.1 Personal Information:\n',
                  style:
                      TextStyle(fontWeight: FontWeight.bold, fontSize: 16.sp),
                ),
                TextSpan(
                  text:
                      '- Full name: We require your full name to create and maintain your account.\n',
                  style: TextStyle(fontSize: 16.sp),
                ),
                TextSpan(
                  text:
                      '- Phone number: We collect your phone number for account verification and communication purposes.\n',
                  style: TextStyle(fontSize: 16.sp),
                ),
                TextSpan(
                  text:
                      '- Index number: Your index number is necessary to authenticate your membership with INFOCTESS.\n',
                  style: TextStyle(fontSize: 16.sp),
                ),
                TextSpan(
                  text:
                      '- Email address: We use your email address for account-related communication and to provide updates and notifications.\n',
                  style: TextStyle(fontSize: 16.sp),
                ),
                TextSpan(
                  text:
                      '- Level: We collect your level information to personalize your experience within the App.\n',
                  style: TextStyle(fontSize: 16.sp),
                ),
                TextSpan(
                  text:
                      '- Class group: Your class group helps us tailor certain features, such as group chats and event notifications, to your specific needs.\n',
                  style: TextStyle(fontSize: 16.sp),
                ),
                TextSpan(
                  text:
                      '- Username: We collect a unique username to identify you within the App.\n\n',
                  style: TextStyle(fontSize: 16.sp),
                ),
                TextSpan(
                  text: '1.2 Usage Data:\n',
                  style:
                      TextStyle(fontWeight: FontWeight.bold, fontSize: 16.sp),
                ),
                TextSpan(
                  text:
                      'We also collect certain usage data to enhance the App\'s functionality and improve user experience. This may include information about your interactions with the App, such as chat history, forum posts, event participation, and engagement with utilities like the GPA calculator and study resources.\n\n',
                  style: TextStyle(fontSize: 16.sp),
                ),
                TextSpan(
                  text: '2. Use of Information\n',
                  style:
                      TextStyle(fontWeight: FontWeight.bold, fontSize: 18.sp),
                ),
                TextSpan(
                  text: '2.1 Personal Information:\n',
                  style:
                      TextStyle(fontWeight: FontWeight.bold, fontSize: 16.sp),
                ),
                TextSpan(
                  text: '- We use the personal information collected to:\n',
                  style: TextStyle(fontSize: 16.sp),
                ),
                TextSpan(
                  text: '  - Create and maintain your account.\n',
                  style: TextStyle(fontSize: 16.sp),
                ),
                TextSpan(
                  text:
                      '  - Enable communication features such as chat and forum posting.\n',
                  style: TextStyle(fontSize: 16.sp),
                ),
                TextSpan(
                  text:
                      '  - Provide personalized content and features based on your level and class group.\n',
                  style: TextStyle(fontSize: 16.sp),
                ),
                TextSpan(
                  text:
                      '  - Facilitate access to utilities, including past questions, schedules, notes, and resources.\n',
                  style: TextStyle(fontSize: 16.sp),
                ),
                TextSpan(
                  text: '  - Securely store your data on our private server.\n',
                  style: TextStyle(fontSize: 16.sp),
                ),
                TextSpan(
                  text:
                      '  - Respond to your inquiries, feedback, or support requests.\n\n',
                  style: TextStyle(fontSize: 16.sp),
                ),
                TextSpan(
                  text: '2.2 Usage Data:\n',
                  style:
                      TextStyle(fontWeight: FontWeight.bold, fontSize: 16.sp),
                ),
                TextSpan(
                  text: 'We analyze usage data to:\n',
                  style: TextStyle(fontSize: 16.sp),
                ),
                TextSpan(
                  text:
                      '  - Improve the App\'s functionality and user experience.\n',
                  style: TextStyle(fontSize: 16.sp),
                ),
                TextSpan(
                  text: '  - Personalize and optimize content and features.\n',
                  style: TextStyle(fontSize: 16.sp),
                ),
                TextSpan(
                  text:
                      '  - Understand and address user preferences and needs.\n',
                  style: TextStyle(fontSize: 16.sp),
                ),
                TextSpan(
                  text:
                      '  - Monitor and detect fraudulent or unauthorized activities.\n\n',
                  style: TextStyle(fontSize: 16.sp),
                ),
                TextSpan(
                  text: '3. Data Sharing and Security\n',
                  style:
                      TextStyle(fontWeight: FontWeight.bold, fontSize: 18.sp),
                ),
                TextSpan(
                  text: '3.1 Data Sharing:\n',
                  style:
                      TextStyle(fontWeight: FontWeight.bold, fontSize: 16.sp),
                ),
                TextSpan(
                  text:
                      'We do not share your personal information with any third party, except in the following circumstances:\n',
                  style: TextStyle(fontSize: 16.sp),
                ),
                TextSpan(
                  text: '  - With your explicit consent.\n',
                  style: TextStyle(fontSize: 16.sp),
                ),
                TextSpan(
                  text:
                      '  - To comply with legal obligations or enforceable governmental requests.\n',
                  style: TextStyle(fontSize: 16.sp),
                ),
                TextSpan(
                  text:
                      '  - To protect our rights, privacy, safety, or property, or that of our users.\n\n',
                  style: TextStyle(fontSize: 16.sp),
                ),
                TextSpan(
                  text: '3.2 Security:\n',
                  style:
                      TextStyle(fontWeight: FontWeight.bold, fontSize: 16.sp),
                ),
                TextSpan(
                  text:
                      'We take reasonable measures to ensure the security of your personal information. We implement industry-standard practices to protect against unauthorized access, disclosure, alteration, or destruction of your data stored on our servers.\n\n',
                  style: TextStyle(fontSize: 16.sp),
                ),
                TextSpan(
                  text: '4. Third-Party Services\n',
                  style:
                      TextStyle(fontWeight: FontWeight.bold, fontSize: 18.sp),
                ),
                TextSpan(
                  text: '4.1 AI Studymate and AI Imager:\n',
                  style:
                      TextStyle(fontWeight: FontWeight.bold, fontSize: 16.sp),
                ),
                TextSpan(
                  text:
                      'The App may include features powered by OpenAI\'s API, such as AI Studymate and AI Imager (based on DALL-E). While these services enhance your experience, please note that they operate under their own privacy policies and terms of use. We encourage you to review their respective policies when using these features.\n\n',
                  style: TextStyle(fontSize: 16.sp),
                ),
                TextSpan(
                  text: '4.2 External Links:\n',
                  style:
                      TextStyle(fontWeight: FontWeight.bold, fontSize: 16.sp),
                ),
                TextSpan(
                  text:
                      'The App may provide links to external websites, such as PDFdrive.com, for additional resources. Please note that we are not responsible for the privacy practices or content of these third-party websites. We recommend reviewing their privacy policies before providing any personal information.\n\n',
                  style: TextStyle(fontSize: 16.sp),
                ),
                TextSpan(
                  text: '5. Data Retention\n',
                  style:
                      TextStyle(fontWeight: FontWeight.bold, fontSize: 18.sp),
                ),
                TextSpan(
                  text:
                      'We retain your personal information for as long as necessary to fulfill the purposes outlined in this Privacy Policy, unless a longer retention period is required or permitted by law.\n\n',
                  style: TextStyle(fontSize: 16.sp),
                ),
                TextSpan(
                  text: '6. Children\'s Privacy\n',
                  style:
                      TextStyle(fontWeight: FontWeight.bold, fontSize: 18.sp),
                ),
                TextSpan(
                  text:
                      'The App is intended for individuals who are at least 18 years old. We do not knowingly collect personal information from individuals under 18. If you become aware that a child has provided us with personal information without parental consent, please contact us, and we will promptly remove the information from our records.\n\n',
                  style: TextStyle(fontSize: 16.sp),
                ),
                TextSpan(
                  text: '7. Updates to this Privacy Policy\n',
                  style:
                      TextStyle(fontWeight: FontWeight.bold, fontSize: 18.sp),
                ),
                TextSpan(
                  text:
                      'We may update this Privacy Policy from time to time. We will notify you of any significant changes by posting the updated Privacy Policy within the App or through other communication channels. Please review this Privacy Policy periodically for the latest information on our data practices.\n\n',
                  style: TextStyle(fontSize: 16.sp),
                ),
                TextSpan(
                  text: '8. Contact Us\n',
                  style:
                      TextStyle(fontWeight: FontWeight.bold, fontSize: 18.sp),
                ),
                TextSpan(
                  text:
                      'If you have any questions, concerns, or requests regarding this Privacy Policy or the handling of your personal information, please contact us at richardkns7@gmail.com.\n\n',
                  style: TextStyle(fontSize: 16.sp),
                ),
                TextSpan(
                  text:
                      'By using the INFOCTESS Koneqt mobile application, you confirm that you have read, understood, and agree to the terms of this Privacy Policy.',
                  style: TextStyle(fontSize: 16.sp),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
