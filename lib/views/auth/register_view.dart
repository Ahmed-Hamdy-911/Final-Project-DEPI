import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bs_rashhuli/constants/colors.dart';
import 'package:bs_rashhuli/cubits/auth_cubit/auth_cubit.dart';
import 'package:bs_rashhuli/cubits/auth_cubit/auth_states.dart';

import '../../widgets/custom_loading_widget.dart';
import '../../widgets/custom_text.dart';
import '../../widgets/custom_text_form.dart';
import '../../widgets/cutom_material_button.dart';

class ReqisterView extends StatefulWidget {
  const ReqisterView({super.key});

  @override
  State<ReqisterView> createState() => _ReqisterViewState();
}

class _ReqisterViewState extends State<ReqisterView> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  @override
  void initState() {
    super.initState();
    BlocProvider.of<AuthCubit>(context).resetVisibility();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthStates>(
      builder: (context, state) {
        var authCubit = BlocProvider.of<AuthCubit>(context);
        return Scaffold(
          body: SingleChildScrollView(
            child: Stack(
              children: [
                Container(
                  color: kMainColor,
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  alignment: Alignment.topCenter,
                  child: Stack(
                    children: [
                      Image.asset(
                        height: MediaQuery.of(context).size.height * 0.7,
                        width: MediaQuery.of(context).size.width,
                        "assets/images/splash_image.png",
                        fit: BoxFit.contain,
                      ),
                      Positioned(
                          top: 25,
                          right: 15,
                          child: IconButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              icon: const Icon(
                                Icons.arrow_back,
                                color: Colors.white,
                                size: 32,
                              ))),
                      Positioned(
                          top: MediaQuery.of(context).size.height * 0.17,
                          right: MediaQuery.of(context).size.width * 0.06,
                          child: const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomText(
                                text: "مرحبا👋",
                                textColor: Colors.white,
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                              ),
                              CustomText(
                                text: "دعنا نبدأ مع BNS Rashhuli",
                                textColor: Colors.white70,
                                fontSize: 20,
                              ),
                            ],
                          ))
                    ],
                  ),
                ),
                Positioned(
                  bottom: 0,
                  child: Container(
                    color: Colors.white,
                    padding: const EdgeInsets.all(12),
                    height: MediaQuery.of(context).size.height * 0.7,
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      // mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.07,
                        ),
                        Form(
                          key: _formKey,
                          child: Column(children: [
                            CustomTextFormField(
                              labelText: "الاسم",
                              hintText: "أدخل اسمك",
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                    RegExp(r'^[a-zA-Z ]+$')),
                                LengthLimitingTextInputFormatter(25)
                              ],
                              keyboardType: TextInputType.name,
                              prefixIcon: const Icon(Icons.person_2),
                              controller: _nameController,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "هذه الخانة مطلوبه";
                                } else if (value.length < 3) {
                                  return "الاسم يجب ان يكون اكبر من 3 حروف";
                                }
                                return null;
                              },
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            CustomTextFormField(
                              labelText: "البريد الإلكتروني",
                              hintText: "أدخل بريدك الإلكتروني",
                              inputFormatters: [
                                FilteringTextInputFormatter.deny(" "),
                              ],
                              keyboardType: TextInputType.emailAddress,
                              prefixIcon: const Icon(Icons.email_rounded),
                              controller: _emailController,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "هذه الخانة مطلوبه";
                                } else if (!RegExp(
                                        r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')
                                    .hasMatch(value)) {
                                  return "البريد الإلكتروني غير صالح";
                                }
                                return null;
                              },
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            CustomTextFormField(
                              labelText: "كلمة المرور",
                              hintText: "أدخل كلمة المرور الخاصة بك",
                              keyboardType: TextInputType.text,
                              controller: _passwordController,
                              obscureText: authCubit.showPassword,
                              // obscureText: true,
                              prefixIcon: const Icon(Icons.lock),
                              suffixIcon: IconButton(
                                  onPressed: () {
                                    authCubit.changeVisibilityPassword();
                                  },
                                  icon: Icon(
                                    authCubit.showPassword
                                        ? Icons.visibility_off_outlined
                                        : Icons.visibility_outlined,
                                  )),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "هذه الخانة مطلوبه";
                                }
                                return null;
                              },
                            ),
                          ]),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        CustomMaterialButton(
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              await authCubit.signUpSubmit(
                                context,
                                name: _nameController.text,
                                email: _emailController.text,
                                password: _passwordController.text,
                              );
                            }
                          },
                          minWidth: MediaQuery.of(context).size.width,
                          widget: const CustomText(
                            text: "انشاء حساب",
                            textColor: Colors.white,
                            fontSize: 17,
                          ),
                          color: kMainColor,
                        ),
                      ],
                    ),
                  ),
                ),
                if (state is LoadingAuthState) const CustomLoadingWidget()
              ],
            ),
          ),
        );
      },
    );
  }
}
