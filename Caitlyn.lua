
Combo_key = 1
Harass_key = 4
Full_key = 6
toggle_limiter = 0
trap_limiter = 0
Q_range,Q_speed,Q_width,Q_windup,Q_cost = 1300,2200,180/2,0.625,50 --slot pred uses width/2
W_range,W_speed,W_width,W_windup,W_cost = 800,0,80/2,0.25,65 --slot pred uses width/2
E_range,E_speed,E_width,E_windup,E_cost = 800,1600,140/2,0.815,75 --slot pred uses width/2
R_range,R_speed,R_width,R_windup,R_cost = 3500,3200,80/2,0.375,100 --slot pred uses width/2
Res = g_render:get_screensize()
LastTick = 0
Script_name = "Caityn"
Font = 'roboto-regular'
White = color:new(255,255,255)
Red = color:new(255,0,0)
Green = color:new(0,255,0)
Blue = color:new(0,0,200)
Res = g_render:get_screensize()

-- Add new navigation item
local test_navigation = menu.get_main_window():push_navigation(Script_name, 10000)
-- Create new config var
local q_config = g_config:add_bool(true, "Use_Q")
local w_config = g_config:add_bool(true, "Use_W")
local e_config = g_config:add_bool(true, "Use_E")
local r_config = g_config:add_bool(true, "Use_R")
local r2_config = g_config:add_bool(true, "Use_R2")

local q_draw = g_config:add_bool(true, "draw_Q")
local w_draw = g_config:add_bool(true, "draw_W")
local e_draw = g_config:add_bool(true, "draw_E")
local r_draw = g_config:add_bool(true, "draw_R")
local r2_config = g_config:add_bool(true, "draw_R2")

local my_nav = menu.get_main_window():find_navigation(Script_name)
local spell_sect = my_nav:add_section("Use spells")
local draw_sect = my_nav:add_section("draw spells")

local checkboxq = spell_sect:checkbox("Use Q", q_config)
local checkboxw = spell_sect:checkbox("Use W", w_config)
local checkboxe = spell_sect:checkbox("Use E", e_config)
local checkboxr = spell_sect:checkbox("Use R", r_config)
local checkboxr2 = spell_sect:checkbox("Draw R Lethal", r2_config)

local checkboxdq = draw_sect:checkbox("Draw Q", q_draw)
local checkboxdw = draw_sect:checkbox("Draw W", w_draw)
local checkboxde = draw_sect:checkbox("Draw E", e_draw)
local checkboxdr = draw_sect:checkbox("Draw R", r_draw)
local checkboxdr2 = draw_sect:checkbox("Draw R Lethal", r2_draw)

checkboxq:set_value(true)
checkboxw:set_value(true)
checkboxe:set_value(true)
checkboxr:set_value(true)
checkboxr2:set_value(true)

local acc_sect = my_nav:add_section("damage calc")
local acc_config = g_config:add_int(0, "Q acc")
local acc_q_slider = acc_sect:slider_int("Q accuracy", acc_config, 0, 5, 1)
acc_q_slider:set_value(2)

local harass_sect = my_nav:add_section("Harass Settings")
local harass_q_config = g_config:add_bool(true, "Q in harass")
local harass_manaPercent = g_config:add_int(0, "harassmana")
local hslider = harass_sect:slider_int("Harass mana slider", harass_manaPercent, 0, 100, 1)
local harass_q_box = harass_sect:checkbox("Use Q", harass_q_config)
harass_q_box:set_value(true)
hslider:set_value(60)

function Prints(str)
    local dbg = 1
    if dbg == 1 then print(str) end
end

function CalcDamage(target, rawDamage)
    local armor = target.total_armor
    return (rawDamage * ( 100 / ( 100 + armor )))
 end
 
 function getRLevel()
    return g_local:get_spell_book():get_spell_slot(e_spell_slot.r).level
 end
 function BonusAD()
    Hero = g_local
    return Hero.bonus_attack
 end
 
 

