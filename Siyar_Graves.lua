local spell_q_range = 800
local spell_q_speed = 0
local spell_q_width = 50

cheat.register_module({
    champion_name = "Graves",


    spell_q = function()

        local target = features.target_selector:get_default_target()
        if(target == nil) then
            return false
        end
        
        if(features.orbwalker:is_in_attack() or features.evade:is_active()) then
            return false
        end
        local qHit = features.prediction:predict(target.index, spell_q_range, spell_q_speed, spell_q_width, 0.4, g_local.position)
        if(features.orbwalker:get_mode() == 1 and qHit.hitchance > 1.0) then
            g_input:cast_spell(e_spell_slot.q, qHit.position)

        end


    return false
end,
  

get_priorities = function()
    return{
        "spell_q"
    }
end



})