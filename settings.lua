data:extend(
{
    {
        name = "qts_language_setting",
        type = "string-setting",
        setting_type = "runtime-global",
        allowed_values = {"qts_host", "qts_internal", "qts_player"},
        default_value = "qts_internal"
    },{
        name = "qts_enable_refueling_setting",
        type = "bool-setting",
        setting_type = "runtime-global",
        default_value = true
    },{
        name = "qts_show_not_found_setting",
        type = "bool-setting",
        setting_type = "runtime-global",
        default_value = true
    },{
        name = "qts_allow_longer_trains_setting",
        type = "bool-setting",
        setting_type = "runtime-global",
        default_value = false
    },{
        name = "qts_allow_shorter_trains_setting",
        type = "bool-setting",
        setting_type = "runtime-global",
        default_value = true
    },{
        name = "qts_refuel_refresh_time_setting",
        type = "int-setting",
        setting_type = "runtime-global",
        default_value = 120
    },{
        name = "qts_refuel_refresh_time_offset_setting",
        type = "int-setting",
        setting_type = "runtime-global",
        default_value = 113
    }
})
