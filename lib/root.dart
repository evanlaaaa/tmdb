import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tmdb/bloc/root/root_cubit.dart';
import 'package:tmdb/screen/error_screen.dart';
import 'package:tmdb/screen/home_screen.dart';
import 'package:tmdb/screen/search_screen.dart';
import 'package:tmdb/widget/conditional.dart';

class RootView extends StatefulWidget {
  const RootView({super.key});

  @override
  State<RootView> createState() => _RootViewState();
}

class _RootViewState extends State<RootView> {

  int _selectedIndex = 0;
  final PageController _pageController = PageController(initialPage: 0);
  final List<Widget> _pages = const [
    HomeScreen(),
    SearchScreen()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (context) => RootCubit()..onGenreResourceRequested(),
        child: Center(
          child: BlocBuilder<RootCubit, RootState>(
            builder: (context, state) {
              return Conditional(
                condition: state.status.isSuccess || state.status.isFailure,
                child: (context) => PageView(
                  controller: _pageController,
                  physics: const NeverScrollableScrollPhysics(),
                  children: state.status.isFailure
                    ? [
                      ErrorScreen(onRefresh: () async {
                        context.read<RootCubit>().onGenreResourceRequested();
                      }),
                      ErrorScreen(onRefresh: () async {
                        context.read<RootCubit>().onGenreResourceRequested();
                      }),
                    ]
                    : _pages,
                ),
                fallback: (context) => const Center(child: CircularProgressIndicator())
              );
            },
          ),
        )
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          )
        ],
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
            _pageController.jumpToPage(index);
          });
        },
      ),
    );
  }
}