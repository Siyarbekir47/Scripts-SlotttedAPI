
Script_name = "Utility"
local test_navigation = menu.get_main_window():push_navigation(Script_name, 10000)
local my_nav = menu.get_main_window():find_navigation(Script_name)
local utility_sect = my_nav:add_section("Utility Settings")




local draw_gank_alert = g_config:add_bool(true, "gank_in_draw")
local draw_gank_box = utility_sect:checkbox("Draw a Redline to enemys\n when about to gank", draw_gank_alert)


local draw_target_alert = g_config:add_bool(true, "target_in_draw")
local draw_target_box = utility_sect:checkbox("Draw a Blueline, to current\n selected Target from TS", draw_target_alert)


draw_gank_box:set_value(true)
draw_target_box:set_value(true)


cheat.register_callback("render", function()
    local enemy_list = features.entity_list:get_enemies()
    local i = 1
    local to_close = 1000
    local target = features.target_selector:get_default_target()

    if(draw_gank_box:get_value()) then

        for i, obj_hero in ipairs(enemy_list) do
            if(obj_hero:dist_to_local() > to_close) then
                g_render:line(g_local.position:to_screen(), obj_hero.position:to_screen(), color:new(255,0,0),5)
            end
            
        end

    end

    if(draw_target_box:get_value()) then
        g_render:line(g_local.position:to_screen(), target.position:to_screen(), color:new(0,0,255), 5)
    end
end)