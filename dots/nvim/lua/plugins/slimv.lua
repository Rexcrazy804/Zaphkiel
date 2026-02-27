return {
  "slimv",
  ft = { "lisp", "cl" },
  after = function()
    vim.g.slimv_swank_cmd = "call jobstart('foot sbcl --load "
      .. vim.opt.packpath:get()[1]
      .. "/pack/mnw/opt/slimv/slime/start-swank.lisp')"
  end,
}
