local taber = require("taber")
local cmdbar = require("cmdbar")

local function apply_tab_size(size)
    local ft = vim.bo.filetype
    local settings = taber.get_settings_of(ft)
    taber.override({ [ft] = { len = size, use_tabs = settings.use_tabs }})
end

local change_indent = cmdbar.Menu({
    name = "style",
    choices = {
        tabs = cmdbar.Action(function()
            local ft = vim.bo.filetype
            local settings = taber.get_settings_of(ft)
            taber.override({ [ft] = { len = settings.len, use_tabs = true } })
        end),

        spaces = cmdbar.Action(function()
            local ft = vim.bo.filetype
            local settings = taber.get_settings_of(ft)
            taber.override({ [ft] = { len = settings.len, use_tabs = true } })
        end),
    },
})

local change_tab_size = cmdbar.Menu({
    name = "size",
    choices = {
        ["1"] = cmdbar.Action(function()
            apply_tab_size(1)
        end),
        ["2"] = cmdbar.Action(function()
            apply_tab_size(2)
        end),
        ["3"] = cmdbar.Action(function()
            apply_tab_size(3)
        end),
        ["4"] = cmdbar.Action(function()
            apply_tab_size(4)
        end),
        ["8"] = cmdbar.Action(function()
            apply_tab_size(8)
        end),
    }
})


local function write_at_cursor(text)
    local row, col = unpack(vim.api.nvim_win_get_cursor(0))
    vim.api.nvim_buf_set_text(0, row - 1, col, row - 1, col, { text })
end

local function random_base62_string(len)
    local function randomc()
        local base62 = math.random(0, 61)

        if base62 < 10 then
            return string.char(string.byte("0") + base62)
        elseif base62 < 36 then
            return string.char(string.byte("a") + base62 - 10)
        else
            return string.char(string.byte("A") + base62 - 36)
        end
    end

    local buf = ""
    for i = 0, len do
        buf = buf .. randomc()
    end
    return buf
end

local function open_bacon(job)
    local win = vim.api.nvim_get_current_win()

    local cr = vim.api.nvim_replace_termcodes("<C-w>l", true, false, true)

    -- ohhhh yeah
    for i = 1, 5 do
        vim.api.nvim_feedkeys(cr, "i", true)
    end

    print(job)

    vim.cmd("botright vsplit")
    vim.cmd("terminal bacon --job " .. job)

    vim.schedule(function()
        vim.api.nvim_set_current_win(win)
    end)
end

local main = cmdbar.Menu({
    name = "actions",
    choices = {
        ["indent: change indentation style"] = change_indent,
        ["indent: change tab display size"] = change_tab_size,
        ["bacon: job..."] = cmdbar.Menu({
            name = "choose a job",
            choices = {
                ["clippy-all"] = cmdbar.Action(function()
                    open_bacon("clippy-all")
                end),
                ["doc"] = cmdbar.Action(function()
                    open_bacon("doc")
                end),
                ["ezfs"] = cmdbar.Action(function()
                    open_bacon("ezfs")
                end),
                ["storage"] = cmdbar.Action(function()
                    open_bacon("storage")
                end),
                ["hypervisor"] = cmdbar.Action(function()
                    open_bacon("hypervisor")
                end),
                ["coordinator"] = cmdbar.Action(function()
                    open_bacon("coordinator")
                end),
                [cmdbar.CATCHALL] = cmdbar.Action(function(name)
                    open_bacon("clippy-all")
                end),
            }
        }),
        ["lsp: rename item"] = cmdbar.Action(function()
            local buf = vim.lsp.buf
            if buf then
                buf.rename()
            end
        end),
        ["lsp: go to definition"] = cmdbar.Action(function()
            local buf = vim.lsp.buf
            if buf then
                buf.definition()
            end
        end),
        ["lsp: go to implementation"] = cmdbar.Action(function()
            local buf = vim.lsp.buf
            if buf then
                buf.implementation()
            end
        end),
        ["lsp: references"] = cmdbar.Action(function()
            local buf = vim.lsp.buf
            if buf then
                buf.references()
            end
        end),
        ["gen: random UUIDv4"] = cmdbar.Action(function()
            local function random_hex_str(len)
                local out = ""
                for i = 1, len do
                    out = out .. string.format("%x", math.random(0, 15))
                end
                return out
            end

            local variant = string.format("%x", 8 + math.random(0, 3))

            local group0 = random_hex_str(8)
            local group1 = random_hex_str(4)
            local group2 = "4" .. random_hex_str(3)
            local group3 = variant .. random_hex_str(3)
            local group4 = random_hex_str(12)

            local uuid = table.concat({ group0, group1, group2, group3, group4 }, "-")
            write_at_cursor(uuid)
        end),
        ["gen: random 32-char key"] = cmdbar.Action(function()
            write_at_cursor(random_base62_string(32))
        end),
        ["gen: random 64-char key"] = cmdbar.Action(function()
            write_at_cursor(random_base62_string(64))
        end),
    }
})

return {
    open = function(opts)
        main:find(opts)
    end,
}
