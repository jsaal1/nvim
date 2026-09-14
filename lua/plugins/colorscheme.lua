local colorschemes = require("core.colorschemes")

-- All colorschemes are lazy-loaded: lazy.nvim indexes each plugin's colors/
-- directory and loads the right one automatically when core.theme calls
-- `:colorscheme <name>` (on startup, or via the cycler/picker).
return vim.tbl_map(function(item)
    local spec = {
        item.repo,
        lazy = true,
    }

    if item.name then
        spec.name = item.name
    end

    if item.opts then
        spec.opts = item.opts
    end

    if item.build ~= nil then
        spec.build = item.build
    end

    return spec
end, colorschemes.items)
