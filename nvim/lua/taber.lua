vim.g.taber_settings = {
    default = {
        len = 4,
        use_tabs = true,
    },

    rust = {
        len = 4,
        use_tabs = false,
    },

    lua = {
        len = 4,
        use_tabs = false,
    },

    glsl = {
        len = 2,
        use_tabs = false,
    }
}

local taber = {}

local function global_settings_for_local_filetype()
    return vim.g.taber_settings[vim.bo.filetype] or vim.g.taber_settings.default
end

local function perform_tabbing_change_local(settings)
    if settings then
        vim.opt_local.shiftwidth = settings.len
        vim.opt_local.tabstop = settings.len

        vim.opt_local.expandtab = not settings.use_tabs
    end
end

vim.api.nvim_create_autocmd({ "BufEnter" }, {
    pattern = { "*" },
    callback = function(ev)
        perform_tabbing_change_local(taber.get_settings_of(vim.bo.filetype))
    end,
})

function taber.override(setting, skip_update)
    if type(setting) ~= "table" then
        error("expected argument #1 'settings' to be a table")
    end

    local settings_cpy = vim.g.taber_settings

    for ft, value in pairs(setting) do
        assert(type(value) == "table" and type(value.len) == "number" and type(value.use_tabs) == "boolean")
        settings_cpy[ft] = value
    end

    vim.g.taber_settings = settings_cpy

    if not skip_update then
      perform_tabbing_change_local(taber.get_settings_of(vim.bo.filetype))
    end
end

function taber.get_settings_of(ft)
    return ft and vim.g.taber_settings[ft] or vim.g.taber_settings.default
end

return taber
