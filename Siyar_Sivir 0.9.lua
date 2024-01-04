
cheat.register_module({
    champion_name = "Sivir",

    spell_q = function()
        local target = features.target_selector:get_default_target()
        if(target == nil) then
            return false
        end
        if(features.orbwalker:is_in_attack() or features.evade:is_active()) then
            return false
        end
        local qHit = features.prediction:predict(target.index, 1210, 1350, 75, 0.25, g_local.position)
        if (features.orbwalker:get_mode() == 1 or features.orbwalker:get_mode() == 4) then
            if ((qHit.hitchance > 0.0) and (features.orbwalker:should_reset_aa()) or (qHit.hitchance > 1.0) and (g_local.attack_range < target:dist_to_local()) ) then
                g_input:cast_spell(e_spell_slot.q, qHit.position)  
            end

        end
    return flase
end,
  
    spell_w = function()
        if(features.orbwalker:is_in_attack() or features.evade:is_active()) then
            return false
        end
        if (features.orbwalker:get_mode() == 1 and features.orbwalker:should_reset_aa()) then
            g_input:cast_spell(e_spell_slot.w)
            features.orbwalker:reset_aa_timer()
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