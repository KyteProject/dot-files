-- LSP Setup {{
-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md
local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())
capabilities.textDocument.completion.completionItem.snippetSupport = true

-- Mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
local opts = { noremap=true, silent=true }
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, opts)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
-- vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist, opts)

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
  -- Enable completion triggered by <c-x><c-o>
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  -- See `:help vim.lsp.*` for documentation on any of the below functions
  local bufopts = { noremap=true, silent=true, buffer=bufnr }
  vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
  vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
  vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
  vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
  vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, bufopts)
  -- vim.keymap.set('n', '<leader>wa', vim.lsp.buf.add_workspace_folder, bufopts)
  -- vim.keymap.set('n', '<leader>wr', vim.lsp.buf.remove_workspace_folder, bufopts)
  -- vim.keymap.set('n', '<leader>wl', function()
  --   print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  -- end, bufopts)
  vim.keymap.set('n', '<leader>D', vim.lsp.buf.type_definition, bufopts)
  vim.keymap.set('n', '<leader>r', vim.lsp.buf.rename, bufopts)
  vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, bufopts)
  vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
  vim.keymap.set('n', '<leader>f', vim.lsp.buf.formatting, bufopts)
end

local lsp_flags = {
  -- This is the default in Nvim 0.7+
  debounce_text_changes = 150,
}

require'lspconfig'.cssls.setup{
  capabilities = capabilities,
  on_attach = on_attach,
  flags = lsp_flags,
}

require'lspconfig'.cssmodules_ls.setup{
  capabilities = capabilities,
  on_attach = on_attach,
  flags = lsp_flags,
}

require'lspconfig'.graphql.setup{
    capabilities = capabilities,
    on_attach = on_attach,
    flags = lsp_flags,
}
require'lspconfig'.tailwindcss.setup{
    capabilities = capabilities,
    on_attach = on_attach,
    flags = lsp_flags,
}
require'lspconfig'.tsserver.setup{
    capabilities = capabilities,
    on_attach = on_attach,
    flags = lsp_flags,
}
require'lspconfig'.svelte.setup{
    capabilities = capabilities,
    on_attach = on_attach,
    flags = lsp_flags,
}
require'lspconfig'.vimls.setup{
    capabilities = capabilities,
    on_attach = on_attach,
    flags = lsp_flags,
}
require'lspconfig'.yamlls.setup{
    capabilities = capabilities,
    on_attach = on_attach,
    flags = lsp_flags,
}
require'lspconfig'.gopls.setup{
    capabilities = capabilities,
    on_attach = on_attach,
    flags = lsp_flags,
}
-- }}



-- Setup nvim-cmp. {{
vim.opt.completeopt={'menu', 'menuone', 'noselect'}

local lspkind = require('lspkind')

local source_mapping = {
	buffer = "[Buffer]",
	nvim_lsp = "[LSP]",
	nvim_lua = "[Lua]",
	cmp_tabnine = "[TN]",
	path = "[Path]",
}

local cmp = require'cmp'

  cmp.setup({
    snippet = {
      -- REQUIRED - you must specify a snippet engine
      expand = function(args)
        vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
      end,
    },
    window = {
      -- completion = cmp.config.window.bordered(),
      -- documentation = cmp.config.window.bordered(),
    },
    mapping = cmp.mapping.preset.insert({
      ['<C-b>'] = cmp.mapping.scroll_docs(-4),
      ['<C-f>'] = cmp.mapping.scroll_docs(4),
      ['<C-Space>'] = cmp.mapping.complete(),
      ['<C-e>'] = cmp.mapping.abort(),
      ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
    }),
    sources = cmp.config.sources({
      { name = 'nvim_lsp' },
      { name = 'vsnip' }, -- For vsnip users.
    }, {
      { name = 'buffer' },
      { name = 'cmp_tabnine' },
    }),
    formatting = {
		format = function(entry, vim_item)
			vim_item.kind = lspkind.presets.default[vim_item.kind]
			local menu = source_mapping[entry.source.name]
			if entry.source.name == 'cmp_tabnine' then
				if entry.completion_item.data ~= nil and entry.completion_item.data.detail ~= nil then
					menu = entry.completion_item.data.detail .. ' ' .. menu
				end
				vim_item.kind = ''
			end
			vim_item.menu = menu
			return vim_item
		end
	},
  })

  -- Set configuration for specific filetype.
  cmp.setup.filetype('gitcommit', {
    sources = cmp.config.sources({
      { name = 'cmp_git' }, -- You can specify the `cmp_git` source if you were installed it.
    }, {
      { name = 'buffer' },
    })
  })

  -- Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
  cmp.setup.cmdline('/', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = {
      { name = 'buffer' }
    }
  })

  -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
  cmp.setup.cmdline(':', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({
      { name = 'path' }
    }, {
      { name = 'cmdline' }
    })
  })
-- }}



-- Telescope {{
local action_state = require('telescope.actions.state')

require('telescope').setup {
    defaults = {
        -- file_sorter = require("telescope.sorters").get_fzy_sorter,
        promt_prefix = " >",
        color_devicons = true,

        --file_previewer = require("telescope.previewers").vim_buffer_cat.new,
        --grep_previewer = require("telescrope.previewers").vim_buffer_vimgrep.new,
        --qflist_previewer = require("telescrope.previewers").vim_buffer_qflist.new,

        winblend = 0,
        preview_cuttoff = 120,

        layout_strategy = "horizontal",

        mappings = {
            -- INSERT mode mappings
            i = {
                ["<C-x>"] = false,
				-- ["<C-q>"] = actions.send_to_qflist,

                ["<C-a>"] = function() print(vim.inspect(action_state.get_selected_entry())) end
            }
        }
    }
}

require('telescope').load_extension('fzf')

local mappings = {

}

mappings.curr_buf = function()
    local opt = require('telescope.themes').get_dropdown({height=10, previewer=false})
    require('telescope.builtin').current_buffer_fuzzy_find(opt)
end
-- }}



-- Treesitter {{
require'nvim-treesitter.configs'.setup {
    ensure_installed = { "c", "lua", "html", "css", "json", "typescript", "javascript", "php", "go", "bash", "dockerfile", "yaml", "gomod", "graphql", "make", "markdown", "proto", "regex", "sql", "rust", "svelte", "vim", "vue" },
    sync_install = false,
    auto_install = true,

    highlight = {
        enable = true
    }
}
-- }}



return mappings

