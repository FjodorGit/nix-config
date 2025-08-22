local config = {
  cmd = { '/nix/store/505x2ig4hairs49yxgrfbxfw2r5p5i9i-jdt-language-server-1.47.0/bin/jdtls' },
  root_dir = vim.fs.dirname(vim.fs.find({ 'gradlew', '.git', 'mvnw' }, { upward = true })[1]),
}
require('jdtls').start_or_attach(config)
