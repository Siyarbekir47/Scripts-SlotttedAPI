
cheat.register_module({
    champion_name = "Nilah",

    spell_q = function()
        local target = features.target_selector:get_default_target()
        local qHit = features.prediction:predict(target.index, 600, 0, 75, 0.25, g_local.position)
        if ((features.orbwalker:get_mode() == 1 or features.orbwalker:get_mode() == 4) and qHit.hitchance > 1.0) then
            g_input:cast_spell(e_spell_slot.q, qHit.position)
        end
    return flase
end,
  
    spell_w = function()

    return false
end,

get_priorities = function()
    return{
        "spell_q",
        "spell_w"
    }
end



})