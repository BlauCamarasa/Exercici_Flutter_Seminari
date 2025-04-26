import 'package:flutter/material.dart';
import '../models/user.dart';
import '../services/UserService.dart';

class UserProvider with ChangeNotifier {
  List<User> _users = [];
  User? _registeredUser;
  bool _isLoading = false;
  String? _error;

  List<User> get users => _users;
  User? get registeredUser => _registeredUser;
  bool get isLoading => _isLoading;
  String? get error => _error;

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String? errorMessage) {
    _error = errorMessage;
    notifyListeners();
  }

  Future<void> loadRegisteredUser(String id) async {
    try {
      _setLoading(true);
      _setError(null);
      final userData = await UserService.getUserById(id);
      _registeredUser = userData;
      notifyListeners();
    } catch (e) {
      _setError('Error carregant l\'usuari: $e');
    } finally {
      _setLoading(false);
    }
  }

    Future<void> editarUsuari(User usEditado) async {
    try {
      _setLoading(true);
      _setError(null);
      await UserService.updateUser(_registeredUser!.id!, usEditado);
      final userDataActu = await UserService.getUserById(_registeredUser!.id!);
      _registeredUser = userDataActu;
      _users = await UserService.getUsers();
      notifyListeners();
    } catch (e) {
      _setError('Error actualitzant l\'usuari: $e');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> loadUsers() async {
    _setLoading(true);
    _setError(null);
    //notifyListeners();

    try {
      _users = await UserService.getUsers();
    } catch (e) {
      _setError('Error loading users: $e');
      _users = [];
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> crearUsuari(String nom, int edat, String email, String password) async {
    _setLoading(true);
    _setError(null);

    try {
      final nouUsuari = User(name: nom, age: edat, email: email,password: password);
      final createdUser = await UserService.createUser(nouUsuari);
      _users.add(nouUsuari);
      _setLoading(false);
      notifyListeners();
      return true;
    } catch (e) {
      _setError('Error creating user: $e');
      _setLoading(false);
      return false;
    }
  }

  Future<bool> eliminarUsuariPerId (String id) async {
    _setLoading(true);
    _setError(null);
    try{
      final success = await UserService.deleteUser(id);
      if (success) {
        _users.removeWhere((user) => user.id == id);
        notifyListeners();
      }
      _setLoading(false);
      return success;
    } catch (e) {
      _setError('Error deleting user: $e');
      _setLoading(false);
      return false;
    }
  }
  Future<bool> eliminarUsuari(String name) async {
    _setLoading(true);
    _setError(null);

    try {
      // Trobem l'usuari pel nom
      final userToDelete = _users.firstWhere((user) => user.name == name);
      
      if (userToDelete.id != null) {
        final success = await UserService.deleteUser(userToDelete.id!);
        
        if (success) {
          // Eliminar l'usuari de la llista local
          _users.removeWhere((user) => user.name == name);
          notifyListeners();
        }
        
        _setLoading(false);
        return success;
      } else {
        // Si no té id, eliminar localment
        _users.removeWhere((user) => user.name == name);
        notifyListeners();
        _setLoading(false);
        return true;
      }
    } catch (e) {
      _setError('Error deleting user: $e');
      _setLoading(false);
      return false;
    }
  }
}
