-----------------------------------------------------------
-- Neovim API aliases
-----------------------------------------------------------
local api = vim.api
local bo = vim.bo
local cmd = vim.cmd
local fn = vim.fn
local wo = vim.wo

-----------------------------------------------------------
-- Functions
-----------------------------------------------------------
function AltCommand(command)
    local path = fn.expand('%')
    local alternate = vim.fn.system("alt " .. path)
    if alternate == nil or alternate == '' then
        local msg = 'No alternate file for ' .. path .. ' exists!'
        cmd('echo "' .. msg .. '"')
    else
        cmd(command .. " " .. alternate)
    end
end

function SetupMarkdown()
    bo.suffixesadd = '.md'
    wo.spell = true
    wo.wrap = true
end

function StripTrailingWhiteSpace()
    -- Ignore for markdown and slim
    if bo.filetype == 'markdown' or bo.filetype == 'slim' then
      return
    end
    cmd [[%s/\s\+$//e]]
end

-----------------------------------------------------------
-- Abbreviations
-----------------------------------------------------------
cmd [[cnoreabbrev bo BufOnly]]                               -- Alias bo to BufOnly
cmd [[command AE lua AltCommand('edit')]]                    -- Open alternate file
cmd [[command AS lua AltCommand('split')]]                   -- Open alternate file in split
cmd [[command AV lua AltCommand('vsplit')]]                  -- Open alternate file in vertical split
cmd [[command AT lua AltCommand('tabnew')]]                  -- Open alternate file in new tab

-----------------------------------------------------------
-- Hooks
-----------------------------------------------------------
cmd [[autocmd BufEnter,FocusGained * set relativenumber]]    -- Enable relative number of focus
cmd [[autocmd BufLeave,FocusLost * set norelativenumber]]    -- Disable relative numbers on blur
cmd [[autocmd BufWritePre * lua StripTrailingWhiteSpace()]]  -- Strip trailing whitespaces on save
cmd [[autocmd InsertLeave * set nopaste]]                    -- Disable paste mode on leaving insert mode

-----------------------------------------------------------
-- Syntax
-----------------------------------------------------------
cmd [[autocmd Filetype gitcommit setl spell textwidth=72]]
cmd [[autocmd Filetype go setl softtabstop=4 shiftwidth=4 noexpandtab]]
cmd [[autocmd Filetype markdown lua SetupMarkdown()]]
