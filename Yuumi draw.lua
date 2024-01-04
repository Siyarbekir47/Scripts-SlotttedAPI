cheat.register_callback("render", function()
    local q_is_ready = g_local:get_spell_book():get_spell_slot(0):is_ready()
    local w_is_ready = g_local:get_spell_book():get_spell_slot(1):is_ready()
    local r_is_ready = g_local:get_spell_book():get_spell_slot(3):is_ready()

    local q_range = 1130
    local w_range = 690
    local r_range = 1090
    
    if(q_is_ready) then
        g_render:circle_3d(g_local.position, color:new(0,0,255), q_range, 22, 100, 3)
    end
    if(w_is_ready) then
        g_render:circle_3d(g_local.position, color:new(0,255,255), w_range, 22, 100, 3)
    end
    if(r_is_ready) then
        g_render:circle_3d(g_local.position, color:new(255,255,0), r_range, 22, 100, 3)
    end
    
    
end)