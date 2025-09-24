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

---@type vim.lsp.Config
return {
  cmd = { "lua-language-server" },
  filetypes = { "lua" },
  root_markers = { ".luarc.json", ".luarc.jsonc", ".git" },

  settings = {
    Lua = {
      runtime = { version = "LuaJIT" },
      workspace = { checkThirdParty = false, library = library },
      telemetry = { enable = false },
      format = {
        defaultConfig = {
          indent_style = "space",
          indent_size = "2",
          tab_width = "2",
          quote_style = "double",
          continuation_indent = "2",
          max_line_length = "80",
          end_of_line = "unset",
          table_separator_style = "comma",
          trailing_table_separator = "never",
          call_arg_parentheses = "keep",
          detect_end_of_line = "false",
          insert_final_newline = "true",

          space_around_table_field_list = "true",
          space_before_attribute = "true",
          space_before_function_open_parenthesis = "true",
          space_before_function_call_open_parenthesis = "false",
          space_before_closure_open_parenthesis = "true",
          space_before_function_call_single_arg = "always",
          space_before_open_square_bracket = "false",
          space_inside_function_call_parentheses = "false",
          space_inside_function_param_list_parentheses = "false",
          space_inside_square_brackets = "false",

          space_around_table_append_operator = "false",
          ignore_spaces_inside_function_call = "false",
          space_before_inline_comment = "1",
          space_after_comment_dash = "false",
          space_around_math_operator = "true",

          space_after_comma = "true",
          space_after_comma_in_for_statement = "true",
          space_around_concat_operator = "true",
          space_around_logical_operator = "true",
          space_around_assign_operator = "true"
        }
      }
    }
  }
}
