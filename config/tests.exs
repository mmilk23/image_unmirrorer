# config/test.exs
use Mix.Config

# Configure o mock para o módulo Image durante os testes
config :image_unmirrorer, :image_module, ImageMock

# Configuração do JUnitFormatter para relatórios de teste
config :junit_formatter,
  report_file: "junit.xml",
  report_dir: "./",
  print_report_file: true,
  prepend_project_name?: true,
  include_filename?: true,
  prepend_project_name?: false