cheat.register_module({
    champion_name = "Caitlyn",
    spell_q = function (data)
        Prints("q in")
        local ret = true
        if os.clock()*1000 < LastTick  or checkboxq:get_value() == false then
            Prints("q to soon")
            ret = false
        end
       
        if Q_cost > g_local.mana  then
            Prints("no r mana ret")
            return false
        end
        Prints("q target select")
        Target = features.target_selector:get_default_target()
        if Target == nil then return false end
        if  features.target_selector:is_bad_target(Target.index) or not features.orbwalker:is_attackable(Target.index, Q_range, true) and Target:is_alive() and Target:is_visible() then
            return false
        end
        
        if features.orbwalker:get_mode() == Combo_key and checkboxq:get_value() then 
            if g_local:get_spell_book():get_spell_slot(e_spell_slot.e):is_ready() and g_local.position:dist_to(Target.position) < E_range then return false end
            --wait for net boi                 
            local qHit = features.prediction:predict(Target.index, Q_range, Q_speed, Q_width, Q_windup, g_local.position) 
            if (qHit.valid and qHit.hitchance >= acc_q_slider:get_value()) then
                Prints("cast combo q")
                g_input:cast_spell(e_spell_slot.q, qHit.position)
                return true
            end
            return false
        elseif features.orbwalker:get_mode() == Harass_key and harass_q_box:get_value() and (g_local.mana / g_local.max_mana * 100) >  hslider:get_value() then 
            local qHit = features.prediction:predict(Target.index, Q_range, Q_speed, Q_width, Q_windup, g_local.position) 
            if (qHit.valid and qHit.hitchance >= acc_q_slider:get_value()) then
                Prints("cast harass q")
                g_input:cast_spell(e_spell_slot.q, qHit.position)
                return true
            end
            Prints("no harass q mana ret")
            return false
        end
        Prints("out q")
        return false
    end,
    spell_w = function(data)
        Prints("w in")
        local ret = true
        if trap_limiter < g_time and checkboxw:get_value()  then
            for _,enemy in pairs(features.entity_list:get_enemies()) do
                if g_local.position:dist_to(enemy.position) < W_range then
                    Prints("checking hard cc ")
                    if enemy ~= nil and not enemy:is_invisible() and enemy:is_alive() then
                        if features.buff_cache:is_immobile(enemy.index) or features.buff_cache:has_hard_cc(enemy.index) then
                            is_traped = features.buff_cache:get_buff(enemy.index, "CaitlynWSnare") -- buff.name == "caitlynwsight"
                            is_sighted = features.buff_cache:get_buff(enemy.index, "caitlynwsight")
                            if  not is_sighted and not is_traped then
                                local qHit = features.prediction:predict(enemy.index, W_range, W_speed, W_width, W_windup, g_local.position)
                                if (qHit.valid) then 
                                    g_input:cast_spell(e_spell_slot.w, qHit.position)
                                    trap_limiter = g_time + 2.55
                                    features.orbwalker:set_cast_time(features.orbwalker:get_attack_cast_delay())
                                    Prints("auto cc w cast")
                                    return false
                                end
                            end
                        end             
                    end
                end
            end
        end

        Prints("no w ret")
        return false
    end,
    spell_e = function(data)
        Prints("e in")
        local ret = true
        if os.clock()*1000 < LastTick  or checkboxe:get_value() == false then
            Prints("e to soon")
            ret = false
        end
       
        if E_cost > g_local.mana or not g_local:get_spell_book():get_spell_slot(e_spell_slot.q):is_ready() then
            Prints("no r mana ret")
            return false
        end
        Prints("e target select")
        Target = features.target_selector:get_default_target()
        if Target == nil or features.target_selector:is_bad_target(Target.index) or not features.orbwalker:is_attackable(Target.index, E_range, true) then
            Prints("no e target")
            return false
        end
        
        if features.orbwalker:get_mode() == Combo_key and checkboxe:get_value() then  
            Prints("e check")        
            local qHit = features.prediction:predict(Target.index, E_range, E_speed, E_width, E_windup, g_local.position) 
            Prints("acc will be " .. qHit.hitchance)
            if (qHit.valid and qHit.hitchance >= acc_q_slider:get_value()) then
                Prints("cast combo E")
                g_input:cast_spell(e_spell_slot.e, qHit.position)
                return true
            end
            return false
        end
        Prints("out e")
        return false
    end,
    spell_r = function(data)
        Prints("r in")
        local ret = true
        if os.clock()*1000 < LastTick  or checkboxr:get_value() == false then
            Prints("r to soon")
            ret = false
        end

        if R_cost > g_local.mana  then
            Prints("no r mana ret")
            return false
        end
        -- -==============================================================================================================
        ENM = {}
        ENM = features.entity_list:get_enemies()
        for _,unit in pairs(features.entity_list:get_enemies()) do
            if unit ~= nil then 
                local badTarget = features.target_selector:is_bad_target(unit.index)
                if features.orbwalker:get_mode() == Combo_key and badTarget ~= true then
                    if g_input:is_key_pressed(17) then
                        local dmg = CalcDamage(unit , (300 + (225*getRLevel())) +  BonusAD())
                        if dmg >= (unit.health + 60) and g_local.position:dist_to(unit.position) < R_range and badTarget ~= True and unit:is_alive() and unit:is_visible() then
                            Prints("Cast r")
                            g_input:cast_spell(e_spell_slot.r, unit)
                        end
                    end
                end
            end
        end
        -- anti gap close auto r pog tm
        -- Prints("no r ret")
        return false
    end,
    initialize = function()
        print(os.date('%H:%M:%S') .. " initializing cait 1.0?")
        LastTick = os.clock()*1000 + 2
        return true
    end,
    get_priorities = function() return {"spell_e","spell_q","spell_r","spell_w"} end
})
function Keys()
    if g_input:is_key_pressed(74) and toggle_limiter < g_time then -- j
        if  checkboxw:get_value()  then  
            checkboxw:set_value(false)
        else
            checkboxw:set_value(true)
        end
        toggle_limiter = g_time + 0.25
        return false
    end
