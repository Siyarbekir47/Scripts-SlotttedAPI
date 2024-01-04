--config variables and creating the menu
local test_navigation = menu.get_main_window():push_navigation("Mordekaiser", 10000)
local qConfig = g_config:add_bool(true, "Use_Q")
local qDrawConfig = g_config:add_bool(true, "Draw_Q")
local wConfig = g_config:add_bool(true, "Use_W")
local eConfig = g_config:add_bool(true, "Use_E")
local eDrawConfig = g_config:add_bool(true, "Draw_E")
local rDrawConfig = g_config:add_bool(true, "Draw_R")
local mordNav = menu.get_main_window():find_navigation("Mordekaiser")
local QSect = mordNav:add_section("Spell Q settings")
local WSect = mordNav:add_section("Spell W settings")
local shield_config = g_config:add_int(0, "Shield Percent")
local ESect = mordNav:add_section("Spell E settings")
local RSect = mordNav:add_section("Spell R settings")

--adding menu components
local WsliderGauge = WSect:slider_int("%HP to use shield", shield_config, 0, 100, 1)
local checkboxq = QSect:checkbox("Use Q", qConfig)
local checkboxDrawQ = QSect:checkbox("Draw Q Range", qDrawConfig)
local checkboxw = WSect:checkbox("Use W", wConfig)
local checkboxe = ESect:checkbox("Use E", eConfig)
local checkboxDrawE = ESect:checkbox("Draw E Range", eDrawConfig)
local checkboxDrawR = RSect:checkbox("Draw R Range", rDrawConfig)
checkboxq:set_value(true)
checkboxDrawQ:set_value(true)
checkboxw:set_value(true)
checkboxe:set_value(true)
checkboxDrawE:set_value(true)
checkboxDrawR:set_value(true)
--get W buff name
--W buff name is MordekaiserW
function getWbuff()
  local buffs = features.buff_cache:get_all_buffs(g_local.index)
  for i, buff in ipairs(buffs) do
    if(buff.name == "MordekaiserWPassive") then
      print(buff:get_stacks())
    end
    
    print(buff.name)
  end
end

--draw Cirlce of Q range
cheat.register_callback("render", function()
    if checkboxDrawQ:get_value() then
      q_range = 625
      white = color:new(255, 255, 255)
      g_render:circle_3d(g_local.position, white, q_range, 2, 100, 2)
    end
  end)
--draw Circle of E Range
cheat.register_callback("render", function()
    if checkboxDrawE:get_value() then
      e_range = 700
      red = color:new(255, 0, 0)
      g_render:circle_3d(g_local.position, red, e_range, 2, 100, 2)
    end
  end)
--Draw Cricle of R Range
cheat.register_callback("render", function()
    if checkboxDrawR:get_value() then
      r_range = 650
      blue = color:new(0, 0, 255)
      g_render:circle_3d(g_local.position, blue, r_range, 2, 100, 2)
    end
  end)

cheat.register_module({
    champion_name = "Mordekaiser",
    spell_q = function()
      local target = features.target_selector:get_default_target()
      if target ~= nil then
        local qHit = features.prediction:predict(target.index, 625, 0, 80, 0.5, g_local.position)
        local badTarget = features.target_selector:is_bad_target(target.index)
        if (g_local:get_spell_book():get_spell_slot(e_spell_slot.q):is_ready() and badTarget ~= true and qHit.hitchance > 2 and (features.orbwalker:get_mode() == 1 or features.orbwalker:get_mode() == 4) and checkboxq:get_value()) then
          g_input:cast_spell(e_spell_slot.q, qHit.position)
          return feauters.orbwalker:set_cast_time(0.5)
        end
        
      end
      return false
    end,
  
    spell_w = function()
      --getWbuff()
      print(g_local.mana)
      local buffs = features.buff_cache:get_all_buffs(g_local.index)
      local percentHP = WsliderGauge:get_value() / 100
      if g_local.health < (g_local.max_health * percentHP) and g_local:get_spell_book():get_spell_slot(e_spell_slot.w):is_ready() and g_local.mana > 500 then
        for i, buff in ipairs(buffs) do
          if (buff.name == "MordekaiserW") then
            return false
          end
        end
        g_input:cast_spell(e_spell_slot.w)
      end
    end,
    spell_e = function()
      local target = features.target_selector:get_default_target()
      if target ~= nil then
        local eHit = features.prediction:predict(target.index, 700, 3000, 100, 0.25, g_local.position)
        local badTarget = features.target_selector:is_bad_target(target.index)
        if (g_local:get_spell_book():get_spell_slot(e_spell_slot.e):is_ready() and badTarget ~= true and eHit.hitchance > 1 and (features.orbwalker:get_mode() == 1 or features.orbwalker:get_mode() == 4) and checkboxe:get_value()) then
          g_input:cast_spell(e_spell_slot.e, eHit.position)
          return feauters.orbwalker:set_cast_time(0.25)
        end
        
      end
      return false
    end,
    
initialize = function()
        print("initializing module")
        -- setup menu here
    end,
    get_priorities = function()
      return{
        "spell_q",
        "spell_e",
        "spell_w"
      }
    end
    
    })
