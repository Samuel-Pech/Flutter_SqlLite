import 'package:flutter/material.dart';
import 'package:lista_tareas/screen/guardados.dart';
import 'package:lista_tareas/screen/home.dart'; // Asegúrate de que la ruta sea correcta

class Navbar extends StatelessWidget {
  const Navbar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Inicio',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.star),
          label: 'Guardados',
        ),
      ],
      currentIndex: 0, // Cambia este índice según la pantalla activa
      selectedItemColor: Colors.blue, // Color del ítem seleccionado
      unselectedItemColor: Colors.grey, // Color de los ítems no seleccionados
      backgroundColor: Colors.white, // Color de fondo de la barra
      elevation: 5, // Elevación para un efecto de sombra
      onTap: (index) {
        if (index == 0) {
          // Navegar a Home sin animación
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const HomeScreen()),
          );
        } else if (index == 1) {
          // Navegar a GuardadosScreen sin animación
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const GuardadosScreen()),
          );
        }
      },
    );
  }
}
