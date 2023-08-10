import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';

import 'views/bue_bus/b_choose_user_view.dart';
import 'views/bue_bus/cubits/b_get_driver_cubit/b_get_driver_cubit.dart';
import 'views/bue_bus/cubits/b_get_locations_cubit/b_get_locations_cubit.dart';
import 'views/bue_bus/cubits/b_get_student_info_cubit/b_get_student_info_cubit.dart';
import 'views/bue_bus/cubits/b_login_cubit/b_login_cubit.dart';
import 'views/bue_bus/cubits/b_register_cubit/b_register_cubit.dart';
import 'views/bue_bus/cubits/b_ride_cubit/b_ride_cubit.dart';
import 'views/bue_bus/driver/b_driver_bottom_nav.dart';
import 'views/bue_bus/driver/b_driver_login.dart';
import 'views/bue_bus/driver/b_driver_start_ride.dart';
import 'views/bue_bus/driver/services/b_notification_service.dart';
import 'views/bue_bus/student/b_student_bottom_nav.dart';
import 'views/bue_bus/student/b_student_edit_profile.dart';
import 'views/bue_bus/student/b_student_login.dart';
import 'views/bue_bus/student/b_student_register.dart';
import 'views/bue_bus/student/b_student_ride_info.dart';
import 'views/car_pooling/views/cp_choose_user_view.dart';
import 'views/car_pooling/views/cp_login_view.dart';
import 'views/car_pooling/views/cp_register_view.dart';
import 'views/car_pooling/views/cp_verification_view.dart';
import 'views/car_pooling/cubits/cp_get_locations_cubit/cp_get_locations_cubit.dart';
import 'views/car_pooling/cubits/cp_get_user_info_cubit/cp_get_user_info_cubit.dart';
import 'views/car_pooling/cubits/cp_login_cubit/cp_login_cubit.dart';
import 'views/car_pooling/cubits/cp_register_cubit/cp_register_cubit.dart';
import 'views/car_pooling/cubits/cp_ride_cubit/cp_ride_cubit.dart';
import 'views/car_pooling/driver/cp_driver_bottom_nav_bar.dart';
import 'views/car_pooling/driver/cp_driver_edit_profile.dart';
import 'views/car_pooling/driver/cp_driver_locations_view.dart';
import 'views/car_pooling/driver/cp_driver_profile_view.dart';
import 'views/car_pooling/driver/cp_driver_ride_info.dart';
import 'views/car_pooling/driver/cp_driver_start_ride_view.dart';
import 'views/car_pooling/driver/car_info_form_view.dart';
import 'views/car_pooling/passenger/cp_passenger_bottom_nav.dart';
import 'views/car_pooling/passenger/cp_passenger_choose_time.dart';
import 'views/car_pooling/passenger/cp_passenger_edit_profile.dart';
import 'views/car_pooling/passenger/cp_passenger_locations_view.dart';
import 'views/car_pooling/passenger/cp_passenger_profile_view.dart';
import 'views/car_pooling/passenger/cp_passenger_ride_info.dart';
import 'views/car_pooling/passenger/cp_passenger_ride_list.dart';
import 'views/choose_ride_view.dart';
import 'views/splash_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  LocalNotificationService.initialize();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
            create: (context) => CPRegisterCubit(FirebaseAuth.instance)),
        BlocProvider(create: (context) => CPLoginCubit(FirebaseAuth.instance)),
        BlocProvider(create: (context) => CpGetUserInfoCubit()),
        BlocProvider(create: (context) => CpRideCubit()),
        BlocProvider(create: (context) => CpGetLocationsCubit()),
        BlocProvider(create: (context) => BGetDriverCubit()),
        BlocProvider(
            create: (context) => BRegisterCubit(FirebaseAuth.instance)),
        BlocProvider(create: (context) => BLoginCubit(FirebaseAuth.instance)),
        BlocProvider(create: (context) => BGetStudentInfoCubit()),
        BlocProvider(create: (context) => BGetLocationsCubit()),
        BlocProvider(create: (context) => BRideCubit()),
      ],
      child: FocusScope(
        child: Sizer(
          builder: (context, orientation, deviceType) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'Flutter Demo',
              theme: ThemeData(
                primarySwatch: Colors.blue,
              ),
              home: const SplashView(),
              routes: {
                ChooseRideView.routeName: (context) => const ChooseRideView(),
                CPRegisterview.routeName: (context) => const CPRegisterview(),
                BChooseUserView.routeName: (context) => const BChooseUserView(),
                CPLoginView.routeName: (context) => const CPLoginView(),
                CPChooseUserView.routeName: (context) => const CPChooseUserView(),
                CarInfoFormView.routeName: (context) => const CarInfoFormView(),
                
                CPPassengerChooseTime.routeName: (context) =>
                    const CPPassengerChooseTime(),
                CpDriverBottomNavBar.routeName: (context) =>
                    const CpDriverBottomNavBar(),
                CpDriverProfileView.routeName: (context) =>
                    const CpDriverProfileView(), //
                CpEditDriverProfile.routeName: (context) =>
                    const CpEditDriverProfile(),
                CpPassengerBottomNav.routeName: (context) =>
                    const CpPassengerBottomNav(),
                CpPassengerProfile.routeName: (context) =>
                    const CpPassengerProfile(), //
                CpPassengerEditProfile.routeName: (context) =>
                    const CpPassengerEditProfile(),
               
                CpVerificationView.routeName: (context) =>
                    const CpVerificationView(),
                CpPassengerRideList.routeName: (context) =>
                    const CpPassengerRideList(),
                CpDriverLocationsView.routeName: (context) =>
                    const CpDriverLocationsView(),
                CpPassengerLocations.routeName: (context) =>
                    const CpPassengerLocations(),
                CpDriverStartRide.routeName: (context) =>
                    const CpDriverStartRide(),
                CpPassengerRideInfo.routeName: (context) =>
                    const CpPassengerRideInfo(),
                CpDriverRideInfo.routeName: (context) => const CpDriverRideInfo(),
                BDriverLogin.routeName: (context) => const BDriverLogin(),
                BStudentLogin.routeName: (context) => const BStudentLogin(),
                BStudentRegister.routeName: (context) => const BStudentRegister(),
                BStudentBottomNav.routeName: (context) =>
                    const BStudentBottomNav(),
                BDriverBottomNav.routeName: (context) => const BDriverBottomNav(),
                
                BStudentEditProfile.routeName: (context) =>
                    const BStudentEditProfile(),
               
                BDriverStartRide.routeName: (context) => const BDriverStartRide(),
                BStudentRideInfo.routeName: (context) => const BStudentRideInfo(),
               
              },
            );
          },
        ),
      ),
    );
  }
}
