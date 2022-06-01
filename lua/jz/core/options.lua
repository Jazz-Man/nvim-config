local options = {}


local bind_option = function(opts)
    for k, v in pairs(opts) do
        if v == true then
            vim.api.nvim_command('set ' .. k)
        elseif v == false then
            vim.api.nvim_command('set no' .. k)
        else
            vim.api.nvim_command('set ' .. k .. '=' .. v)
        end
    end
end

options.setup = function()
    for group, confs in pairs(options.configuration) do
        if group ~= 'cmds' then
            bind_option(confs)
        else
            for _, cmd in ipairs(confs) do
                vim.api.nvim_command(cmd)
            end
        end
    end
end

return options