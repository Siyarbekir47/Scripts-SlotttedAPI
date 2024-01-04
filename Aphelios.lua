g_last_w_time = g_time
cheat.register_module({
    champion_name = "Aphelios",

    spell_q = function()
        local spell_slot_q = g_local:get_spell_book():get_spell_slot(0)
        local spell_slot_e = g_local:get_spell_book():get_spell_slot(2)
        
        local spell_slot_w = g_local:get_spell_book():get_spell_slot(1)

        print(spell_slot_q:get_name())
        print(spell_slot_w:get_name())

        local target = features.target_selector:get_default_target()
        local qHit = features.prediction:predict(target.index, 1450, 1850, 60, 0.4, g_local.position) --projectile
        local badMinion = features.prediction:minion_in_line(g_local.position, qHit.position, 60, -1) --check minion in line 
        if (features.orbwalker:get_mode() == 1) then
        --projectile
            if ((badMinion == false) and (qHit.hitchance > 1.0)) then
                return g_input:cast_spell(e_spell_slot.q, qHit.position)
            end
        
        end

        return false
    end,


get_priorities = function()
    return{
        "spell_q"

    }
end



})