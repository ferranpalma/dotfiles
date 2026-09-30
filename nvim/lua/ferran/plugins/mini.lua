-- Two small, independent pieces of the mini.nvim family. They are installed as
-- their own repositories rather than the whole mini.nvim bundle, so only these
-- two are actually cloned.
--
-- One file rather than two, because neither needs any configuration: splitting
-- them would be two files of three lines each.
--
-- mini.surround operates on the thing AROUND the cursor:
--   sa{motion}{char}  add a surrounding, e.g. saiw" quotes a word
--   sd{char}          delete it,        e.g. sd"
--   sr{old}{new}      replace it,       e.g. sr"'
--
-- mini.pairs inserts the closing half when ( [ { ' " are typed.

return {
	{ "nvim-mini/mini.surround", event = "VeryLazy", opts = {} },
	{ "nvim-mini/mini.pairs", event = "InsertEnter", opts = {} },
}
