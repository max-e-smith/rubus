import os
import logging
from datetime import datetime

class LoggerBuilder(object):
    def __init__(self, keyword, level, handler, formatter):
        self.__formatter = formatter
        self.__handler = handler
        self.__level = level
        self.__logger: logging.Logger = logging.getLogger(f'{keyword}')

        self.__remove_existing_handlers()
        self.__add_handler_to_logger()

    def get_logger(self):
        return self.__logger

    @staticmethod
    def create_log_file_path(log_file_dir, log_file_keyword, log_root, log_dir):
        if not log_root:
            log_root = os.getcwd()
        timestamp = datetime.now()
        dirpath = os.path.join(log_root, log_dir, str.upper(timestamp.strftime('%d-%b-%Y_%H%M%S')), log_file_dir)
        if not os.path.exists(dirpath):
            os.makedirs(dirpath)

        return os.path.join(dirpath, f'{log_file_keyword}.log')

    def __get_formatter(self):
        return self.__formatter

    def __remove_existing_handlers(self):
        handlers = self.__logger.handlers[:]
        for handler in handlers:
            handler.close()
            self.__logger.removeHandler(handler)

    def __add_handler_to_logger(self):
        self.__handler.setFormatter(self.__get_formatter())
        self.__logger.addHandler(self.__handler)
