

function getDistance(from,to)
    return from:dist_to(to)
end

function updateCastTime(ability_time)
    ability_time = g_time
    m_last_cast_time = g_time
end
                            
local script_name = "BeardedRengar"
local add_navigation = menu.get_main_window():push_navigation(script_name, 10000)
local navigation = menu.get_main_window():find_navigation(script_name)
local combo_section = navigation:add_section("Combo settings")
local other_section = navigation:add_section("Other settings")

local q_to_burg_config = g_config:add_bool(false, "q_to_burg_config")
local q_leap_config = g_config:add_bool(false, "q_leap_config")

local w_to_heal_config = g_config:add_bool(false, "w_to_heal_config")
local w_heal_perc_config = g_config:add_int(0, "w_heal_perc_config")

local e_to_slow_slight_config = g_config:add_bool(false, "e_to_slow_slight_config")
local e_to_cc_config = g_config:add_bool(false, "e_to_cc_config")
local e_leap_config = g_config:add_bool(false, "e_leap_config")

local q_combo_box = combo_section:checkbox("Use Q in combo", q_to_burg_config)
local q_leap_combo_box = combo_section:checkbox("Use Q while leaping", q_leap_config)

local w_combo_box = other_section:checkbox("Autoheal with W", w_to_heal_config)
local w_heal_percentage_box = other_section:slider_int("Min auto heal %HP", w_heal_perc_config,  0  , 100  ,  1)

local e_slow_box = combo_section:checkbox("Use E to slow out of AA", e_to_slow_slight_config)
local e_cc_box = combo_section:checkbox("Use E to CC far out of AA", e_to_cc_config)
local e_leap_box = combo_section:checkbox("Use E while leaping", e_leap_config)

-- Q settings
q_combo_box:set_value(true)
q_leap_combo_box:set_value(true)

-- W settings
w_combo_box:set_value(true)
w_heal_percentage_box:set_value(5)   

-- E settings
e_slow_box:set_value(true)
e_cc_box:set_value(true)
e_leap_box:set_value(true)


Combo_key = 1
Clear_key = 3
Harass_key = 4
e_range, e_speed, e_width = 1000, 1500, 140
e_windup = 0.25
                            
m_last_q_time = -2
m_last_w_time = -2
m_last_e_time = -2
m_last_r_time = -2
m_last_cast_time = -2                            
                            
                            
                            
mySpells = {
    q = {
        lastCast = 0,
        manaCost = {0 , 0 , 0 , 0 , 0},
        spell = g_local:get_spell_book():get_spell_slot(e_spell_slot.q),
        spellSlot = e_spell_slot.q,
        Range = 160,
        Level = 0,
        Base = {10, 35, 60, 85, 110},
        CastTime = 0,
    },
                                
    w = {
        lastCast = 0,
        manaCost = {0, 0, 0, 0, 0 },
        spell = g_local:get_spell_book():get_spell_slot(e_spell_slot.w),
        spellSlot = e_spell_slot.w,
        Width = 450,
        Speed = 2500,
        Level = 0,
        CastTime = 0,
    },
        e = {
        lastCast = 0,
        manaCost = {0, 0, 0, 0, 0 },
        spell = g_local:get_spell_book():get_spell_slot(e_spell_slot.e),
        spellSlot = e_spell_slot.e,
        Range = 1000,
        Width = 140,
        Speed = 1500,
        Level = 0,
        CastTime = 0.25,
    },
        r = {
        lastCast = 0,
        manaCost = {100, 100, 100},
        spell = g_local:get_spell_book():get_spell_slot(e_spell_slot.r),
        spellSlot = e_spell_slot.r,
        Range =  1200,
        Radius = 175,
        Radius2 = 325,
        Speed = 1300,
        Level = 0,
        CastTime = 0.25,
    }
}
                            
function mySpells:predPosition(spell,target)
    local pred = features.prediction:predict(target.index, self[spell].Range, self[spell].Speed, self[spell].Width, self[spell].CastTime, g_local.position)
    return pred
end
                            
function mySpells:isSpellReady(spell)
    if self[spell].spell:is_ready() then
        return true
    else
        return false
    end
end
                            
function mySpells:getNameOfSpell(spell)
    return self[spell].spell:get_name()
