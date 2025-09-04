return {
  "nvim-dbee",
  command = "Dbee",
  after = function()
    require("dbee").setup({
      default_connection = "sales_history",
      sources = {
        require("dbee.sources").MemorySource:new({
          {
            name = "owocle",
            type = "oracle",
            url = "oracle://system:rexies@0.0.0.0:1521/FREEPDB1"
          }, {
            name = "sales_history",
            type = "oracle",
            url = "oracle://HR:rexies@0.0.0.0:1521/FREEPDB1"
          }
        })
      }
    })
  end
}
