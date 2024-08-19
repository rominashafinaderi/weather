// // pageView Indicator
// Center(
// child: SmoothPageIndicator(
// controller: _pageController,
// // PageController
// count: 2,
// effect: const ExpandingDotsEffect(
// dotWidth: 10,
// dotHeight: 10,
// spacing: 5,
// activeDotColor: Colors.white,
// ),
// // your preferred effect
// onDotClicked: (index) => _pageController.animateToPage(
// index,
// duration: const Duration(microseconds: 500),
// curve: Curves.bounceOut,
// ),
// ),
// ),
//
// /// divider
// Padding(
// padding: const EdgeInsets.only(top: 30),
// child: Container(
// color: Colors.white24,
// height: 2,
// width: double.infinity,
// ),
// ),
//
// /// forecast weather 7 days
// Padding(
// padding: const EdgeInsets.only(top: 15),
// child: SizedBox(
// width: double.infinity,
// height: 100,
// child: Padding(
// padding: const EdgeInsets.only(left: 10.0),
// child: Center(
// child: BlocBuilder<HomeBloc, HomeState>(
// builder: (BuildContext context, state) {
// /// show Loading State for Fw
// if (state.fwStatus is FwLoading) {
// return const DotLoadingWidget();
// }
//
// /// show Completed State for Fw
// if (state.fwStatus is FwCompleted) {
// /// casting
// final FwCompleted fwCompleted =
// state.fwStatus as FwCompleted;
// final ForecastDaysEntity forecastDaysEntity =
// fwCompleted.forecastDaysEntity;
// final List<Daily> mainDaily =
// forecastDaysEntity.daily!;
//
// return ListView.builder(
// shrinkWrap: true,
// scrollDirection: Axis.horizontal,
// itemCount: 8,
// itemBuilder: (
// BuildContext context,
// int index,
// ) {
// return DaysWeatherView(
// daily: mainDaily[index],
// );
// },
// );
// }
//
// /// show Error State for Fw
// if (state.fwStatus is FwError) {
// final FwError fwError =
// state.fwStatus as FwError;
// return Center(
// child: Text(fwError.message!),
// );
// }
//
// /// show Default State for Fw
// return Container();
// },
// ),
// ),
// ),
// ),
// ),
//
// /// divider
// Padding(
// padding: const EdgeInsets.only(top: 15),
// child: Container(
// color: Colors.white24,
// height: 2,
// width: double.infinity,
// ),
// ),
//
// SizedBox(
// height: 30,
// ),