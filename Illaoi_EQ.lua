cheat.register_module({
    champion_name = "Illaoi",
    spell_e = function()
      local target = features.target_selector:get_default_target()
      local eHit = features.prediction:predict(target.index, 950, 1900, 50, 0.25, g_local.position) --projectile
      local badMinion = features.prediction:minion_in_line(g_local.position, eHit.position, 50, -1) --check minion in line 
      if (features.orbwalker:get_mode() == 1) then
        --projectile
        if ((badMinion == false) and (eHit.hitchance > 1.0)) then
          return g_input:cast_spell(e_spell_slot.e, eHit.position)
        end
        
      end
      return false
    end,
    spell_q = function()
      local target = features.target_selector:get_default_target()
      local qHit = features.prediction:predict(target.index, 850, 0, 50, 0.75, g_local.position) --projectile
      if (features.orbwalker:get_mode() == 4) then
        --projectile
        if ((qHit.hitchance > 1.0)) then
          return g_input:cast_spell(e_spell_slot.q, qHit.position)
        end
        
      end
      return true
    end,
    get_priorities = function()
      return{
        "spell_e",
        "spell_q"
      }
    end
    
    })