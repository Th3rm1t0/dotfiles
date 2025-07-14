-- キーマッピング
local keymap = vim.keymap

-- 基本的なキーマッピング
keymap.set("n", "pv", vim.cmd.Ex)
keymap.set("v", "J", ":m '>+1gv=gv")
keymap.set("v", "K", ":m '<-2gv=gv")
keymap.set("n", "J", "mzJ`z")
keymap.set("n", "", "zz")
keymap.set("n", "", "zz")
keymap.set("n", "n", "nzzzv")
keymap.set("n", "N", "Nzzzv")

-- コピー/ペースト
keymap.set("x", "p", [["_dP]])
keymap.set({"n", "v"}, "y", [["+y]])
keymap.set("n", "Y", [["+Y]])
keymap.set({"n", "v"}, "d", [["_d]])

-- 検索と置換
keymap.set("n", "s", [[:%s/\<\>//gI]])
