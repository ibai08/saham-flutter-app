import 'package:flutter/material.dart';

final List<Tab> tabViews = [
    Tab(
      icon: Image.asset(
        'assets/icon/bottomNavBar/home.png',
        width: 24,
        height: 24,
      ),
      child: const Text("Beranda", style: TextStyle(fontSize: 10)),
    ),
    Tab(
      icon: Image.asset(
        'assets/icon/bottomNavBar/compass 1.png',
        width: 24,
        height: 24,
      ),
      child: const Text("Jelajahi", style: TextStyle(fontSize: 10)),
    ),
    Tab(
      icon: Image.asset(
        'assets/icon/bottomNavBar/plus-circle 1.png',
        width: 24,
        height: 24,
      ),
      child: const Text("Signal", style: TextStyle(fontSize: 10)),
    ),
    Tab(
      icon: Image.asset(
        'assets/icon/bottomNavBar/bar-chart.png',
        width: 24,
        height: 24,
      ),
      child: const Text("Market", style: TextStyle(fontSize: 10)),
    ),
    Tab(
      icon: Image.asset(
        'assets/icon/bottomNavBar/user 1.png',
        width: 24,
        height: 24,
      ),
      child: const Text("Profil", style: TextStyle(fontSize: 10)),
    ),
  ];