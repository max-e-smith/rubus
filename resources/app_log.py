import logging
from logging.handlers import RotatingFileHandler

from src.mb_archive_web_search.logger import LoggerBuilder
from src.mb_archive_web_search.config.properties import Properties

class LogConsts(object):
    ERROR = "ERROR"
    DEBUG = "DEBUG"

class LogLevels(object):
    INFO = 'info'
    WARNING = 'warning'
    CRITICAL = 'critical'
    DEBUG = 'debug'

class AppLog(object):
    log: logging.Logger = None

    def __init__(self):
        self.__pre_check()
        self.__initialize_log()

    def __initialize_log(self):
        keyword = "standard_logger"
        directory = "log"

        level = Properties.log_config.level
        log_size_mb = Properties.log_config.log_size_mb
        handler = self. __get_log_handler(log_size_mb, keyword, directory)
        formatter = self.__get_log_formatter()

        builder = LoggerBuilder(keyword, level, handler, formatter)
        AppLog.log = builder.get_logger()

        console_handler = logging.StreamHandler()
        console_handler.setFormatter(formatter)
        AppLog.log.addHandler(console_handler)

        self.__validate_level(AppLog.log, level)

    @staticmethod
    def __pre_check():
        if not Properties.log_config:
            raise RuntimeError("Properties must be loaded prior to creating a logger")

    @staticmethod
    def __get_log_handler(log_size_mb, keyword, log_dir):
        log_path = LoggerBuilder.create_log_file_path(log_dir, keyword)
        log_size = int(log_size_mb)*1024*1024  # 10MB
        return logging.handlers.RotatingFileHandler(log_path, maxBytes=log_size, backupCount=10)

    @staticmethod
    def __get_log_formatter():
        return logging.Formatter('%(asctime)s %(levelname)-7s %(message)s', '%Y-%m-%d %H:%M:%S')

    @staticmethod
    def __validate_level(logger, level):
        if level == LogLevels.INFO:
            logger.info(f"Logger initialized at level {LogLevels.INFO}.")
            return
        if level == LogLevels.WARNING:
            logger.info(f"Logger initialized at level {LogLevels.WARNING}.")
            return
        if level == LogLevels.CRITICAL:
            logger.info(f"Logger initialized at level {LogLevels.CRITICAL}.")
            return
        if level == LogLevels.DEBUG:
            logger.info(f"Logger initialized at level {LogLevels.DEBUG}.")
            return
        logger.info("Provided log level unrecognized. Logger defaulting to DEBUG level logging.")

    @staticmethod
    def log_database_error(message: str, exception: Exception):
        try:
            exception_message = str(exception)
            Properties.log.error(f"{LogConsts.ERROR} -- Database Error: {message} with exception: {exception_message}")
        except UnicodeDecodeError:
            print("Failed to decode exception message.")
            Properties.log.error(f"{LogConsts.ERROR} -- Database Error: {message}")

    @staticmethod
    def log_exception(exception):
        AppLog.log.exception(exception)

    @classmethod
    def log_error(cls, message):
        AppLog.log.error(f"{LogConsts.ERROR} -- {message}")

    @classmethod
    def log_debug(cls, message):
        AppLog.log.debug(f"{LogConsts.DEBUG} -- {message}")

    @classmethod
    def log_info(cls, message):
        AppLog.log.info(f"{message}")
