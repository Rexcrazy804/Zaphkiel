local library = {}

-- don't waste time loading vim stuff if I am not in the nixos
-- configuration directory
if vim.fn.getcwd():find("nixos") then library[#library + 1] = vim.env.VIMRUNTIME end

-- this is for getting LuaCats completions from devEnvs and is
-- entirely custom basically read the env var [ string of ':'
-- seperated paths] and tokenizes it using the gmatch function the
-- regex matches every continuos sequence of characters that is not
-- ':' and appends it to the library variable
local catsLibs = os.getenv("LUACATS_LIB") or ""
for lib in catsLibs:gmatch("([^:]+)") do library[#library + 1] = lib end

return {
  cmd = { "lua-language-server" },
  filetypes = { "lua" },
  root_markers = { ".luarc.json", ".luarc.jsonc", ".git" },

  settings = {
    Lua = {
      runtime = { version = "LuaJIT" },
      workspace = { checkThirdParty = false, library = library },
      telemetry = { enable = false }
    }
  }
}
