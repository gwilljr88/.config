-- Set leader key
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Disable the spacebar key's default behavior in Normal and Visual modes
vim.keymap.set({ "n", "v" }, "<Space>", "<Nop>", { silent = true })

-- For conciseness
local opts = { noremap = true, silent = true }

-- save file
vim.keymap.set("n", "<C-s>", "<cmd> w <CR>", opts)

-- save file without auto-formatting
vim.keymap.set("n", "<leader>sn", "<cmd>noautocmd w <CR>", opts)

-- quit file
vim.keymap.set("n", "<C-q>", "<cmd> q <CR>", opts)

-- delete single character without copying into register
vim.keymap.set("n", "x", '"_x', opts)

-- Purpose: This function creates a key mapping (Ctrl+b) in normal mode that executes the current file
-- based on its filetype and displays the output in a split window.
-- It handles Python, C, C++, HTML, SQL, JavaScript, and Bash files.
-- For compiled languages, it compiles and then executes the resulting executable.
-- For interpreted languages, it runs the script using the corresponding interpreter.
-- For HTML, it opens the file in Google Chrome (no split window).
-- For SQL, it uses sqlite3 (replace <your_database_name> with your SQL client).
-- The mapping is non-recursive and silent.
-- All file paths are absolute and properly escaped for shell commands.
-- Output is displayed in a split window, except for HTML files.
vim.keymap.set("n", "<C-b>", function()
	-- Get the filetype of the current buffer.
	local filetype = vim.bo.filetype
	-- Get the absolute path of the current file, properly escaped for shell commands.
	local filename = vim.fn.shellescape(vim.fn.expand("%:p"))
	-- Get the absolute path of the current file without extension, properly escaped for shell commands.
	local filename_no_ext = vim.fn.shellescape(vim.fn.expand("%:p:r"))

	-- Initialize an empty command string.
	local command = ""

	-- Determine the command to execute based on the filetype.
	if filetype == "python" then
		-- Python 3 execution command.
		command = "python3 " .. filename
	elseif filetype == "c" then
		-- C compilation and execution command.
		command = "gcc " .. filename .. " -o " .. filename_no_ext .. " && ./" .. filename_no_ext
	elseif filetype == "cpp" then
		-- C++ compilation and execution command.
		command = "g++ " .. filename .. " -o " .. filename_no_ext .. " && ./" .. filename_no_ext
	elseif filetype == "html" then
		-- Open HTML file in Google Chrome. No split window for HTML.
		vim.cmd("!google-chrome " .. filename)
		-- Exit the function as HTML output is not captured.
		return
	elseif filetype == "sql" then
		-- SQL execution command (replace <your_database_name>).
		command = "sqlite3 <your_database_name> < " .. filename
	elseif filetype == "javascript" then
		-- JavaScript execution command using Node.js.
		command = "node " .. filename
	elseif filetype == "sh" then
		-- Bash script execution command.
		command = "bash " .. filename
	end

	-- If a command was determined (not empty, indicating not HTML).
	if command ~= "" then
		-- Open a new split window and read the command output into it.
		vim.cmd("silent new | r !" .. command)
		-- Move the cursor to the new split window.
		vim.cmd("wincmd j")
	end
end, opts)

-- Vertical scroll and center
vim.keymap.set("n", "<C-d>", "<C-d>zz", opts)
vim.keymap.set("n", "<C-u>", "<C-u>zz", opts)

-- Find and center
vim.keymap.set("n", "n", "nzzzv", opts)
vim.keymap.set("n", "N", "Nzzzv", opts)

-- Resize with arrows
--vim.keymap.set('n', '<Up>', ':resize -2<CR>', opts)
--vim.keymap.set('n', '<Down>', ':resize +2<CR>', opts)
--vim.keymap.set('n', '<Left>', ':vertical resize -2<CR>', opts)
--vim.keymap.set('n', '<Right>', ':vertical resize +2<CR>', opts)

-- Buffers
vim.keymap.set("n", "<Tab>", ":bnext<CR>", opts)
vim.keymap.set("n", "<S-Tab>", ":bprevious<CR>", opts)
vim.keymap.set("n", "<leader>x", ":bdelete!<CR>", opts) -- close buffer
vim.keymap.set("n", "<leader>b", "<cmd> enew <CR>", opts) -- new buffer

-- Window management
vim.keymap.set("n", "<leader>v", "<C-w>v", opts) -- split window vertically
vim.keymap.set("n", "<leader>h", "<C-w>s", opts) -- split window horizontally
vim.keymap.set("n", "<leader>se", "<C-w>=", opts) -- make split windows equal width & height
vim.keymap.set("n", "<leader>xs", ":close<CR>", opts) -- close current split window

-- Navigate between splits
vim.keymap.set("n", "<C-k>", ":wincmd k<CR>", opts)
vim.keymap.set("n", "<C-j>", ":wincmd j<CR>", opts)
vim.keymap.set("n", "<C-h>", ":wincmd h<CR>", opts)
vim.keymap.set("n", "<C-l>", ":wincmd l<CR>", opts)

-- Tabs
vim.keymap.set("n", "<leader>to", ":tabnew<CR>", opts) -- open new tab
vim.keymap.set("n", "<leader>tx", ":tabclose<CR>", opts) -- close current tab
vim.keymap.set("n", "<leader>tn", ":tabn<CR>", opts) --  go to next tab
vim.keymap.set("n", "<leader>tp", ":tabp<CR>", opts) --  go to previous tab

-- Toggle line wrapping
vim.keymap.set("n", "<leader>lw", "<cmd>set wrap!<CR>", opts)

-- Stay in indent mode
vim.keymap.set("v", "<", "<gv", opts)
vim.keymap.set("v", ">", ">gv", opts)

-- Keep last yanked when pasting
vim.keymap.set("v", "p", '"_dP', opts)

-- Diagnostic keymaps
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Go to previous diagnostic message" })
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Go to next diagnostic message" })
vim.keymap.set("n", "<leader>d", vim.diagnostic.open_float, { desc = "Open floating diagnostic message" })
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostics list" })
