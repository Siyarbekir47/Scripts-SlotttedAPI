local spell_q_width = 210/2
local spell_q_speed = 1550
local spell_q_range = 1025

local spell_e_range = 670






g_last_e_time = g_time

g_last_e_time = g_time
g_last_q_time = g_time



cheat.register_module({
    champion_name = "Quinn",

    spell_q = function()
        local target = features.target_selector:get_default_target()
        if(target == nil) then
            return false
        end

        local qHit = features.prediction:predict(target.index, spell_q_range, spell_q_speed, spell_q_width, 0.25, g_local.position)
        local badMinion = features.prediction:minion_in_line(g_local.position, qHit.position, spell_q_width, -1) --check minion in line 
        local slot_spell_q = g_local:get_spell_book():get_spell_slot(0)


        
        if(features.orbwalker:is_in_attack() or features.evade:is_active()) then
            return false
        end

        if ((features.orbwalker:get_mode() == 1 and features.orbwalker:should_reset_aa() and qHit.hitchance > 1.0 and badMinion == false and slot_spell_q:is_ready()) or (features.orbwalker:get_mode() == 1 and target:dist_to_local() > g_local.attack_range and qHit.hitchance > 1.0 and badMinion == false and slot_spell_q:is_ready())) then
            g_input:cast_spell(e_spell_slot.q, qHit.position)
            features.orbwalker:reset_aa_timer()
        end
    return false
end,
  
    spell_e = function()
        local target = features.target_selector:get_default_target()
        local slot_spell_e = g_local:get_spell_book():get_spell_slot(2)

        if(target == nil) then
            return false
        end
        
        if(features.orbwalker:is_in_attack() or features.evade:is_active()) then
            return false
        end

        if (features.orbwalker:get_mode() == 1 and features.orbwalker:should_reset_aa() and slot_spell_e:is_ready() and target:dist_to_local() < spell_e_range) then
            g_input:cast_spell(e_spell_slot.e, target.network_id)
            features.orbwalker:reset_aa_timer()
        end
    return false
    end,

get_priorities = function()
    return{
        "spell_q",
        "spell_e"
    }
end



})