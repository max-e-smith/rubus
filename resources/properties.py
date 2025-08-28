import os
import yaml

from pathlib import Path

class OracleDbConfig(object):
  def __init__(self, config):
    self.server = config['server']
    self.port = config['port']
    self.user = config['user']
    self.password = config['password']
    self.service = config['service'] if config['service'] else None
    self.sid = config['sid'] if config['sid'] else None

class LogConfig(object):
  def __init__(self, config):
    self.log_root = config['log_root']
    self.log_path = config['log_dir']
    self.level = config['level']
    self.log_size_mb = config['log_size_mb']


class RunParameters(object):
  def __init__(self, config):
    self.json_output_path = config['json_output_path']


class Properties(object):
  cruise_db_config: OracleDbConfig = None
  log_config: LogConfig = None
  run_parameters: RunParameters = None

  def __init__(self, filename):
    with open(filename, 'r') as yaml_data_file:
      config = yaml.safe_load(yaml_data_file)

    Properties.cruise_db_config = OracleDbConfig(config['cruise_db'])
    Properties.log_config = LogConfig(config['log'])
    Properties.run_parameters = RunParameters(config['run_parameters'])

    self.__set_project_dirs()

  @staticmethod
  def get_project_root():
    return Properties.PROJECT_ROOT

  @staticmethod
  def get_src_dir():
    return Properties.SRC_DIR

  @staticmethod
  def get_tests_dir():
    return Properties.TESTS_DIR

  @staticmethod
  def __set_project_dirs():
    Properties.PROJECT_ROOT = Path(__file__).absolute().parent.parent.parent
    Properties.SRC_DIR = os.path.join(Properties.PROJECT_ROOT, 'src')
    Properties.TESTS_DIR = os.path.join(Properties.PROJECT_ROOT, 'tests')
