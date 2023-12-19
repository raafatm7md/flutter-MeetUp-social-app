part of 'chat_cubit.dart';

@immutable
abstract class ChatState {}

class ChatInitial extends ChatState {}

class ChatConnectionSuccess extends ChatState {}

class ChatConnectionError extends ChatState {}

class ChatDisconnectSuccess extends ChatState {}
