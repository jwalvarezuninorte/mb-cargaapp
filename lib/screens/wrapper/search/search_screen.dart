import 'package:cargaapp_mobile/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:iconsax/iconsax.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen>
    with TickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppTheme.base,
        title: TextFormField(
          autofocus: true,
          onFieldSubmitted: (value) async {
            print("Buscar wee");
          },
          style: TextStyle(fontSize: 16),
          textInputAction: TextInputAction.search,
          decoration: InputDecoration(
            hintText: 'Buscar lugar, nombre o usuario',
            fillColor: Colors.grey.shade200,
            suffixIcon: IconButton(
              icon: Icon(
                FontAwesomeIcons.magnifyingGlass,
                size: 20,
                color: Colors.white70,
              ),
              style: IconButton.styleFrom(
                backgroundColor: AppTheme.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(AppTheme.defaultRadius),
                    topRight: Radius.circular(AppTheme.defaultRadius),
                  ),
                ),
                padding: EdgeInsets.symmetric(
                  horizontal: AppTheme.padding,
                  vertical: AppTheme.padding / 1.3,
                ),
              ),
              onPressed: () {
                //   TODO: implement on search action
              },
            ),
          ),
        ),
        leading: IconButton(onPressed: null, icon: Icon(Iconsax.filter)),
      ),
      body: SingleChildScrollView(
        physics: NeverScrollableScrollPhysics(),
        child: Column(
          children: [
            Container(
              height: 300,
              width: double.infinity,
              margin: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.red,
              ),
            ),
            SizedBox(height: AppTheme.padding),
          ],
        ),
      ),
    );
  }
}
