local spell_q_width = 0
local spell_q_speed = 0
local spell_q_range = 450

local sylas_aa_range = 0


local spell_w_width = 250/2
local spell_w_speed = 800
local spell_w_range = 500


local spell_e_width = 120/2
local spell_e_speed = 1000
local spell_e_range = 700

local spell_e_global_range = 10000

g_last_e_time = 0
g_last_q_time = 0
g_last_w_time = 0

i = 0


--Menu start

Script_name = "Creepy Lilia 0.01"
local test_navigation = menu.get_main_window():push_navigation(Script_name, 10000)
local my_nav = menu.get_main_window():find_navigation(Script_name)
local combo_sect = my_nav:add_section("Combo Settings")
local harras_sect = my_nav:add_section("Harras Section")


-- Q Settings 


local combo_q_config = g_config:add_bool(true, "Q_in_combo")
local combo_q_box = combo_sect:checkbox("Use Q", combo_q_config)

local harras_q_config = g_config:add_bool(true, "Q_in_Harras")
local harras_q_box = harras_sect:checkbox("Use Q in Harras", harras_q_config)

-- W Settings
local combo_w_config = g_config:add_bool(true, "W_in_combo")
local combo_w_box = combo_sect:checkbox("Use W", combo_w_config)



-- E Settings

local combo_e_config = g_config:add_bool(true, "E_in_combo")
local combo_e_box = combo_sect:checkbox("Use E", combo_e_config)


--E2 Settings

local combo_e2_config = g_config:add_bool(true, "E2_in_combo")
local combo_e2_box = combo_sect:checkbox("Use E2", combo_e2_config)


combo_q_box:set_value(true)
combo_w_box:set_value(true)
combo_e_box:set_value(true)
combo_e2_box:set_value(true)
harras_q_box:set_value(true)

-- Menu end



cheat.register_module({
    champion_name = "Lillia",

    spell_q = function()


        local slot_spell_q = g_local:get_spell_book():get_spell_slot(0)


        local target = features.target_selector:get_default_target()
        if(target == nil) then
            return false
        end

        if(features.orbwalker:is_in_attack() or features.evade:is_active()) then
            return false
        end

        if (features.orbwalker:get_mode() == 1 and target:dist_to_local() < spell_q_range and g_time - g_last_q_time > 0.35 and slot_spell_q:is_ready()) then
            g_input:cast_spell(e_spell_slot.q)
            g_last_q_time = g_time
        end

            
        
    return false
end,

    spell_w = function()
        local slot_spell_w = g_local:get_spell_book():get_spell_slot(1)


        local target = features.target_selector:get_default_target()
        if(target == nil) then
            return false
        end

        if(features.orbwalker:is_in_attack() or features.evade:is_active()) then
            return false
        end

        local wHit = features.prediction:predict(target.index, spell_w_range, spell_w_speed, spell_w_width, 0.25, g_local.position )

        if (features.orbwalker:get_mode() == 1 and target:dist_to_local() < spell_w_range and g_time - g_last_q_time > 0.35 and wHit.hitchance > 1 and slot_spell_w:is_ready()) then
            g_input:cast_spell(e_spell_slot.w, wHit.position)
            g_last_w_time = g_time
        end

        

        return false
    end,

    spell_e = function()

        local slot_spell_e = g_local:get_spell_book():get_spell_slot(2)
        local target = features.target_selector:get_default_target()
        if(target == nil) then
            return false
        end
        if(features.orbwalker:is_in_attack() or features.evade:is_active()) then
            return false
        end

        local eHit = features.prediction:predict(target.index, spell_e_range, spell_e_speed, spell_e_width, 0.40, g_local.position )


        if (features.orbwalker:get_mode() == 1 and target:dist_to_local() < spell_e_range+300 and g_time - g_last_q_time > 0.35 and eHit.hitchance > 1 and slot_spell_e:is_ready()) then
            g_input:cast_spell(e_spell_slot.e, eHit.position)
            g_last_w_time = g_time
        end

        
        return false
    end,





get_priorities = function()
    return{
        "spell_q",
        "spell_w",
        "spell_e"
    }
end



})

--[[
 bool wall_found{};
                float distance_to_wall{};

                // see if wall is in e trajectory
                for(int i = 1; i <= 31; i++)
                {
                    vec3 temp = g_local->position.extend(pred.position, 25.f * i);
                    if (!g_navgrid->is_wall(temp)) continue;

                    wall_found = true;
                    distance_to_wall = 25.f * i;
                    break;
                }






                local_position.extend(target_position, target_position.dist_to(g_local.position) + 50.f)
]]--

