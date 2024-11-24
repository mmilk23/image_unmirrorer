# test/test_helper.exs

ExUnit.configure(formatters: [ExUnit.CLIFormatter, JUnitFormatter])

# inspect configuration to ensure loading
IO.inspect(Application.get_env(:junit_formatter, :report_file), label: "JUnit Formatter Report File")
IO.inspect(Application.get_env(:junit_formatter, :report_dir), label: "JUnit Formatter Report Directory")

# Força configurações para o JUnitFormatter
Application.put_env(:junit_formatter, :report_file, "junit.xml")
Application.put_env(:junit_formatter, :report_dir, "./")
Application.put_env(:junit_formatter, :print_report_file, true)
Application.put_env(:junit_formatter, :prepend_project_name?, true)
Application.put_env(:junit_formatter, :include_filename?, true)
Application.put_env(:junit_formatter, :prepend_project_name?, false)



# Define o mock para Image.Behaviour
Mox.defmock(ImageMock, for: Image.Behaviour)

# Configura o Mox para usar context-based mocking
Mox.set_mox_from_context([])

# Configura o uso do mock na aplicação durante os testes
Application.put_env(:image_unmirrorer, :image_module, ImageMock)

ExUnit.start(formatters: [ExUnit.CLIFormatter, JUnitFormatter])
