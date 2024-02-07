import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

// Provide static logger object:
Logger log =
    Logger(filter: ProductionFilter(), level: kReleaseMode ? Level.info : Level.trace, output: ConsoleOutput());
