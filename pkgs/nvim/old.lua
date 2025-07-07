require("lz.n").load {
  {
    "nvim-lspconfig",

      lspconfig["qmlls"].setup({
        on_attach = on_attach,
        capabilities = capabilities,
        cmd = { "qmlls", "-E" },
      })

      lspconfig["sqls"].setup({
        on_attach = on_attach,
        capabilities = capabilities,
        settings = {
          ['sqls'] = {
            connections = {
              {
                driver = "oracle",
                proto = "tcp",
                user = "system",
                passwd = "rexies",
                host = "127.0.0.1",
                port = 1521,
                dbName = "FREEPDB1",
                params = {
                  tls = "skip-verify"
                }
              },
              {
                driver = "oracle",
                proto = "tcp",
                user = "HR",
                passwd = "rexies",
                host = "127.0.0.1",
                port = 1521,
                dbName = "FREEPDB1",
                params = {
                  tls = "skip-verify"
                }
              },
            }
          }
        }
      })

      lspconfig["rust_analyzer"].setup({
        on_attach = on_attach,
        capabilities = capabilities,
        settings = {
          ['rust-analyzer'] = {
            check = {
              command = "clippy",
              invocationLocation = "workspace",
              features = "all",
              extraArgs = {
                "--",
                "--no-deps",
                "-Dclippy::correctness",
                "-Dclippy::complexity",
                "-Wclippy::perf",
                "-Wclippy::pedantic",
              }
            },
            diagnostics = { styleLints = { enable = true } },
            rustfmt = { rangeFormatting = { enable = true } },
          }
        }
      })
    end,
  },
}
