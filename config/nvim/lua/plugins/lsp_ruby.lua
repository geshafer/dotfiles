local lsp_config = require("config.lsp")

return {
  {
    "neovim/nvim-lspconfig",
    lazy = true,
    init = function()
      local util = require("lspconfig.util")

      local function make_capabilities()
        local ok_cmp, cmp = pcall(require, "cmp_nvim_lsp")
        if ok_cmp then
          return cmp.default_capabilities()
        end
        return vim.lsp.protocol.make_client_capabilities()
      end

      local capabilities = make_capabilities()

      local function project_label(root)
        if not root or root == "" then
          return "?"
        end
        local label = vim.fs.basename(root)
        if label and label ~= "" and label ~= "." then
          return label
        end
        return root:gsub("[^%w_%-]+", "_")
      end

      local function ruby_cmd(root)
        if vim.fn.executable("shadowenv") == 1 then
          if root and root ~= "" then
            local bin = util.path.join(root, "bin", "ruby-lsp")
            if bin and vim.loop.fs_stat(bin) then
              return { "shadowenv", "exec", "--", bin }
            end
          end
          return { "shadowenv", "exec", "--", "ruby-lsp" }
        end

        if root and root ~= "" then
          local bin = util.path.join(root, "bin", "ruby-lsp")
          if bin and vim.loop.fs_stat(bin) then
            return { bin }
          end
        end

        return { "ruby-lsp" }
      end

      local function sorbet_cmd()
        local command = { "bundle", "exec", "srb", "tc", "--lsp" }
        if vim.fn.executable("shadowenv") == 1 then
          local prefixed = { "shadowenv", "exec", "--" }
          return vim.list_extend(prefixed, command)
        end
        return command
      end

      local state = {
        ruby = {},
        sorbet = {},
        buffers = {},
      }

      local function find_ruby_root(path)
        if not path or path == "" then
          return nil
        end
        local dir = vim.fs.dirname(path)
        if not dir or dir == "" then
          return nil
        end
        local markers = { "Gemfile", ".ruby-lsp", "config.ru", "Rakefile", ".git", ".shadowenv.d" }
        local found = vim.fs.find(markers, {
          upward = true,
          path = dir,
          stop = vim.loop.os_homedir(),
        })
        if #found == 0 then
          return nil
        end
        return vim.fs.dirname(found[1])
      end

      local function find_sorbet_root(path)
        if not path or path == "" then
          return nil
        end
        local dir = vim.fs.dirname(path)
        if not dir or dir == "" then
          return nil
        end
        local found = vim.fs.find("sorbet/config", {
          upward = true,
          path = dir,
          stop = vim.loop.os_homedir(),
        })
        if #found == 0 then
          return nil
        end
        return vim.fs.dirname(vim.fs.dirname(found[1]))
      end

      local function attach_existing(client_id, bufnr)
        if not client_id then
          return false
        end
        local client = vim.lsp.get_client_by_id(client_id)
        if not client or client:is_stopped() then
          return false
        end
        return vim.lsp.buf_attach_client(bufnr, client_id)
      end

      local function ensure_ruby(bufnr, filepath)
        local root = find_ruby_root(filepath)
        if not root then
          return
        end
        local entry = state.buffers[bufnr] or {}
        entry.ruby = root
        state.buffers[bufnr] = entry
        if attach_existing(state.ruby[root], bufnr) then
          return
        end

        local config = {
          name = string.format("ruby_lsp(%s)", project_label(root)),
          cmd = ruby_cmd(root),
          root_dir = root,
          capabilities = capabilities,
          on_attach = lsp_config.on_attach,
        }
        local client_id = vim.lsp.start(config, {
          bufnr = bufnr,
          reuse_client = function()
            return false
          end,
        })
        if client_id then
          state.ruby[root] = client_id
        end
      end

      local function ensure_sorbet(bufnr, filepath)
        local root = find_sorbet_root(filepath)
        if not root then
          return
        end
        local entry = state.buffers[bufnr] or {}
        entry.sorbet = root
        state.buffers[bufnr] = entry
        if attach_existing(state.sorbet[root], bufnr) then
          return
        end

        local config = {
          name = string.format("sorbet(%s)", project_label(root)),
          cmd = sorbet_cmd(),
          root_dir = root,
          capabilities = capabilities,
          filetypes = { "ruby" },
          on_attach = lsp_config.on_attach,
        }
        local client_id = vim.lsp.start(config, {
          bufnr = bufnr,
          reuse_client = function()
            return false
          end,
        })
        if client_id then
          state.sorbet[root] = client_id
        end
      end

      local function root_in_use(kind, root)
        for _, info in pairs(state.buffers) do
          if info[kind] == root then
            return true
          end
        end
        return false
      end

      local function cleanup(bufnr)
        local entry = state.buffers[bufnr]
        if not entry then
          return
        end
        state.buffers[bufnr] = nil

        if entry.ruby and not root_in_use("ruby", entry.ruby) then
          local client_id = state.ruby[entry.ruby]
          if client_id then
            local client = vim.lsp.get_client_by_id(client_id)
            if client then
              client:stop()
            end
          end
          state.ruby[entry.ruby] = nil
        end

        if entry.sorbet and not root_in_use("sorbet", entry.sorbet) then
          local client_id = state.sorbet[entry.sorbet]
          if client_id then
            local client = vim.lsp.get_client_by_id(client_id)
            if client then
              client:stop()
            end
          end
          state.sorbet[entry.sorbet] = nil
        end
      end

      local function handle_buffer(bufnr)
        local filepath = vim.api.nvim_buf_get_name(bufnr)
        if filepath == "" then
          return
        end
        ensure_ruby(bufnr, filepath)
        ensure_sorbet(bufnr, filepath)
      end

      local group = vim.api.nvim_create_augroup("ruby_shadowenv_lsp", { clear = true })

      vim.api.nvim_create_autocmd({ "BufReadPost", "BufNewFile", "BufEnter" }, {
        group = group,
        pattern = { "*.rb", "*.rake", "Gemfile", "Rakefile", "*.gemspec" },
        callback = function(args)
          handle_buffer(args.buf)
        end,
      })

      vim.api.nvim_create_autocmd("BufWipeout", {
        group = group,
        pattern = { "*.rb", "*.rake", "Gemfile", "Rakefile", "*.gemspec" },
        callback = function(args)
          cleanup(args.buf)
        end,
      })
    end,
  },
}
