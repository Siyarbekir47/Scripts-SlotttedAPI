--Menu
Script_name = "Twisted Fate"
local test_navigation = menu.get_main_window():push_navigation(Script_name, 10000)
local my_nav = menu.get_main_window():find_navigation(Script_name)
local combo_sect = my_nav:add_section("Combo Settings")
local harras_sect = my_nav:add_section("Harras Section")
local info_sect = my_nav:add_section("--- Info ---\n--- Press -E- for Goldcard\n Press -T- for Redcard\n Press -Y- for Bluecard")
local draw_sect = my_nav:add_section("Drawings Section")



local draw_q_config = g_config:add_bool(true, "Q_in_draw")
local draw_q_box = draw_sect:checkbox("Draw Q when ready", draw_q_config)


local combo_q_config = g_config:add_bool(true, "Q_in_combo")
local combo_q_box = combo_sect:checkbox("Use Q", combo_q_config)

local harras_q_config = g_config:add_bool(true, "Q_in_Harras")
local harras_q_box = harras_sect:checkbox("Use Q in Harras", harras_q_config)


local combo_w_config = g_config:add_bool(true, "W_in_combo")
local combo_w_box = combo_sect:checkbox("Use W - Goldcard", combo_w_config)

local harras_w_config = g_config:add_bool(true, "W_in_Harras")
local harras_w_box = harras_sect:checkbox("Use W - Bluecard", harras_w_config)


combo_q_box:set_value(true)
combo_w_box:set_value(true)
harras_q_box:set_value(true)
harras_w_box:set_value(true)
draw_q_box:set_value(true)

-- Menu end

b_gold = false
b_red = false
b_blue = false
g_last_w_time = g_time

cheat.register_module({
    champion_name = "TwistedFate",
    spell_q = function()
        local q_range = 1450
        local q_speed = 1000
        local q_width = 80/2
        local target = features.target_selector:get_default_target()
        local qHit = features.prediction:predict(target.index, q_range, q_speed, q_width, 0.25, g_local.position) --projectile


        if ((features.orbwalker:get_mode() == 1 and combo_q_box:get_value()) or (features.orbwalker:get_mode() == 4 and harras_q_box:get_value())) then
            if ((qHit.hitchance > 1.0)) then
                g_input:cast_spell(e_spell_slot.q, qHit.position)  
            end

        end
    
      return false
    end,

    spell_w = function()

        local name_spell_e = g_local:get_spell_book():get_spell_slot(1):get_name()
        local target = features.target_selector:get_default_target()
        -- Auto Gold if in AA range for Combo mode

        if((features.orbwalker:get_mode() == 1) and (g_local.attack_range+150 > target:dist_to_local()) and (combo_w_box:get_value()) and (g_time - g_last_w_time > 0.35)) then
            if(name_spell_e == "PickACard") then
                g_input:cast_spell(e_spell_slot.w)
                g_last_w_time = g_time
                b_gold = true
        
            end
        end

        if((features.orbwalker:get_mode() == 4) and (g_local.attack_range+150 > target:dist_to_local()) and (combo_w_box:get_value()) and (g_time - g_last_w_time > 0.35)) then
            if(name_spell_e == "PickACard") then
                b_blue = true
                g_input:cast_spell(e_spell_slot.w)
                g_last_w_time = g_time
        
            end
        end


        -- Press E to set bool for goldcard
		if ((g_input:is_key_pressed(69)) and (g_time - g_last_w_time > 0.35)) then
            if ((name_spell_e == "PickACard") ) then
                g_input:cast_spell(e_spell_slot.w)
                b_gold = true
                g_last_w_time = g_time
    
            end
        end

        -- Press T to set bool for Redcard
		if ((g_input:is_key_pressed(84)) and (g_time - g_last_w_time > 0.35)) then
            if ((name_spell_e == "PickACard") ) then
                g_input:cast_spell(e_spell_slot.w)
                b_red = true
                g_last_w_time = g_time
    
            end
        end

        -- Press Y to set bool for bluecard
		if ((g_input:is_key_pressed(89)) and (g_time - g_last_w_time > 0.35)) then
            if ((name_spell_e == "PickACard") ) then
                g_input:cast_spell(e_spell_slot.w)
                b_blue = true
                g_last_w_time = g_time
            end
        end


        -- getting Spellname and setting boolean back to false
        if ((b_red == true) and (name_spell_e == "RedCardLock") and (g_time - g_last_w_time > 0.35) and (g_input:cast_spell(e_spell_slot.w))) then
            g_input:cast_spell(e_spell_slot.w)
            g_last_w_time = g_time
            b_red = false
        end


        -- getting Spellname and setting boolean back to false

        if ((b_blue == true) and (name_spell_e == "BlueCardLock") and (g_time - g_last_w_time > 0.35) and (g_input:cast_spell(e_spell_slot.w))) then
            b_blue = false
            g_last_w_time = g_time
        end


        -- getting Spellname and setting boolean back to false
        if ((b_gold == true) and (name_spell_e == "GoldCardLock") and (g_time - g_last_w_time > 0.35) and (g_input:cast_spell(e_spell_slot.w))) then
            b_gold = false
            g_last_w_time = g_time
        end


        return false
    end,
    get_priorities = function()
      return{
        "spell_q",
        "spell_w"
      }
    end
    
    })


    cheat.register_callback("render", function()
        local is_ready = g_local:get_spell_book():get_spell_slot(0):is_ready()

        local q_range = 1430
        
        if(is_ready and draw_q_box:get_value()) then
            g_render:circle_3d(g_local.position, color:new(0,0,255), q_range, 22, 100, 3)
        end
        
        
    end)