end



local function RenderDmg() 
    Prints("render in")
    if checkboxw:get_value() then
        --Prints("try draw w status")
        g_render:text(g_local.position:to_screen(), Green, "W Enabled", Font , 10)
    end
    if checkboxdq:get_value() then
        --Prints("try draw q status")
        g_render:circle_3d(g_local.position, Red, Q_range-5, 2, 90, 2)
    end
    if checkboxdw:get_value() then
        --Prints("try draw q status")
        g_render:circle_3d(g_local.position, Green, W_range-5, 2, 90, 2)
    end
    if checkboxde:get_value() then
        --Prints("try draw q status")
        g_render:circle_3d(g_local.position, Blue, E_range-5, 2, 90, 2)
    end
    if checkboxdr:get_value() then
        --Prints("try draw q status")
        g_render:circle_3d(g_local.position, White, R_range-5, 2, 90, 2)
    end

    if ENM == nil then ENM = {} end
    if not g_local:get_spell_book():get_spell_slot(e_spell_slot.r):is_ready() or checkboxr2:get_value() == false  then
        ENM = {}
        return false
    end
    Prints("try draw r")

    for _,unit in pairs(ENM) do
        local Square_color = color:new( 0,255,255)
        if not g_local:get_spell_book():get_spell_slot(e_spell_slot.r):is_ready() then
            return false
        end
        local badTarget = features.target_selector:is_bad_target(unit.index) and unit:is_alive() and unit:is_visible()
        if not badTarget then 
            local dmg = CalcDamage(unit , (300 + (225*getRLevel())) +  BonusAD())
            --hp = features.prediction:predict_health(unit,R_windup+.2,false)
            if dmg >= (unit.health + 60) and g_local.position:dist_to(unit.position) < R_range and badTarget ~= True and unit:is_alive() and unit:is_visible() then
                g_render:circle(unit.position:to_screen(), Square_color, 65,  90)
                --g_render:text(vec2:new((Res.x/2) - 100, Res.y - 160 ), color:new(255,0,200),"Cait R lethal on  "..unit:get_object_name(), 20) --Hold SHIFT to "..mode_text.." ultimate!
            end
        end
    end
end

cheat.register_callback("render",RenderDmg)
cheat.register_callback("feature",Keys)