return {
  "nvim-dbee",
  command = "Dbee",
  after = function()
    require("dbee").setup({
      default_connection = "sales_history",
      sources = {
        require("dbee.sources").MemorySource:new({
          {
            name = "owocle test",
            type = "oracle",
            url = "oracle://apps:{{ env `DB_PWD` }}@10.28.7.11:1526/TEST",
          },
        }),
      },
    })
  end,
}
