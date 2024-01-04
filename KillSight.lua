
local Script_name = string.lower(g_local.champion_name.text)

function Prints(str)
    local dbg = 1
    if dbg == 1 then 
        print(os.date('%H:%M:%S') .." ".. str) 
    end
end


function CalcDamage(index, rawDamage)
    Prints("cdt")
    local target = features.entity_list:get_by_index(index)
    --Prints("Calcing: " .. target:get_object_name())
    local armor = target.total_armor
    calc = (rawDamage * ( 100 / ( 100 + armor )))
    Prints("lc")
    return calc
end

function CalcDamageAP(index, rawDamage)
    local target = features.entity_list:get_by_index(index)
    local mr = target.total_mr
    return (rawDamage * ( 100 / ( 100 + mr )))
end


function getQLevel()
    return g_local:get_spell_book():get_spell_slot(e_spell_slot.q).level
 end
function getWLevel()
    return g_local:get_spell_book():get_spell_slot(e_spell_slot.w).level
 end
function getELevel()
    return g_local:get_spell_book():get_spell_slot(e_spell_slot.e).level
 end
function getRLevel()
   return g_local:get_spell_book():get_spell_slot(e_spell_slot.r).level
end

function BonusAD()
   Hero = g_local
   return Hero.bonus_attack
end

function getAP()
   return g_local:get_ability_power()
end

function getAD()
    return g_local:get_attack_damage()
 end


function get_rend_damage(index)
    Prints("Get rend dmg")
    local target = features.entity_list:get_by_index(index)
    local base = 20
    local levelDmg = 10*getELevel()
    local ad = getAD()
    local first_multiplier = 0.7
    local second_multiplier = (0.232+(0.0435*getELevel()))
    if getELevel() > 4 then second_multiplier = 0.406 end
    local first_spear_dmg = (base + levelDmg + ad*first_multiplier)
    local other_spear_dmg = (base + ad*second_multiplier)
    local num_other_spears = getStacks(index, 'kalistaexpungemarker')-1

    local raw = first_spear_dmg + (num_other_spears*other_spear_dmg)
    print(target:get_object_name() .. " has ".. num_other_spears + 1 .. " spear stacks and will take ".. raw .. " damage from rend before armour")
    if raw < 0 then return 0 end 
    -- Prints("first:" .. first_spear_dmg)
    -- Prints("seconds" .. other_spear_dmg * num_other_spears)
    -- Prints("subsequent muliplier is: " .. second_multiplier  )
    -- Prints("AD:".. getAD() .. " + " .. BonusAD())
    Prints("leaving rend calc")
    return raw
    -- 145 
    -- 229
end

function getStacks(index , str)
    local s = 0
    Prints("checking spears")
    local target = features.entity_list:get_by_index(index)
    Prints("checking for spears on ".. target:get_object_name())
    for j, buff in pairs(features.buff_cache:get_all_buffs(target.index)) do  
        Prints(buff.name)  
        if buff.name == str then
            Prints("Found it")
            local num = buff:get_stacks();
            if num == nil then 
                print("tf man")
                return 0; 
            end
           
            Prints("num is not nil....")
            Prints(num .. " spears")
            return num
        end
    end
    Prints("spears: " .. s)
    return s  
end


