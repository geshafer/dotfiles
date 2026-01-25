local lsp_config = require("config.lsp")

return {
  {
    "neovim/nvim-lspconfig",
    lazy = true,
    dependencies = {
      "j-hui/fidget.nvim",
    },
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

      local function sorbet_cmd(_root)
        local command = { "bundle", "exec", "srb", "tc", "--lsp" }
        if vim.fn.executable("shadowenv") == 1 then
          local prefixed = { "shadowenv", "exec", "--" }
          return vim.list_extend(prefixed, command)
        end
        return command
      end

      local lsp_kinds = {
        ruby = {
          markers = { "Gemfile", ".ruby-lsp", "config.ru", "Rakefile", ".git", ".shadowenv.d" },
          make_cmd = ruby_cmd,
        },
        sorbet = {
          markers = { "sorbet" },
          make_cmd = sorbet_cmd,
          filetypes = { "ruby" },
        },
      }

      local state = {
        ruby = {},
        sorbet = {},
        buffers = {},
        indexed = {},
      }

      local function find_root(path, markers)
        if not path or path == "" then
          return nil
        end
        local dir = vim.fs.dirname(path)
        if not dir or dir == "" then
          return nil
        end

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

      local function start_client(kind, root)
        if not root then
          return nil
        end
        local cache = state[kind]
        if cache[root] then
          local client = vim.lsp.get_client_by_id(cache[root])
          if client and not client:is_stopped() then
            return cache[root]
          end
        end

        local spec = lsp_kinds[kind]
        local config = {
          name = kind .. "(" .. project_label(root) .. ")",
          cmd = spec.make_cmd(root),
          root_dir = root,
          capabilities = capabilities,
          on_attach = lsp_config.on_attach,
        }
        if spec.filetypes then
          config.filetypes = spec.filetypes
        end

        local client_id = vim.lsp.start(config, {
          reuse_client = function()
            return false
          end,
        })
        if client_id then
          cache[root] = client_id
        end
        return client_id
      end

      local function ensure_lsp(kind, bufnr, filepath)
        local spec = lsp_kinds[kind]
        local root = find_root(filepath, spec.markers)
        if not root then
          return
        end

        local entry = state.buffers[bufnr] or {}
        entry[kind] = root
        state.buffers[bufnr] = entry

        if attach_existing(state[kind][root], bufnr) then
          return
        end

        local client_id = start_client(kind, root)
        if client_id then
          vim.lsp.buf_attach_client(bufnr, client_id)
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

        for kind in pairs(lsp_kinds) do
          if entry[kind] and not root_in_use(kind, entry[kind]) then
            local client_id = state[kind][entry[kind]]
            if client_id then
              local client = vim.lsp.get_client_by_id(client_id)
              if client then
                client:stop()
              end
            end
            state[kind][entry[kind]] = nil
          end
        end
      end

      local function handle_buffer(bufnr)
        local filepath = vim.api.nvim_buf_get_name(bufnr)
        if filepath == "" then
          return
        end
        for kind in pairs(lsp_kinds) do
          ensure_lsp(kind, bufnr, filepath)
        end
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

      -- Start Ruby/Sorbet LSPs after startup if cwd is a Ruby project
      vim.api.nvim_create_autocmd("VimEnter", {
        group = group,
        callback = function()
          vim.schedule(function()
            local cwd = vim.fn.getcwd()
            local marker = cwd .. "/."
            for kind, spec in pairs(lsp_kinds) do
              local root = find_root(marker, spec.markers)
              if root then
                vim.notify("Starting " .. kind .. " for " .. project_label(root), vim.log.levels.INFO)
                start_client(kind, root)
              end
            end
          end)
        end,
      })

    end,
  },
}
