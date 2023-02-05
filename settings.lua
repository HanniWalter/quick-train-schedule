data:extend(
{
    {
        name = "fts-language-setting",
        type = "string-setting",
        setting_type = "runtime-global",
        allowed_values = {"host", "internal", "player"},
        default_value = "host"
    },{
        name = "fts-enable-refueling-setting",
        type = "bool-setting",
        setting_type = "runtime-global",
        default_value = true
    },{
        name = "fts-show-not-found-setting",
        type = "bool-setting",
        setting_type = "runtime-global",
        default_value = true
    },{
        name = "fts-allow-longer-trains-setting",
        type = "bool-setting",
        setting_type = "runtime-global",
        default_value = false
    },{
        name = "fts-allow-shorter-trains-setting",
        type = "bool-setting",
        setting_type = "runtime-global",
        default_value = true
    },{
        name = "fts-refuel-refresh-time-setting",
        type = "int-setting",
        setting_type = "runtime-global",
        default_value = 120
    },{
        name = "fts-refuel-refresh-time-offset-setting",
        type = "int-setting",
        setting_type = "runtime-global",
        default_value = 113
    }
})
