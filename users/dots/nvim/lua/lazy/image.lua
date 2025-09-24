return {
  "image.nvim",
  filetypes = { "markdown", "norg", "typst", "html", "css" },
  after = function()
    require("image").setup({
      backend = "sixel",
      processor = "magick_rock",
      integrations = {
        markdown = {
          enabled = true,
          clear_in_insert_mode = false,
          download_remote_images = true,
          only_render_image_at_cursor = true,
          only_render_image_at_cursor_mode = "popup",
          floating_windows = false,
          filetypes = { "markdown", "vimwiki" },
        },
        neorg = { enabled = true, filetypes = { "norg" } },
        typst = { enabled = true, filetypes = { "typst" } },
        html = { enabled = true },
        css = { enabled = true },
      },
      max_width = nil,
      max_height = nil,
      max_width_window_percentage = nil,
      max_height_window_percentage = 50,
      scale_factor = 1.0,
      window_overlap_clear_enabled = false,
      window_overlap_clear_ft_ignore = {
        "cmp_menu",
        "cmp_docs",
        "snacks_notif",
        "scrollview",
        "scrollview_sign",
      },
      editor_only_render_when_focused = false,
      tmux_show_only_in_active_window = false,
      hijack_file_patterns = {
        "*.png",
        "*.jpg",
        "*.jpeg",
        "*.gif",
        "*.webp",
        "*.avif",
      },
    })
  end,
}
