import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:infoware/presentation/screens/recipes.dart';

import '../utils/constants.dart';

class CustomStepper extends StatefulWidget {
  const CustomStepper({super.key});

  @override
  State<CustomStepper> createState() => _CustomStepperState();
}

class _CustomStepperState extends State<CustomStepper> {
  final nameController = TextEditingController();
  final feetController = TextEditingController();
  final inchesController = TextEditingController();
  final weightController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _nameKey = GlobalKey<FormState>();
  final _heightKey = GlobalKey<FormState>();
  final _weightKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();
  int _heightInCm = 0;
  int initialAge = 16;
  int currentStep = 0;
  String selectedGender = '';
  String selectedGoal = '';
  String selectedLevel = '';
  String selectedLifestyle = '';
  bool processStarted = false;
  late int _age;
  void Function(int changedAge) onAgeChanged = (changedAge) {};

  @override
  void initState() {
    super.initState();
    _age = initialAge;
  }

  @override
  void dispose() {
    feetController.dispose();
    inchesController.dispose();
    weightController.dispose();
    _email.dispose();
    _password.dispose();

    super.dispose();
  }

  final _pageController = PageController(initialPage: 0);
  @override
  Widget build(BuildContext context) {
    final List<Widget> ageItems = [];
    for (int i = 1; i <= 100; i++) {
      ageItems.add(
        SizedBox(
          height: 48,
          child: Center(
            child: Text(
              "$i",
              style: TextStyle(
                color: Colors.grey.shade700,
                fontSize: 24,
                fontFamily: "Poppins",
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      );
    }
    List stepTitles = [
      Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const TitleWidget(title: "What's your\ngender?"),
          Column(
            children: [
              InkWell(
                borderRadius: BorderRadius.circular(15),
                onTap: () {
                  setState(() {
                    selectedGender = 'Male';
                  });
                },
                child: AboutYouOne(
                  compareWith: selectedGender,
                  title: 'Male',
                  leading: '👨   ',
                  trailing: '  ♂️',
                  cardShadow:
                      selectedGender != 'Male' ? null : kElevationToShadow[3],
                ),
              ),
              const SizedBox(height: 20.0),
              InkWell(
                borderRadius: BorderRadius.circular(15),
                onTap: () {
                  setState(() {
                    selectedGender = 'Female';
                  });
                },
                child: AboutYouOne(
                  compareWith: selectedGender,
                  title: 'Female',
                  leading: '👩   ',
                  trailing: '  ♀️',
                  cardShadow:
                      selectedGender != 'Female' ? null : kElevationToShadow[3],
                ),
              ),
            ],
          ),
        ],
      ),
      Form(
        key: _nameKey,
        child: Column(
          children: [
            const TitleWidget(title: "What's your name?"),
            const SizedBox(height: 50),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: TextFormField(
                cursorHeight: 30,
                textAlign: TextAlign.center,
                textInputAction: TextInputAction.next,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'This is a required field';
                  } else if (value.characters.length < 4) {
                    return 'Name must have atleast 4 characters.';
                  }
                  return null;
                },
                controller: nameController,
              ),
            ),
          ],
        ),
      ),
      Column(
        children: [
          const TitleWidget(title: "What's your age?"),
          const SizedBox(height: 50),
          Container(
            height: 160,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: CupertinoContextMenu.kEndBoxShadow),
            child: CupertinoPicker(
              itemExtent: 48,
              onSelectedItemChanged: (int index) {
                setState(() {
                  _age = index + 1;
                });
                onAgeChanged(_age);
              },
              scrollController: FixedExtentScrollController(
                initialItem: _age - 1,
              )..animateToItem(
                  (100 ~/ 2) + 1,
                  duration: const Duration(milliseconds: 600),
                  curve: Curves.linearToEaseOut,
                ),
              backgroundColor: Colors.transparent,
              useMagnifier: true,
              magnification: 1.25,
              selectionOverlay: Container(
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.2),
                ),
              ),
              children: ageItems,
            ),
          ),
        ],
      ),
      Column(
        children: [
          const Text(
            "That's all we wanted to know, now let's get you registered!",
            textAlign: TextAlign.left,
            style: h2black,
          ),
          const SizedBox(height: 20),
          Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 15),
                TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  textCapitalization: TextCapitalization.words,
                  keyboardType: TextInputType.emailAddress,
                  controller: _email,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'This is a required field';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 20),
                    enabledBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(15),
                      ),
                      borderSide: BorderSide(width: 1, color: Colors.black45),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    labelStyle: hNormal,
                    label: const Text("Enter Your City"),
                  ),
                ),
                const SizedBox(height: 15),
                TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  textCapitalization: TextCapitalization.words,
                  keyboardType: TextInputType.visiblePassword,
                  controller: _password,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'This is a required field';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 20),
                    enabledBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(15),
                      ),
                      borderSide: BorderSide(width: 1, color: Colors.black45),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    labelStyle: hNormal,
                    label: const Text("Enter Your State"),
                  ),
                ),
                const SizedBox(height: 15),
                TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  textCapitalization: TextCapitalization.words,
                  keyboardType: TextInputType.emailAddress,
                  controller: _email,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'This is a required field';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 20),
                    enabledBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(15),
                      ),
                      borderSide: BorderSide(width: 1, color: Colors.black45),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    labelStyle: hNormal,
                    label: const Text("Enter Your Email Address"),
                  ),
                ),
                const SizedBox(height: 15),
                TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  textCapitalization: TextCapitalization.words,
                  keyboardType: TextInputType.visiblePassword,
                  controller: _password,
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'This is a required field';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 20),
                    enabledBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(15),
                      ),
                      borderSide: BorderSide(width: 1, color: Colors.black45),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    labelStyle: hNormal,
                    label: const Text("Create New Password"),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ];
    animateToNext() {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 800),
        curve: Curves.fastOutSlowIn,
      );
    }

    animateToPrevious() {
      FocusScope.of(context).unfocus();
      _pageController.previousPage(
        duration: const Duration(milliseconds: 800),
        curve: Curves.fastOutSlowIn,
      );
    }

    nextStep() {
      if (currentStep == 0) {
        if (selectedGender != '') {
          setState(() {
            currentStep++;
          });
          animateToNext();
        }
      } else if (currentStep == 1) {
        if (_nameKey.currentState!.validate()) {
          setState(() {
            currentStep++;
          });
          FocusScope.of(context).nextFocus();
          animateToNext();
        }
      } else if (currentStep == 2) {
        if (_age >= 12) {
          setState(() {
            currentStep++;
          });
          animateToNext();
        }
      }
    }

    return Theme(
      data: ThemeData(primarySwatch: Colors.green),
      child: Scaffold(
        backgroundColor: bgcolor,
        body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  IconButton(
                    splashRadius: 25,
                    onPressed: () {
                      if (currentStep > 0) {
                        setState(() {
                          currentStep--;
                        });
                        animateToPrevious();
                      }
                      null;
                    },
                    icon: const Icon(
                      Icons.arrow_back_ios_new_rounded,
                      color: color,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 5),
                  Expanded(
                    child: LinearProgressIndicator(
                      value: (currentStep + 1) / stepTitles.length,
                      backgroundColor: Colors.grey.shade400,
                      valueColor: const AlwaysStoppedAnimation<Color>(
                        Colors.green,
                      ),
                    ),
                  ),
                  const SizedBox(width: 5),
                  IconButton(
                    splashRadius: 25,
                    onPressed: () {
                      Navigator.push(context,
                          CupertinoPageRoute(builder: (context) => Meals()));
                    },
                    icon: const Icon(
                      Icons.close_rounded,
                      color: color,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Expanded(
                child: PageView(
                  controller: _pageController,
                  physics: const NeverScrollableScrollPhysics(),
                  children: stepTitles
                      .map((step) => Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Center(child: step),
                          ))
                      .toList(),
                ),
              ),
              const SizedBox(height: 35),
              currentStep == stepTitles.length - 1
                  ? InkWell(
                      borderRadius: BorderRadius.circular(40),
                      onTap: () {
                        if (_formKey.currentState!.validate()) {
                          setState(() {
                            processStarted = true;
                          });
                          Navigator.pushReplacement(
                            context,
                            CupertinoPageRoute(
                              builder: (context) => Meals(),
                            ),
                          );
                        } else {}
                      },
                      child: Ink(
                        height: 50,
                        width: MediaQuery.of(context).size.width - 80,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(40),
                            color: Colors.green[600],
                            boxShadow: kElevationToShadow[3]),
                        child: Center(
                          child: processStarted
                              ? const SizedBox(
                                  height: 50,
                                  width: 28,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 4,
                                    color: bgcolor,
                                  ),
                                )
                              : const Text(
                                  "Sign Up",
                                  textAlign: TextAlign.center,
                                  style: h2white,
                                ),
                        ),
                      ),
                    )
                  : InkWell(
                      borderRadius: BorderRadius.circular(40),
                      onTap: nextStep,
                      child: Ink(
                        width: MediaQuery.of(context).size.width - 80,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(40),
                            color: Colors.green[500],
                            boxShadow: kElevationToShadow[3]),
                        child: const Text(
                          "Continue",
                          textAlign: TextAlign.center,
                          style: h2white,
                        ),
                      ),
                    ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }

  void _convertHeight() {
    int feet = int.tryParse(feetController.text) ?? 0;
    int inches = int.tryParse(inchesController.text) ?? 0;
    double totalInches = ((feet * 12) + inches).toDouble();
    double heightInCm = totalInches * 2.54;
    setState(() {
      _heightInCm = heightInCm.round();
    });
  }
}

