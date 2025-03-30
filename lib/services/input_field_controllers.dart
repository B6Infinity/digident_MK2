// ignore_for_file: non_constant_identifier_names

import 'package:digident/config/app_config.dart';
import 'package:flutter/material.dart';

TextEditingController configHostIP_Controller = TextEditingController(
  text: AppConfig.SERVER_IP,
);
TextEditingController configHostPORT_Controller = TextEditingController(
  text: "${AppConfig.SERVER_PORT}",
);
