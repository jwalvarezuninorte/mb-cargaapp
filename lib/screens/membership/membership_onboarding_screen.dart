import 'package:animate_do/animate_do.dart';
import 'package:cargaapp_mobile/theme/app_theme.dart';
import 'package:cargaapp_mobile/widgets/common/common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

final _onboardingContent = [
  {
    'title_1': 'Encuentra a tu próximo ',
    'title_2': 'socio',
    'title_3': '.',
    'image': 'assets/images/support_onboarding_1.jpg',
  },
  {
    'title_1': 'Todo desde ',
    'title_2': 'la palma ',
    'title_3': 'de tus manos.',
    'image': 'assets/images/support_onboarding_2.jpg',
  },
  {
    'title_1': 'Accede ahora por solo ',
    'title_2': '1900 ARS/mes',
    'title_3': '.',
    'image': 'assets/images/support_onboarding_3.jpg',
  },
];

class MembershipOnboardingScreen extends StatelessWidget {
  const MembershipOnboardingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final PageController _pageController = PageController(initialPage: 2);
    final List<Widget> _pages = List.generate(
      _onboardingContent.length,
      (index) => OnboardingScreenTemplate(
        pageController: _pageController,
        title: [
          _onboardingContent[index]['title_1']!,
          _onboardingContent[index]['title_2']!,
          _onboardingContent[index]['title_3']!,
        ],
        image: _onboardingContent[index]['image']!,
        showButton: index == _onboardingContent.length - 1,
      ),
    );
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(
            Icons.close,
            color: Colors.black.withOpacity(0.8),
          ),
        ),
      ),
      body: PageView(
        controller: _pageController,
        children: _pages,
      ),
      bottomNavigationBar: Container(
        height: 60,
        padding: const EdgeInsets.only(bottom: AppTheme.padding * 2),
        child: Center(
          child: SmoothPageIndicator(
            controller: _pageController,
            count: 3,
            effect: ExpandingDotsEffect(
              dotColor: AppTheme.dark.withOpacity(0.2),
              activeDotColor: AppTheme.primary,
              dotHeight: 12,
              dotWidth: 12,
              expansionFactor: 4,
            ),
          ),
        ),
      ),
    );
  }
}

class OnboardingScreenTemplate extends StatelessWidget {
  const OnboardingScreenTemplate({
    required this.pageController,
    required this.title,
    required this.image,
    this.showButton = false,
    super.key,
  });

  final PageController pageController;
  final bool showButton;

  final List<String> title;
  final String image;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppTheme.padding),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // const SizedBox(height: AppTheme.padding),
          FadeInUp(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(AppTheme.defaultRadius * 3),
              child: Image.asset(
                image,
                height: MediaQuery.of(context).size.height *
                    (showButton ? 0.5 : 0.6),
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Spacer(),
          FadeIn(
            delay: const Duration(milliseconds: 300),
            child: RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                text: title[0],
                style: AppTheme.lightTheme.textTheme.displayLarge!.copyWith(
                  color: Colors.black.withOpacity(0.8),
                  fontWeight: FontWeight.w700,
                  fontSize: 30,
                ),
                children: [
                  TextSpan(
                    text: title[1],
                    style: TextStyle(
                      color: AppTheme.primary,
                    ),
                  ),
                  TextSpan(
                    text: title[2],
                    style: TextStyle(
                      color: Colors.black.withOpacity(0.8),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppTheme.padding),
          if (showButton)
            ElevatedButton(
              onPressed: () => _showPayMembershipOptions(context),
              child: Text('Obtener membresía'),
            ),
          const SizedBox(height: AppTheme.padding),
        ],
      ),
    );
  }
}

List<Map<String, dynamic>> _paymentMethods = [
  {
    'id': 'pm_mercado_pago',
    'name': 'Mercado Pago',
    'asset_path': 'assets/icons/pm_mercadopago_logo.svg',
  },
  {
    'id': 'pm_credit_cards',
    'name': 'Tarjeta de crédito',
    'asset_path': 'assets/icons/pm_credit_cards_logo.svg',
  },
];

Future<void> _showPayMembershipOptions(BuildContext context) async {
  return showModalBottomSheet(
    context: context,
    builder: (context) {
      return Container(
        height: 330,
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.symmetric(horizontal: AppTheme.padding),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(AppTheme.defaultRadius * 3),
            topRight: Radius.circular(AppTheme.defaultRadius * 3),
          ),
        ),
        child: Column(
          children: [
            DragIndicator(),
            SizedBox(height: AppTheme.padding),
            SectionHeader(
              title: 'Escoge un método de pago',
              hasPadding: false,
            ),
            SizedBox(height: AppTheme.padding),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ...List.generate(
                  _paymentMethods.length,
                  (index) => InkWell(
                    borderRadius: BorderRadius.circular(AppTheme.defaultRadius),
                    onTap: () => Navigator.of(context).pushNamed(
                      '/pay_membership',
                    ),
                    child: Container(
                      height: 160,
                      width: MediaQuery.of(context).size.width / 2.4,
                      padding: const EdgeInsets.all(AppTheme.padding / 2),
                      decoration: BoxDecoration(
                        color: AppTheme.dark.withOpacity(0.04),
                        borderRadius: BorderRadius.circular(
                          AppTheme.defaultRadius,
                        ),
                        border: Border.all(
                          color: AppTheme.dark.withOpacity(0.04),
                          width: 3,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                            _paymentMethods[index]['asset_path'],
                            width: 80,
                          ),
                          SizedBox(height: AppTheme.padding),
                          Text(
                            _paymentMethods[index]['name'],
                            style: AppTheme.lightTheme.textTheme.displaySmall,
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
            SizedBox(height: AppTheme.padding * 2),
          ],
        ),
      );
    },
  );
}
