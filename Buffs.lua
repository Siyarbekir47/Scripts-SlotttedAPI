local spell_q_range = 800
local spell_q_speed = 0
local spell_q_width = 50

cheat.register_module({
    champion_name = "Urgot",


    spell_q = function()

        --standard checks
        local target = features.target_selector:get_default_target()
        if(target == nil) then
            return false
        end
        if(features.orbwalker:is_in_attack() or features.evade:is_active()) then
            return false
        end

        
        --predic calc and cast_spell
        local qHit = features.prediction:predict(target.index, spell_q_range, spell_q_speed, spell_q_width, 0.4, g_local.position)
        if(features.orbwalker:get_mode() == 1 and qHit.hitchance > 1.0 and (target:dist_to_local() > g_local.attack_range or features.orbwalker:should_reset_aa())) then
            g_input:cast_spell(e_spell_slot.q, qHit.position)

        end
        --idk maybe do fancy stuff 360


    return false
end,
  

get_priorities = function()
    return{
        "spell_q",
        "spell_e"
    }
end



})