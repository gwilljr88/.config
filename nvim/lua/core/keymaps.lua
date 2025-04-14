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

	-- Check if the filetype is Python.
	if filetype == "python" then
		-- Open a new terminal split and run the Python script.
		-- Use tmux if available, otherwise fallback to other terminal options.
		-- Adjust the terminal command to suit your environment.
		-- vim.cmd("!tmux split-window -h 'python3 " .. filename .. "'") -- For tmux
		-- or:
		vim.cmd("!gnome-terminal -- python3 " .. filename) -- For gnome-terminal
		-- or:
		-- vim.cmd("!xterm -e python3 " .. filename) -- For xterm
		-- or:
		-- vim.cmd("!konsole -e python3 " .. filename) -- For konsole

		-- Check if the filetype is C or C++.
	elseif filetype == "c" or filetype == "cpp" then
		-- Get the filename without extension for compilation.
		local filename_no_ext = vim.fn.shellescape(vim.fn.expand("%:p:r"))
		-- Construct the compilation and execution command.
		local compile_and_run = "gcc " .. filename .. " -o " .. filename_no_ext .. " && ./" .. filename_no_ext
		-- If it's a C++ file, use g++.
		if filetype == "cpp" then
			compile_and_run = "g++ " .. filename .. " -o " .. filename_no_ext .. " && ./" .. filename_no_ext
		end
		-- Open a new terminal split and run the compilation and execution.
		vim.cmd("!tmux split-window -h '" .. compile_and_run .. "'")

	-- Check if the filetype is HTML.
	elseif filetype == "html" then
		-- Open the HTML file in Google Chrome.
		vim.cmd("!google-chrome " .. filename)

	-- Check if the filetype is SQL.
	elseif filetype == "sql" then
		-- Open a new terminal split and run the SQL script.
		-- Replace <your_database_name> with your actual database name.
		vim.cmd("!tmux split-window -h 'sqlite3 <your_database_name> < " .. filename .. "'")

	-- Check if the filetype is JavaScript.
	elseif filetype == "javascript" then
		-- Open a new terminal split and run the JavaScript script using Node.js.
		vim.cmd("!tmux split-window -h 'node " .. filename .. "'")

	-- Check if the filetype is Bash shell script.
	elseif filetype == "sh" then
		-- Open a new terminal split and run the Bash script.
		vim.cmd("!tmux split-window -h 'bash " .. filename .. "'")
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
