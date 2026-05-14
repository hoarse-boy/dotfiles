local faah_config = {
    sound_path = os.getenv("HOME") .. "/.config/fish/sounds/assets_fahhh.wav",
    player = "paplay",  -- Using the same player as your terminal setup
    delay_ms = 50,      -- Delay after save before playing
    excluded_filetypes = {
        "help", "qf", "netrw", "NvimTree", "TelescopePrompt",
        "lazy", "mason", "null-ls-info", "oil", "neo-tree",
        "dashboard", "starter", "lspinfo", "checkhealth"
    }
}

local function play_sound()
    local cmd = string.format("%s %s > /dev/null 2>&1 & disown", 
        faah_config.player, 
        faah_config.sound_path)
    os.execute(cmd)
end

local function has_lsp_errors()
    local diags = vim.diagnostic.get(0)
    for _, diag in ipairs(diags) do
        if diag.severity == vim.diagnostic.severity.ERROR then
            return true
        end
    end
    return false
end

local function is_excluded_ft()
    local ft = vim.bo.filetype
    for _, excluded in ipairs(faah_config.excluded_filetypes) do
        if ft == excluded then return true end
    end
    return false
end

vim.api.nvim_create_autocmd("BufWritePost", {
    pattern = "*",
    callback = function()
        if not is_excluded_ft() and has_lsp_errors() then
            vim.defer_fn(play_sound, faah_config.delay_ms)
        end
    end,
})

vim.api.nvim_create_user_command("Faah", play_sound, {})
