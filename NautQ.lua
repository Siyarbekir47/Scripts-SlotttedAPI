cheat.register_module({
    champion_name = "Nautilus",
    spell_q = function()
      local target = features.target_selector:get_default_target()
      local qHit = features.prediction:predict(target.index, 1122, 2000, 90, 0.25, g_local.position) --projectile
      local badMinion = features.prediction:minion_in_line(g_local.position, qHit.position, 90, -1) --check minion in line 
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