--/**
-- I'd like to do it this way but this method is broken
--**/
function gs(index, str)
    Prints("checking spears 2")
    local s = 0
    -- this doesnt work :(
    local stacks = features.buff_cache:get_buff(index, str):get_stacks() 
    if stacks ~= nil then
        print(stacks)
        s = s + stacks
    end

    Prints("got spears: " .. s)
    return s   
end


function Can_R()
   if  g_local:get_spell_book():get_spell_slot(e_spell_slot.r):is_ready() and g_local.mana  > Spell_Cost then 
       return true
   end
  
   return false
end

-- calls process KS
function ks()
    ProcessKS()
end


function ProcessKS()
    -- get enemies
    Prints("pks go in at " .. #InRange)
    local hero_Table = features.entity_list:get_enemies()
    for i, obj_hero in ipairs(hero_Table) do
        Prints("pks loop in " .. obj_hero:get_object_name())
        if obj_hero:is_alive()  and obj_hero:is_visible() and g_local.position:dist_to(obj_hero.position) < Spell_Width then
            Prints(obj_hero:get_object_name() .. " in range")
            local exists = 0
            if #InRange > 0 then
                for ii, alive in pairs(InRange) do
                    if alive.champ == obj_hero.index then 
                        dmg = SpellData[Hero_Champ].DMG(obj_hero.index)
                        Prints("Stored dmg is " .. alive.damage .. " new dmg is " .. dmg )
                        alive.damage = dmg
                        Prints("Stored dmg now: " .. dmg )
                        exists = 1
                    end
                end
            end

            if exists == 0 then
                table.insert(InRange, {champ = obj_hero.index ,damage = SpellData[Hero_Champ].DMG(obj_hero.index)}) 
            end
        else  
            for iii, enemy in pairs(InRange) do
                local obj = features.entity_list:get_by_index(enemy.champ)
                if not obj:is_alive() or not obj:is_visible() then
                    table.remove(InRange, i)
                end
            end
        end   
    end
end


function draw()
    Prints("Enter draw : list at " .. #InRange)
    local Square_color = color:new( 0,255,255)
    -- NennyUlt
    if #InRange > 0 then
        Prints("draw -> loop")
        for i, tbl in pairs(InRange) do
            enemy = features.entity_list:get_by_index(tbl.champ) 
            local dmg = tbl.damage
            local Killable = false
            local hp = enemy.health+5
             print("hp: " .. hp)
            -- print("dmg: " .. dmg)
            local perc =  (dmg/hp)*100
            -- print("perc " .. perc)
            local pretty = math.floor(perc+0.5)
            -- print("prty " ..pretty)
            perc = pretty
            -- print(perc)
            -- print("max_hp: "..enemy.max_health)
            -- print("hp: "..enemy.health)

            if dmg >= (enemy.health + 5) then
                Killable = true
                Square_color = color:new(255,0,200)
                Prints("draw circ")
                if enemy.position:to_screen() ~= nil then
                    g_render:circle(enemy.position:to_screen(), Square_color, 65, 90)
                end
                Prints("drew circ")
            end
            Prints("draw text")
            if enemy.position:to_screen() ~= nil then
                g_render:text(enemy.position:to_screen(), color:new(255,255,255),perc.."%", 30) --Hold SHIFT to "..mode_text.." ultimate!
                Prints("drew text")
            end
        end 
    end
end

function Init()
    Recalling = {}
    InRange = {}
    Spell_Limiter = 1
    Casted = false
    Res = g_render:get_screensize()
    Hero = g_local
    Hero_Champ = Hero.champion_name.text
    Spell_R_Level = g_local:get_spell_book():get_spell_slot(e_spell_slot.r).level

    SpellData = {
      ["Kalista"] = {
         Delay = 0.25,
         Width = 1100,
         MissileSpeed = 0,
         Collision = false,
         Cost = 30,
         DMG = function(index) return CalcDamage(index ,get_rend_damage(index)) end
        }
    }
    
    Spell_Width = SpellData[Hero_Champ].Width
    Spell_Delay = SpellData[Hero_Champ].Delay
    Spell_MissileSpeed = SpellData[Hero_Champ].MissileSpeed
    Spell_Collision = SpellData[Hero_Champ].Collision
    Spell_Cost = SpellData[Hero_Champ].Cost
 end



 local function init()
    -- get enemies
   local hero_Table = features.entity_list:get_enemies()
   -- for each enemy in list 
   for i, obj_hero in ipairs(hero_Table) do
        local exists = 0
        if obj_hero:is_alive() and g_local.position:dist_to(obj_hero.position) < Spell_Width then
            for ii, alive in pairs(InRange) do
                if alive.champ == obj_hero.index then -- tf is this?
                    table.insert(InRange, {champ = alive.index, damage = SpellData[Hero_Champ].DMG(alive.index)}) 
                end
            end
        else            
            for iii, enemy in pairs(inRange) do
                local obj = features.entity_list:get_by_index(enemy.champ)
                
                if not obj:is_alive() or not obj:is_visible() then
                    table.remove(InRange, i)
                end
            end
        end   
    end
end


print("---INIT--")
Init()
print("Killsight: ".. Hero_Champ)

cheat.register_callback("feature", ks)
-- cheat.register_callback("feature", baseult)
cheat.register_callback("render", draw)

