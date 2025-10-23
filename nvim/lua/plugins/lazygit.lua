return {
	"kdheepak/lazygit.nvim",
	name = "lazygit", 
	lazy = false, -- Required for Telescope integration
	
	cmd = {
		"LazyGit",
		"LazyGitConfig",
		"LazyGitCurrentFile",
		"LazyGitFilter",
		"LazyGitFilterCurrentFile",
	},
    
	dependencies = {
		"nvim-telescope/telescope.nvim",
		"nvim-lua/plenary.nvim",
	},

	config = function()
        -- 1. Load Telescope extension immediately.
		require("telescope").load_extension("lazygit")
        
        -- 2. DELAY the execution of require("lazygit").setup({}) until Neovim is fully loaded (VimEnter).
		vim.api.nvim_create_autocmd("VimEnter", {
            group = vim.api.nvim_create_augroup("LazyGitSetupGroup", { clear = true }),
            once = true, -- Only run this once per session
            callback = function()
                local lazygit = require("lazygit")
                
                -- Calls setup with an empty table; reads options from global vim.g.* variables.
                if lazygit and lazygit.setup then
                    lazygit.setup({}) 
                end
            end,
        })
        
        -- 3. Autocmd to track repos on BufEnter for submodule/multi-repo support.
		vim.api.nvim_create_autocmd("BufEnter", {
			group = vim.api.nvim_create_augroup("LazyGitTrack", { clear = true }),
			callback = function()
				local utils = require('lazygit.utils')
				if utils and utils.project_root_dir then
					utils.project_root_dir()
				end
			end,
		})
	end,

	keys = {
		{ "<leader>lg", "<cmd>LazyGitCurrentFile<cr>", desc = "LazyGit: Open TUI (Current File Root)" },
		{ "<leader>lG", "<cmd>LazyGit<cr>", desc = "LazyGit: Open TUI (Current CWD)" },
		{ "<leader>lF", "<cmd>LazyGitFilter<cr>", desc = "LazyGit: Filter Project Commits" },
		{ "<leader>lf", "<cmd>LazyGitFilterCurrentFile<cr>", desc = "LazyGit: Filter Current File Commits" },
		{ "<leader>lc", "<cmd>LazyGitConfig<cr>", desc = "LazyGit: Edit Config File" },
	},
}
