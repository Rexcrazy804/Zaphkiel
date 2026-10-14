-- silly abbreviations for sql tomfoolery
--
-- why don't you use snippets?
-- uhhhh good question!
-- ... what I have to answer that?
-- wasn't rating your question as good enough?
-- .... I will figure that out one day, but that day is not today!

local abbreviations = {
  stf = "SELECT *\nFROM",
  bde = "DECLARE\nBEGIN\nEND;",
  whr = "WHERE 1=1\n  AND",
}

for abv, expansion in pairs(abbreviations) do
  vim.cmd.abbreviate({ abv, expansion })
end
