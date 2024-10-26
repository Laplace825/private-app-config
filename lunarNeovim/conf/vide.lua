-- judge if now is running neovide
if not vim.g.neovide then
    return {}
else
    lvim.colorscheme = "onedark"
    --透明度
    vim.g.neovide_transparency = 0.9

    -- 非垂直同步 --no-vsync 时的刷新率
    vim.g.neovide_refresh_rate = 144
    vim.g.neovide_refresh_rate_idle = 3 -- 闲置刷新率
    -- vim.g.neovide_profiler = true

    -- cursor特效
    vim.g.neovide_cursor_vfx_mode = "railgun"
    vim.g.neovide_cursor_vfx_particle_density = 80.0
    vim.g.neovide_scale_factor = 1.1
    vim.g.neovide_cursor_vfx_particle_phase = 1.5
    -- vim.g.neovide_cursor_vfx_mode = "pixiedust"
    vim.g.neovide_cursor_smooth_blink = true

    -- 抗锯齿
    vim.g.neovide_cursor_antialiasing = true
end