end
                            
-- Asserts that target ~= nil
function castQAndAATarget(target)
    if (g_time - m_last_q_time >= 0.4 or g_time - m_last_cast_time > 0.3) then
        m_last_q_time = g_time
        m_last_cast_time = g_time
        if features.orbwalker:should_reset_aa() then
            g_input:cast_spell(e_spell_slot.q)
        elseif (not features.orbwalker:is_in_attack()) and g_local.attack_range > 400 then
            g_input:cast_spell(e_spell_slot.q)
        end
    end
end                            
                            
function mySpells:qSpell()
    local mode = features.orbwalker:get_mode()
    local target = features.target_selector:get_default_target()
    -- RengarQ buff signaling rengar has pressed q
    local qIsPressed = features.buff_cache:get_buff(g_local.index, "RengarQ")
    local shouldUseQ = q_combo_box:get_value()
    if not shouldUseQ then return false end
    if target == nil then return false end

    if (mode == Combo_key) and mySpells:isSpellReady('q') and qIsPressed == nil then
        local predictedTargetLocation = features.prediction:predict_default(target.index, 0.25)
        if predictedTargetLocation == nil then return false end
        

        -- Use Q to AA cancel if in close fight
        -- Default Rengar AA range = 125 + 25 (from Q) -> Set as 200 to be sure
        local isTargetNearby = features.orbwalker:is_attackable(target.index, 1000, true)
        if isTargetNearby then
            castQAndAATarget(target)
        end

        -- Use Q before AA to burst enemy
        local distance = getDistance(g_local.position, predictedTargetLocation)
        local shouldPressQToBurst =  distance > 200 and distance < 745
        -- leaping towards enemy
        if shouldPressQToBurst and features.orbwalker:is_in_attack() and q_leap_combo_box:get_value() then
            g_input:cast_spell(e_spell_slot.q)
        end
    end
end                            
                            
