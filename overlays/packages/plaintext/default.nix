{ writeShellScriptBin, gnused }:

writeShellScriptBin "plaintext"
''
  # Strips all escape sequences and control codes from stdin.
  LC_COLLATE=C ${gnused}/bin/sed -e 's,[\x00-\x08\x0E-\x1F]\|\x1B\(\[[0-?]*[ -/]*[@-~]\),,g'
''

