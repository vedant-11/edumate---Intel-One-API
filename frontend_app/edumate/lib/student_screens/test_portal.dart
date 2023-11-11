import 'package:edumate/utils/app_color.dart';
import 'package:edumate/widgets/active_test_card.dart';
import 'package:edumate/widgets/test_cards.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TestPortal extends StatefulWidget {
  static const String name = "testPortal";
  const TestPortal({Key? key}) : super(key: key);

  @override
  State<TestPortal> createState() => _TestPortalState();
}

class _TestPortalState extends State<TestPortal> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                width: double.infinity,
                color: AppColors.primaryColor,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Active Test",
                      style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 16),
                    ActiveTestCard(
                      courseCode: "Physics (PY123978)",
                      chapter: "Ray Optics",
                      date: "24th Aug 2022",
                      time: "9:30 AM",
                      maxMarks: 75,
                      faculty: "Mr. Vedant Singh",
                      width: MediaQuery.of(context).size.width * 0.9,
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    Text(
                      "Upcoming Tests",
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        color: Color(0xff555555),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Row(
                          children: [
                            TestCards(
                              courseCode: "English (ENG3978)",
                              chapter: "Literature",
                              date: "30th Aug 2022",
                              time: "9:30 AM",
                              maxMarks: 75,
                              faculty: "Mr. Viraj",
                            ),
                            const SizedBox(width: 16),
                            TestCards(
                              courseCode: "English (ENG3978)",
                              chapter: "Literature",
                              date: "30th Aug 2022",
                              time: "9:30 AM",
                              maxMarks: 75,
                              faculty: "Mr. Viraj",
                            ),
                            const SizedBox(width: 16),
                            TestCards(
                              courseCode: "English (ENG3978)",
                              chapter: "Literature",
                              date: "30th Aug 2022",
                              time: "9:30 AM",
                              maxMarks: 75,
                              faculty: "Mr. Viraj",
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        border: Border.all(
                          width: 2,
                          color: AppColors.primaryColor,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Results & Previous Tests",
                            style: TextStyle(
                              color: AppColors.primaryColor,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Container(
                            // height: 30,
                            // width: 30,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(27),
                                color: AppColors.primaryColor.withOpacity(0.1)),
                            child: const Center(
                              child: Icon(
                                Icons.navigate_next_rounded,
                                color: AppColors.primaryColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 50),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
