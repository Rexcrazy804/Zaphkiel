-- adapted from https://github.com/neovim/nvim-lspconfig/blob/master/lsp/jdtls.lua
local function get_jdtls_cache_dir() return vim.fn.stdpath("cache") .. "/jdtls" end

local function get_jdtls_workspace_dir()
  return get_jdtls_cache_dir() .. "/workspace"
end

local function get_jdtls_jvm_args()
  local env = os.getenv("JDTLS_JVM_ARGS")
  local args = {}
  for a in string.gmatch((env or ""), "%S+") do
    local arg = string.format("--jvm-arg=%s", a)
    table.insert(args, arg)
  end
  return unpack(args)
end

---@type vim.lsp.Config
return {
  ---@param dispatchers? vim.lsp.rpc.Dispatchers
  ---@param config vim.lsp.ClientConfig
  cmd = function(dispatchers, config)
    local workspace_dir = get_jdtls_workspace_dir()
    local data_dir = workspace_dir

    if config.root_dir then
      data_dir = data_dir
        .. "/"
        .. vim.fn.fnamemodify(config.root_dir, ":p:h:t")
    end

    local config_cmd = {
      "jdtls",
      "-data",
      data_dir,
      get_jdtls_jvm_args(),
    }

    return vim.lsp.rpc.start(config_cmd, dispatchers, {
      cwd = config.cmd_cwd,
      env = config.cmd_env,
      detached = config.detached,
    })
  end,
  filetypes = { "java" },
  root_markers = {
    ".git",
    -- Multi-module projects
    "mvnw", -- Maven
    "gradlew", -- Gradle
    "settings.gradle", -- Gradle
    "settings.gradle.kts", -- Gradle
    "build.xml", -- Ant
    "pom.xml", -- Maven
    "build.gradle", -- Gradle
    "build.gradle.kts", -- Gradle
  },
  init_options = {},
}
