import 'package:animate_do/animate_do.dart';
import 'package:cargaapp_mobile/backend/models/load.dart';
import 'package:cargaapp_mobile/backend/services/auth_service.dart';
import 'package:cargaapp_mobile/backend/services/load_service.dart';
import 'package:cargaapp_mobile/theme/app_theme.dart';
import 'package:cargaapp_mobile/utils/date.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';

class LoadGiverOffersScreen extends StatelessWidget {
  const LoadGiverOffersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          _HomeSliverAppBar(),
          SliverList(
            delegate: SliverChildListDelegate([OffersData()]),
          ),
        ],
      ),
    );
  }
}

class OffersData extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final LoadService loadService = Provider.of<LoadService>(context);

    return FadeInUp(
      duration: const Duration(milliseconds: 200),
      child: RefreshIndicator(
        onRefresh: () async {},
        child: FutureBuilder(
          future: loadService.getLoads({}),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final loads = snapshot.data ?? [];
              return ListView.builder(
                clipBehavior: Clip.none,
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                itemCount: loads.length,
                itemBuilder: (context, index) => OfertaCargaCard(
                  load: loads[index],
                ),
              );
            }

            return Center(
              child: Padding(
                padding: EdgeInsets.all(AppTheme.padding * 2),
                child: snapshot.connectionState == ConnectionState.waiting
                    ? CircularProgressIndicator()
                    : Text('No hay datos para mostrar'),
              ),
            );
          },
        ),
      ),
    );
  }
}

class OfertaCargaCard extends StatelessWidget {
  const OfertaCargaCard({super.key, required this.load});

  final LoadModel load;

  @override
  Widget build(BuildContext context) {
    final _authService = Provider.of<AuthService>(context);
    return Container(
      padding: EdgeInsets.all(AppTheme.padding),
      margin: EdgeInsets.all(AppTheme.padding / 2),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(AppTheme.defaultRadius / 2),
        border: Border.all(color: AppTheme.dark.withOpacity(0.4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ElevatedButton(
            style: AppTheme.lightTheme.elevatedButtonTheme.style!.copyWith(
              backgroundColor: MaterialStatePropertyAll(AppTheme.base),
              foregroundColor: MaterialStatePropertyAll(AppTheme.primary),
            ),
            onPressed: () {
              _authService.supabase.auth.signOut();
            },
            child: Text("Cerrar sesion"),
          ),
          //   card header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: 200,
                child: Text(
                  "${load.title} (${load.presentationType.name})",
                  style: AppTheme.lightTheme.textTheme.displaySmall,
                  maxLines: 2,
                ),
              ),
              Chip(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                    AppTheme.defaultRadius * 2,
                  ),
                ),
                // padding: EdgeInsets.symmetric(
                //   vertical: AppTheme.padding / 2,
                //   horizontal: AppTheme.padding / 2,
                // ),
                backgroundColor: AppTheme.dark.withOpacity(0.1),
                label: Text(
                  "${load.weight} Kg",
                  style: AppTheme.lightTheme.textTheme.displaySmall,
                ),
                // avatar: Icon(
                //   Iconsax.weight_15,
                //   color: AppTheme.dark,
                // ),
                labelPadding: EdgeInsets.all(2),
              )
            ],
          ),

          //   card caption
          Text(
            "Por ${load.userName} ~ ${load.createdAt.timeAgo()}",
            style: AppTheme.lightTheme.textTheme.bodySmall!.copyWith(
              color: Colors.grey[600]!.withOpacity(0.6),
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: AppTheme.padding / 4),
          Text(
            "Tipo de vehiculo: ${load.equipmentType.name}",
            style: AppTheme.lightTheme.textTheme.headlineMedium!.copyWith(
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: AppTheme.padding / 2),
          //   card date section
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Chip(
                  padding: EdgeInsets.symmetric(
                    vertical: AppTheme.padding / 2,
                    horizontal: AppTheme.padding / 2,
                  ),
                  backgroundColor: AppTheme.base.withOpacity(0.8),
                  label: Text(
                    load.loadingDate.readable(),
                    style:
                        AppTheme.lightTheme.textTheme.headlineMedium!.copyWith(
                      color: Colors.grey[600],
                    ),
                  ),
                ),
              ),
              Icon(
                Icons.arrow_right_rounded,
                size: 26,
                color: AppTheme.dark,
              ),
              Expanded(
                child: Chip(
                  padding: EdgeInsets.symmetric(
                    vertical: AppTheme.padding / 2,
                    horizontal: AppTheme.padding / 2,
                  ),
                  backgroundColor: AppTheme.base.withOpacity(0.8),
                  label: Text(
                    load.unloadingDate.readable(),
                    style:
                        AppTheme.lightTheme.textTheme.headlineMedium!.copyWith(
                      color: Colors.grey[600],
                    ),
                    overflow: TextOverflow.ellipsis,
                    softWrap: true,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: AppTheme.padding / 2),

          //   card button
          ElevatedButton(
            style: AppTheme.lightTheme.elevatedButtonTheme.style!.copyWith(
              backgroundColor: MaterialStatePropertyAll(AppTheme.base),
              foregroundColor: MaterialStatePropertyAll(AppTheme.primary),
            ),
            onPressed: () {
              Navigator.of(context).pushNamed(
                '/offer_detail',
                arguments: load,
              );
            },
            child: Text("asVer detalles"),
          )
        ],
      ),
    );
  }
}

class _HomeSliverAppBar extends StatelessWidget {
  const _HomeSliverAppBar();

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      backgroundColor: AppTheme.primary,
      expandedHeight: 80,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Equipos',
            style: AppTheme.lightTheme.textTheme.displayLarge!.copyWith(
              color: Colors.white,
            ),
          ),
          SizedBox(height: AppTheme.padding / 4),
          Text(
            "Ofertas de carga para hoy",
            style: AppTheme.lightTheme.textTheme.headlineMedium!.copyWith(
              color: Colors.white.withOpacity(0.4),
            ),
          ),
        ],
      ),
      centerTitle: false,
      bottom: PreferredSize(
        preferredSize: Size(10, AppTheme.padding / 2),
        child: Container(),
      ),
      actions: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: AppTheme.base.withOpacity(0.1),
            borderRadius: BorderRadius.circular(
              AppTheme.defaultRadius * 2,
            ),
          ),
          child: IconButton(
            onPressed: () {
              Navigator.pushNamed(context, '/search');
            },
            icon: Icon(
              Iconsax.filter,
              color: AppTheme.base.withOpacity(1),
            ),
          ),
        ),
        SizedBox(width: AppTheme.padding / 2)
      ],
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: EdgeInsets.symmetric(vertical: AppTheme.padding),
      ),
    );
  }
}
