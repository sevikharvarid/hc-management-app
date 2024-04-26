import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hc_management_app/config/routes.dart';
import 'package:hc_management_app/features/profile/profile_spg/cubit/profile_spg_cubit.dart';
import 'package:hc_management_app/shared/utils/constant/app_colors.dart';

class ProfileSPGPage extends StatefulWidget {
  const ProfileSPGPage({super.key});

  @override
  State<ProfileSPGPage> createState() => _ProfileSPGPageState();
}

class _ProfileSPGPageState extends State<ProfileSPGPage> {
  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ProfileSPGCubit>();
    return BlocConsumer<ProfileSPGCubit, ProfileSPGState>(
      listener: (context, state) {
        if (state is ProfileSPGLogout) {
          Navigator.pushNamedAndRemoveUntil(
              context, Routes.landing, (route) => false);
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: AppColors.primary,
            title: Text(
              "Profile",
              style: GoogleFonts.nunito(
                fontWeight: FontWeight.w400,
                fontSize: 20,
              ),
            ),
          ),
          body: Container(
            color: Colors.white54,
            child: Column(
              children: [
                const SizedBox(
                  height: 25,
                ),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      maxRadius: 65,
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Vera Angelina",
                      style:
                          TextStyle(fontWeight: FontWeight.w900, fontSize: 26),
                    )
                  ],
                ),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [Text("SPG 1")],
                ),
                const SizedBox(
                  height: 35,
                ),
                Expanded(
                    child: ListView(
                  children: [
                    Card(
                      color: Colors.white70,
                      margin: const EdgeInsets.only(
                          left: 35, right: 35, bottom: 10),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30)),
                      child: const ListTile(
                        leading: Icon(Icons.person, color: Colors.black54),
                        title: Text(
                          '33111002921112',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Card(
                      color: Colors.white70,
                      margin: const EdgeInsets.only(
                          left: 35, right: 35, bottom: 10),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30)),
                      child: const ListTile(
                        leading: Icon(
                          Icons.email,
                          color: Colors.black54,
                        ),
                        title: Text(
                          'thomas@gmail.com',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Card(
                      color: Colors.white70,
                      margin: const EdgeInsets.only(
                          left: 35, right: 35, bottom: 10),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30)),
                      child: const ListTile(
                        leading: Icon(
                          Icons.edit,
                          color: Colors.black54,
                        ),
                        title: Text(
                          'Edit Profile',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        trailing: Icon(
                          Icons.arrow_forward_ios_outlined,
                          color: Colors.black54,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    GestureDetector(
                      onTap: () => cubit.logout(),
                      child: Card(
                        color: Colors.white70,
                        margin: const EdgeInsets.only(
                            left: 35, right: 35, bottom: 10),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30)),
                        child: const ListTile(
                          leading: Icon(
                            Icons.logout,
                            color: Colors.black54,
                          ),
                          title: Text(
                            'Logout',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          trailing: Icon(Icons.arrow_forward_ios_outlined),
                        ),
                      ),
                    )
                  ],
                ))
              ],
            ),
          ),
        );
      },
    );
  }
}