class TitleWidget extends StatelessWidget {
  const TitleWidget({
    super.key,
    required this.title,
  });
  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      textAlign: TextAlign.center,
      style: heading,
    );
  }
}

class LifestyleWidget extends StatelessWidget {
  final String title;
  final String compareWith;
  final dynamic cardShadow;
  const LifestyleWidget({
    super.key,
    required this.title,
    required this.compareWith,
    required this.cardShadow,
  });

  @override
  Widget build(BuildContext context) {
    return Ink(
      height: 120,
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      decoration: BoxDecoration(
          color: bgcolor,
          border: compareWith == title.split(':').first
              ? Border.all(color: Colors.green)
              : Border.all(color: Colors.grey.shade400),
          borderRadius: BorderRadius.circular(15),
          boxShadow: cardShadow),
      child: Text(
        title,
        style: hNormal,
      ),
    );
  }
}

class AboutYouOne extends StatelessWidget {
  const AboutYouOne({
    super.key,
    required this.compareWith,
    required this.title,
    this.leading,
    this.trailing,
    this.titleStyle = h3black,
    required this.cardShadow,
  });

  final String title;
  final String compareWith;
  final dynamic titleStyle;
  final String? leading;
  final String? trailing;
  final dynamic cardShadow;

  @override
  Widget build(BuildContext context) {
    return Ink(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: bgcolor,
        border: compareWith == title
            ? Border.all(color: Colors.green)
            : Border.all(color: Colors.grey.shade400),
        boxShadow: cardShadow,
        borderRadius: BorderRadius.circular(15),
      ),
      height: 80,
      width: MediaQuery.of(context).size.width,
      child: Align(
        alignment: Alignment.centerLeft,
        child: Row(
          children: [
            Text(
              leading.toString(),
              style: h3black,
            ),
            Text(
              title,
              style: titleStyle,
            ),
            Text(
              trailing.toString(),
              style: const TextStyle(fontSize: 24),
            ),
          ],
        ),
      ),
    );
  }
}

class AboutYouTwo extends StatelessWidget {
  final String emoji;
  final String title;
  final String subtitle;
  final dynamic compareWith;
  final dynamic cardShadow;
  const AboutYouTwo({
    super.key,
    required this.emoji,
    required this.title,
    required this.subtitle,
    required this.compareWith,
    required this.cardShadow,
  });

  @override
  Widget build(BuildContext context) {
    return Ink(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: bgcolor,
        border: compareWith == title
            ? Border.all(color: Colors.green)
            : Border.all(color: Colors.grey.shade400),
        boxShadow: cardShadow,
        borderRadius: BorderRadius.circular(15),
      ),
      height: 80,
      width: MediaQuery.of(context).size.width,
      child: Row(
        children: [
          Text(
            emoji,
            style: h3black,
          ),
          const SizedBox(width: 10),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: h3black,
              ),
              Text(
                subtitle,
                style: hNormal,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