function mySpells:wSpell()
    local target = features.target_selector:get_default_target()
    local w_range = 450
    local mode = features.orbwalker:get_mode()

    --Bruiser rengar prioitize staying alive, so check to heal first propably.
    -- cast spell if damage taken in the last 1.5 second is > 100 e.g

    if (mode == Combo_key) or (mode == Harass_key) and mySpells:isSpellReady('w') then
        -- leave if this is an empowered ability (sperate check for this)


        -- Use W to burst enemy however dont waste it so use it to combo to get EMP burst
        -- Only use W if other available abilities can combo to empowered ability otherwise use to heal

        -- This spell checking is a quick fix, will look at later (if you see solution, give me a msg Discord: Bearded man#6950)
        local spell_book = g_local:get_spell_book()
        local q_slot = spell_book:get_spell_slot(e_spell_slot.q)
        local e_slot = spell_book:get_spell_slot(e_spell_slot.e)
        local abilityName = spell_book:get_spell_slot(e_spell_slot.w):get_name()
        local burstWithOneAbility = (q_slot:is_ready() or e_slot:is_ready()) and g_local.mana == 2
        local brustWithTwoAbilities = (q_slot:is_ready() and e_slot:is_ready()) and g_local.mana == 1

        if brustWithTwoAbilities or burstWithOneAbility or g_local.mana == 3 then
            if (abilityName == "RengarWEmp") then return false end
            castW()
        end        

    end
    -- Always cast W if it can heal more than 350 HP (Idea, percentage HP instead?) - My thought is this would be a slider on the menu later.
    local shouldUseWToHeal = w_combo_box:get_value()
    if mySpells:isSpellReady('w') and shouldUseWToHeal then
        local recentDamage = getRecentDamageTaken()
        local minHealth = w_heal_percentage_box:get_value()
        if recentDamage >= (g_local.max_health/100)*minHealth and shouldUseWToHeal then
            g_input:cast_spell(e_spell_slot.w)
            return false
        end
    end
    return false
end                            
                            
                            
function castW()  
    if not (g_time - m_last_w_time >= 0.4) or (g_time - m_last_cast_time > 0.4) then return false end
    -- When having 3 "mana" he uses W once and gets an empowered an then auto uses it on this, don't know a possible solution atm.
    if features.orbwalker:should_reset_aa() then
        g_input:cast_spell(e_spell_slot.w)
        m_last_w_time = g_time
        m_last_cast_time = g_time
    end
end

local previousHealth = 0
local lastTimeChecked = 0
function getRecentDamageTaken()
    if previousHealth == 0 then
        previousHealth = g_local.health
    end
    if g_time - lastTimeChecked <= 1.2 then
        return previousHealth - g_local.health
    else
        lastTimeChecked = g_time
        previousHealth = g_local.health
        return 0
    end
    
    return 100
end                            
                            
function mySpells:eSpell()
    local target = features.target_selector:get_default_target()
    local buff_in_r = features.buff_cache:get_buff(g_local.index, "RengarR")

    if target == nil then return false end
    if features.evade:is_active() then return false end
    
    local mode = features.orbwalker:get_mode()
    -- Combo
    if ((mode == Combo_key) or (mode == Harass_key)) and mySpells:isSpellReady('e') and buff_in_r == nil then
        castEAndOnTarget(target)
    end
    return false
end                            
                            
-- Asserts that target ~= nil
function castEAndOnTarget(target)
    local e_hit = features.prediction:predict(target.index, e_range, e_speed, e_width, e_windup, g_local.position)
    if not e_hit.valid then return true end
    if not (g_time - m_last_e_time >= 0.4 and g_time - m_last_cast_time > 0.4) then return true end
    local spell_book = g_local:get_spell_book()
    local abilityName = spell_book:get_spell_slot(e_spell_slot.e):get_name()
    local buff_in_bush = features.buff_cache:get_buff(g_local.index, "rengarpassivebuff")

    if abilityName == "RengarEEmp" then
        -- Use Empowered E to CC if far far away
        castEmpoweredE(buff_in_bush, e_hit)
    else
        castNonEmpoweredE(buff_in_bush, e_hit, target)
    end
    -- RengarEEmp
end

function castNonEmpoweredE(buff_in_bush, e_hit, target) 
    -- Cast E if in attack and target is far away (logic to burst enemy when leaping towards them as cast timer is 0)
    local distance = getDistance(g_local.position, e_hit.position)
    -- Same arguments as Q far away
    local targetFarAway = distance > 160
    if targetFarAway and features.orbwalker:is_in_attack() and e_leap_box:get_value() then
        local e_new = features.prediction:predict(target.index, e_range, e_speed, e_width, 0, g_local.position)
        g_input:cast_spell(e_spell_slot.e, e_hit.position)
        m_last_e_time = g_time
        m_last_cast_time = g_time
        return false
    end

    -- Use non-empowered E to slow if enemy is far away and in range
    local eToSlow = distance > 200 and g_local.mana < 4
    if eToSlow and buff_in_bush == nil and e_slow_box:get_value() then
        g_input:cast_spell(e_spell_slot.e, e_hit.position)
        m_last_e_time = g_time
        m_last_cast_time = g_time
        return false
    end

    -- Use E to AA cancel if target is close
    local isTargetClose = features.orbwalker:is_attackable(target.index, 1000, true)
    if isTargetClose and features.orbwalker:should_reset_aa() then
        g_input:cast_spell(e_spell_slot.e, e_hit.position)
        m_last_e_time = g_time
        m_last_cast_time = g_time
        return false
    end
end

function castEmpoweredE(buff_in_bush, e_hit)
    local distance = getDistance(g_local.position, e_hit.position)
    local eToCC = distance > 400
    if eToCC and buff_in_bush == nil and e_cc_box:get_value() then
        g_input:cast_spell(e_spell_slot.e, e_hit.position)
        m_last_e_time = g_time
        m_last_cast_time = g_time
        return false
    end
end
                            
-- RengarR Rengars ultimate is active
                            -- rengarpassivebuff Rengar is in a bush
cheat.register_module({
    champion_name = "Rengar",
    spell_q = function()
        mySpells:qSpell()
        return false
    end,
    spell_w = function()
        mySpells:wSpell()
        return false
    end,
    spell_e = function()
        mySpells:eSpell()
        return false
    end,
        spell_r = function()
        return false
    end,
    get_priorities = function()
        return {
        "spell_r",
        "spell_q",
        "spell_e",
        "spell_w"
        }
    end})                            