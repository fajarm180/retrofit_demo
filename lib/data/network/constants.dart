import 'package:retrofit/retrofit.dart';

final baseURL = '';
const int receiveTimeout = 15000;
const int connectionTimeout = 15000;

// ignore: constant_identifier_names
const Authorization = Extra({'authorization': true});

const v1 = 'v1';
const v2 = 'v2';

const String slug = '/{slug}';
