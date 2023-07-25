import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:resize/resize.dart';

class TermsConditionsScreen extends StatelessWidget {
  const TermsConditionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Terms and Conditions'),
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
                      'Terms and Conditions for INFOCTESS Koneqt Mobile Application\n\n',
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
                      'Please read these Terms and Conditions ("Terms") carefully before using the INFOCTESS Koneqt mobile application ("the App") developed by ARK Softwarez. ("we," "us," or "our"). These Terms govern your access to and use of the App. By using the App, you agree to be bound by these Terms. If you do not agree with any provision of these Terms, you may not use the App.\n\n',
                  style: TextStyle(fontSize: 18.sp),
                ),
                TextSpan(
                  text: '1. App Usage and Eligibility\n',
                  style:
                      TextStyle(fontWeight: FontWeight.bold, fontSize: 18.sp),
                ),
                TextSpan(
                  text: '1.1 Eligibility:\n',
                  style:
                      TextStyle(fontWeight: FontWeight.bold, fontSize: 16.sp),
                ),
                TextSpan(
                  text:
                      'The App is intended for use by members of the INFOCTESS student society. By using the App, you represent that you are a member of INFOCTESS or have obtained proper authorization to access and use the App on behalf of INFOCTESS.\n\n',
                  style: TextStyle(fontSize: 16.sp),
                ),
                TextSpan(
                  text: '1.2 Limited License:\n',
                  style:
                      TextStyle(fontWeight: FontWeight.bold, fontSize: 16.sp),
                ),
                TextSpan(
                  text:
                      'We grant you a limited, non-exclusive, non-transferable, revocable license to use the App for its intended purpose, solely for your personal and non-commercial use.\n\n',
                  style: TextStyle(fontSize: 16.sp),
                ),
                TextSpan(
                  text: '1.3 Prohibited Activities:\n',
                  style:
                      TextStyle(fontWeight: FontWeight.bold, fontSize: 16.sp),
                ),
                TextSpan(
                  text: 'You agree not to:\n',
                  style: TextStyle(fontSize: 16.sp),
                ),
                TextSpan(
                  text: '  a. Violate any applicable laws or regulations.\n',
                  style: TextStyle(fontSize: 16.sp),
                ),
                TextSpan(
                  text:
                      '  b. Infringe upon the intellectual property rights or privacy rights of others.\n',
                  style: TextStyle(fontSize: 16.sp),
                ),
                TextSpan(
                  text:
                      '  c. Use the App for any unauthorized or illegal purpose.\n',
                  style: TextStyle(fontSize: 16.sp),
                ),
                TextSpan(
                  text:
                      '  d. Impersonate or misrepresent your affiliation with any person or entity.\n',
                  style: TextStyle(fontSize: 16.sp),
                ),
                TextSpan(
                  text:
                      '  e. Access or attempt to access any non-public areas of the App or its server.\n',
                  style: TextStyle(fontSize: 16.sp),
                ),
                TextSpan(
                  text:
                      '  f. Engage in any activity that disrupts or interferes with the proper functioning of the App.\n\n',
                  style: TextStyle(fontSize: 16.sp),
                ),
                TextSpan(
                  text: '2. User Accounts and Security\n',
                  style:
                      TextStyle(fontWeight: FontWeight.bold, fontSize: 18.sp),
                ),
                TextSpan(
                  text: '2.1 Account Creation:\n',
                  style:
                      TextStyle(fontWeight: FontWeight.bold, fontSize: 16.sp),
                ),
                TextSpan(
                  text:
                      'To use certain features of the App, you may be required to create a user account. You agree to provide accurate, complete, and up-to-date information during the registration process. You are solely responsible for maintaining the confidentiality of your account credentials and for all activities that occur under your account.\n\n',
                  style: TextStyle(fontSize: 16.sp),
                ),
                TextSpan(
                  text: '2.2 Account Termination:\n',
                  style:
                      TextStyle(fontWeight: FontWeight.bold, fontSize: 16.sp),
                ),
                TextSpan(
                  text:
                      'We reserve the right to suspend or terminate your account at our sole discretion, without prior notice or liability, if we believe you have violated these Terms or engaged in any fraudulent, abusive, or unlawful activities.\n\n',
                  style: TextStyle(fontSize: 16.sp),
                ),
                TextSpan(
                  text: '3. Intellectual Property Rights\n',
                  style:
                      TextStyle(fontWeight: FontWeight.bold, fontSize: 18.sp),
                ),
                TextSpan(
                  text: '3.1 Ownership:\n',
                  style:
                      TextStyle(fontWeight: FontWeight.bold, fontSize: 16.sp),
                ),
                TextSpan(
                  text:
                      'The App, including its design, content, features, and functionality, is owned by ARKSoft Inc. and protected by intellectual property laws. You acknowledge and agree that we retain all rights, title, and interest in the App and its content.\n\n',
                  style: TextStyle(fontSize: 16.sp),
                ),
                TextSpan(
                  text: '3.2 Limited License:\n',
                  style:
                      TextStyle(fontWeight: FontWeight.bold, fontSize: 16.sp),
                ),
                TextSpan(
                  text:
                      'We grant you a limited, non-exclusive, non-transferable license to access and use the App solely for its intended purpose, in accordance with these Terms. You agree not to reproduce, distribute, modify, or create derivative works based on the App or its content without our prior written consent.\n\n',
                  style: TextStyle(fontSize: 16.sp),
                ),
                TextSpan(
                  text: '4. Privacy\n',
                  style:
                      TextStyle(fontWeight: FontWeight.bold, fontSize: 18.sp),
                ),
                TextSpan(
                  text:
                      'The collection and use of personal information through the App are governed by our Privacy Policy. By using the App, you consent to our collection, storage, and use of personal information in accordance with the Privacy Policy.\n\n',
                  style: TextStyle(fontSize: 16.sp),
                ),
                TextSpan(
                  text: '5. Third-Party Services and Links\n',
                  style:
                      TextStyle(fontWeight: FontWeight.bold, fontSize: 18.sp),
                ),
                TextSpan(
                  text: '5.1 Third-Party Services:\n',
                  style:
                      TextStyle(fontWeight: FontWeight.bold, fontSize: 16.sp),
                ),
                TextSpan(
                  text:
                      'The App may integrate or link to third-party services, applications, or websites. We do not endorse, control, or assume any responsibility for the content, privacy policies, or practices of these third-party services. Your interactions with such services are solely between you and the third party.\n\n',
                  style: TextStyle(fontSize: 16.sp),
                ),
                TextSpan(
                  text: '5.2 External Links:\n',
                  style:
                      TextStyle(fontWeight: FontWeight.bold, fontSize: 16.sp),
                ),
                TextSpan(
                  text:
                      'The App may provide links to external websites or resources for additional information or convenience. We are not responsible for the availability, accuracy, or content of these external links. Accessing these links is at your own risk.\n\n',
                  style: TextStyle(fontSize: 16.sp),
                ),
                TextSpan(
                  text: '6. Disclaimer of Warranties\n',
                  style:
                      TextStyle(fontWeight: FontWeight.bold, fontSize: 18.sp),
                ),
                TextSpan(
                  text:
                      'The App is provided on an "as is" and "as available" basis, without warranties of any kind, whether express or implied. We do not warrant that the App will be error-free, uninterrupted, secure, or free from viruses or other harmful components. Your use of the App is at your sole risk.\n\n',
                  style: TextStyle(fontSize: 16.sp),
                ),
                TextSpan(
                  text: '7. Limitation of Liability\n',
                  style:
                      TextStyle(fontWeight: FontWeight.bold, fontSize: 18.sp),
                ),
                TextSpan(
                  text:
                      'To the maximum extent permitted by law, ARKSoft Inc. and its affiliates, directors, officers, employees, agents, and licensors shall not be liable for any direct, indirect, incidental, special, consequential, or exemplary damages, including but not limited to damages for loss of profits, goodwill, data, or other intangible losses arising out of or in connection with your use or inability to use the App.\n\n',
                  style: TextStyle(fontSize: 16.sp),
                ),
                TextSpan(
                  text: '8. Modification and Termination\n',
                  style:
                      TextStyle(fontWeight: FontWeight.bold, fontSize: 18.sp),
                ),
                TextSpan(
                  text: '8.1 Modification:\n',
                  style:
                      TextStyle(fontWeight: FontWeight.bold, fontSize: 16.sp),
                ),
                TextSpan(
                  text:
                      'We reserve the right to modify, suspend, or discontinue the App or any part thereof, temporarily or permanently, without prior notice or liability. We may also modify these Terms from time to time by posting the updated Terms within the App. Your continued use of the App after such modifications constitutes your acceptance of the modified Terms.\n\n',
                  style: TextStyle(fontSize: 16.sp),
                ),
                TextSpan(
                  text: '8.2 Termination:\n',
                  style:
                      TextStyle(fontWeight: FontWeight.bold, fontSize: 16.sp),
                ),
                TextSpan(
                  text:
                      'We may terminate your access to the App, including your user account, without cause or notice, at any time and for any reason. Upon termination, you shall cease all use of the App, and any provisions of these Terms that, by their nature, should survive termination shall continue to apply.\n\n',
                  style: TextStyle(fontSize: 16.sp),
                ),
                TextSpan(
                  text: '9. Governing Law and Dispute Resolution\n',
                  style:
                      TextStyle(fontWeight: FontWeight.bold, fontSize: 18.sp),
                ),
                TextSpan(
                  text:
                      'These Terms shall be governed by and construed in accordance with the laws of Ghana. Any dispute, controversy, or claim arising out of or relating to these Terms or your use of the App shall be resolved through binding arbitration in accordance with the rules of Court of Arbitration by a single arbitrator appointed in accordance with such rules.\n\n',
                  style: TextStyle(fontSize: 16.sp),
                ),
                TextSpan(
                  text: '10. Severability and Waiver\n',
                  style:
                      TextStyle(fontWeight: FontWeight.bold, fontSize: 18.sp),
                ),
                TextSpan(
                  text:
                      'If any provision of these Terms is found to be invalid or unenforceable, that provision shall be deemed severable and shall not affect the validity or enforceability of the remaining provisions. The failure to enforce any right or provision of these Terms shall not constitute a waiver of such right or provision.\n\n',
                  style: TextStyle(fontSize: 16.sp),
                ),
                TextSpan(
                  text: '11. Entire Agreement\n',
                  style:
                      TextStyle(fontWeight: FontWeight.bold, fontSize: 18.sp),
                ),
                TextSpan(
                  text:
                      'These Terms constitute the entire agreement between you and ARKSoft Inc. regarding the use of the App and supersede any prior or contemporaneous agreements, communications, and proposals, whether oral or written.\n\n',
                  style: TextStyle(fontSize: 16.sp),
                ),
                TextSpan(
                  text: '12. Contact Us\n',
                  style:
                      TextStyle(fontWeight: FontWeight.bold, fontSize: 18.sp),
                ),
                TextSpan(
                  text:
                      'If you have any questions or concerns regarding these Terms or the App, please contact us at richardkns7@gmail.com.\n\n',
                  style: TextStyle(fontSize: 16.sp),
                ),
                TextSpan(
                  text:
                      'By using the INFOCTESS Koneqt mobile application, you acknowledge that you have read, understood, and agree to be bound by these Terms and Conditions.',
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
