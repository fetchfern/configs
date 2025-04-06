local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local conf = require("telescope.config").values
local telescope_actions = require("telescope.actions")
local action_state = require("telescope.actions.state")
local taber = require("taber")

local TYPE = newproxy(true)

local mt = getmetatable(TYPE)
mt.__index = {
    get = function(obj)
        local t = type(obj)
        return t == "table" and obj[TYPE] or t
    end,
}

local function keys(t)
    local out = {}
    local i = 1
    for k, _ in pairs(t) do
        out[i] = k
        i = i + 1
    end
    return out
end

local function filter(t, c)
    local out = {}
    local offset = 0
    for i, v in ipairs(t) do
        if v == c then
            offset = offset + 1
        else
            out[i - offset] = v
        end
    end
    return out
end

local function type_check(value, ty)
    local got_ty = type(value)
    if got_ty == ty then
        return value
    else
        error(string.format("bad argument at '%s': expected %s, got %s", debug.getinfo(2), ty, got_ty), 2)
    end
end

local cmdbar = { Menu = {}, Action = {} }
setmetatable(cmdbar.Menu, cmdbar.Menu)
setmetatable(cmdbar.Action, cmdbar.Action)

function cmdbar.Menu:__call(opts)
    return setmetatable({
        choices = type_check(opts.choices, "table"),
        name = type_check(opts.name, "string"),
        [TYPE] = "Menu",
    }, { __index = self })
end

function cmdbar.Menu:find(opts)
    local actions = keys(self.choices)
    local actions_wo_catchall = filter(actions, cmdbar.CATCHALL)

    local picker = pickers.new(opts, {
        prompt_title = self.name,
        finder = finders.new_table({ results = actions_wo_catchall }),
        sorter = conf.generic_sorter(opts),
        attach_mappings = function(bufnr, map)
            telescope_actions.select_default:replace(function()
                telescope_actions.close(bufnr)
                local selection = action_state.get_selected_entry()

                print(vim.inspect(selection))

                local action = nil
                if selection == nil then
                    action = self.choices[cmdbar.CATCHALL]
                else
                    action = self.choices[actions_wo_catchall[selection.index]]
                end

                if action == nil then
                    action = self.choices[cmdbar.CATCHALL]
                end

                if action == nil then
                    return
                end

                local ty = TYPE.get(action)

                if ty == "Menu" then
                    action:find()
                elseif ty == "Action" then
                    action:run(selection and selection.value.name or "")
                else
                    error(string.format("unexpected action type %s", ty))
                end
            end)

            return true
        end,
    })

    picker:find(opts)
end

function cmdbar.Action:__call(fn)
    return setmetatable({
        fn = fn,
        [TYPE] = "Action",
    }, {
        __index = self,
    })
end

function cmdbar.Action:run(...)
    self.fn(...)
end

cmdbar.CATCHALL = "---CMDBAR--INTERNAL-CATCHALL"

return cmdbar

