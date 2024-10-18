import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bs_rashhuli/constants/colors.dart';
import 'package:bs_rashhuli/cubits/auth_cubit/auth_cubit.dart';
import 'package:bs_rashhuli/cubits/auth_cubit/auth_states.dart';
import '../../constants/constants.dart';
import '../../helper/helper.dart';
import '../../widgets/custom_app_logo.dart';
import '../../widgets/custom_loading_widget.dart';
import '../../widgets/custom_text.dart';
import '../../widgets/custom_text_form.dart';
import '../../widgets/cutom_material_button.dart';
import 'register_view.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  // emailSave = CacheHelper.getData(key: "emailSave");
  // passwordSave = CacheHelper.getData(key: "passwordSave");
  @override
  void initState() {
    super.initState();
    BlocProvider.of<AuthCubit>(context).resetVisibility();
    BlocProvider.of<AuthCubit>(context).loadRememberMe();
    if (rememberMeSave != null && rememberMeSave == true) {
      setState(() {
        _emailController.text = emailSave ?? '';
        _passwordController.text = passwordSave ?? '';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthStates>(
      builder: (context, state) {
        var authCubit = BlocProvider.of<AuthCubit>(context);
        return Scaffold(
          backgroundColor: Colors.white,
          body: Stack(
            children: [
              Center(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const AppLogoWithName(),
                        const CustomText(
                          text: "دعنا نبدأ مع BNS Rashhuli",
                          fontSize: 16,
                          textColor: Colors.grey,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Form(
                          key: _formKey,
                          child: Column(children: [
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
                              height: 15,
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Checkbox(
                                  value: rememberMeSave ?? authCubit.rememberMe,
                                  checkColor: Colors.white,
                                  side: const BorderSide(color: Colors.grey),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5)),
                                  onChanged: (value) {
                                    authCubit.changeRememberMe();
                                    authCubit.rememberMeMethod(
                                      rememberMe: authCubit.rememberMe,
                                      email: _emailController.text,
                                      password: _passwordController.text,
                                    );
                                  },
                                ),
                                const CustomText(
                                  fontSize: 14,
                                  text: "تذكرني",
                                  textColor: Colors.black,
                                ),
                              ],
                            ),
                            TextButton(
                                onPressed: () async {
                                  await authCubit.passwordReset(context,
                                      email: _emailController.text);
                                  // CacheHelper.clearData();
                                },
                                child: const CustomText(
                                  text: "هل نسيت كلمة المرور",
                                  fontSize: 13,
                                  textColor: Color(0xff326BDF),
                                )),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const CustomText(
                                text: "ليس لديك حساب؟", fontSize: 15),
                            InkWell(
                                onTap: () {
                                  naviPush(context,
                                      widgetName: const ReqisterView());
                                },
                                child: const CustomText(
                                  text: "إنشاء حساب",
                                  textColor: Color(0xff326BDF),
                                  fontSize: 14,
                                )),
                          ],
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        CustomMaterialButton(
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              await authCubit.submitLogin(context,
                                  email: _emailController.text,
                                  password: _passwordController.text);
                            }
                          },
                          minWidth: MediaQuery.of(context).size.width,
                          widget: const CustomText(
                            text: "تسجيل الدخول",
                            textColor: Colors.white,
                            fontSize: 17,
                          ),
                          color: kMainColor,
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Row(
                          children: [
                            Expanded(
                                child: Divider(
                              color: Colors.grey.shade300,
                              endIndent: 20,
                              indent: 10,
                            )),
                            const CustomText(
                              text: "أو",
                              textColor: Colors.black,
                              fontSize: 13,
                            ),
                            Expanded(
                                child: Divider(
                              color: Colors.grey.shade300,
                              indent: 20,
                              endIndent: 10,
                            )),
                          ],
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        OutlinedButton(
                          onPressed: () async {
                            await authCubit.signInWithGoogle(context);
                          },
                          style: ButtonStyle(
                            padding: const WidgetStatePropertyAll(
                                EdgeInsets.symmetric(vertical: 14)),
                            shape: WidgetStatePropertyAll(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            side: WidgetStatePropertyAll(
                              BorderSide(color: Colors.grey.withOpacity(0.5)),
                            ),
                          ),
                          child: state is LoadingGoogleAuthState
                              ? const Center(
                                  child: CircularProgressIndicator(),
                                )
                              : Row(
                                  children: [
                                    Expanded(
                                      child: Image.asset(
                                        'assets/icons/google_icon.png',
                                        width: 36,
                                        height: 36,
                                      ),
                                    ),
                                    const Expanded(
                                      flex: 4,
                                      child: CustomText(
                                        text: "تسجيل الدخول باستخدام حساب جوجل",
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              if (state is WaitingSignInGoogleState)
                const CustomLoadingWidget(),
              if (state is LoadingAuthState) const CustomLoadingWidget()
            ],
          ),
        );
      },
    );
  }
}
