

Combo_key = 1
Clear_key = 3
Harass_key = 4
Flee_key = 5
Script_name = "Loaded Lulu"

--menu
local test_navigation = menu.get_main_window():push_navigation(Script_name, 10000)
local my_nav = menu.get_main_window():find_navigation(Script_name)


--spell configs
local q_config = g_config:add_bool(true, "Use Q (Combo)")
local w_config = g_config:add_bool(true, "Use W (Combo)")
local e_config = g_config:add_bool(true, "Use E (Combo)")
local r_config = g_config:add_bool(true, "Use R (Combo)")

local q_harass_config = g_config:add_bool(true, "Use Q (Harass)")
local w_harass_config = g_config:add_bool(true, "Use W (Harass)")
local e_harass_config = g_config:add_bool(true, "Use E (Harass)")

local w_pref_enemy_config = g_config:add_bool(true, "W Pref Enemy")
local w_pref_ally_config = g_config:add_bool(true, "W Pref Ally")
local w_pref_self_config = g_config:add_bool(true, "W Pref Self")
local e_pref_enemy_config = g_config:add_bool(true, "E Pref Enemy")
local e_pref_ally_config = g_config:add_bool(true, "E Pref Ally")
local e_pref_self_config = g_config:add_bool(true, "E Pref Self")


local health_config = g_config:add_int(0, "R Health Threshhold (%)")

local q_acc_config = g_config:add_int(0, "Q Accuracy")

local num_nmeR = g_config:add_int(2, "R If Enemies Hit >=")

local debug_config = g_config:add_bool(true, "Debug?")

--draw config
local pix_drawings_config = g_config:add_bool(true, "Pix (Q) Drawings")
local q_drawings_config = g_config:add_bool(true, "Q Drawings")
local w_drawings_config = g_config:add_bool(true, "W Drawings")
local e_drawings_config = g_config:add_bool(true, "E Drawings")
local r_drawings_config = g_config:add_bool(true, "R Drawings")

--sections
local spell_sect = my_nav:add_section("Use Spells in Combo")
local harass_sect = my_nav:add_section("Use Spells in Harass")
local acc_sect = my_nav:add_section("Accuracy Slider")

local draw_sect = my_nav:add_section("Drawings")
local enemies_sect = my_nav:add_section("Enemies")
local debug_sect = my_nav:add_section("Debug?!")

local pref_sect = my_nav:add_section("Spell Pref.")

--ui
local checkboxq = spell_sect:checkbox("Use Q (Combo)", q_config)
local checkboxw = spell_sect:checkbox("Use W (Combo)", w_config)
local checkboxe = spell_sect:checkbox("Use E (Combo)", e_config)
local checkboxr = spell_sect:checkbox("Use R (Combo)", r_config)
checkboxq:set_value(true)
checkboxw:set_value(true)
checkboxe:set_value(true)
checkboxr:set_value(true)

local checkbox_harass_q = harass_sect:checkbox("Use Q (Harass)", q_harass_config)
local checkbox_harass_w = harass_sect:checkbox("Use W (Harass)", w_harass_config)
local checkbox_harass_e = harass_sect:checkbox("Use E (Harass)", e_harass_config)
checkbox_harass_q:set_value(true)
checkbox_harass_w:set_value(true)
checkbox_harass_e:set_value(true)

local acc_q_slider = acc_sect:slider_int("Q Accuracy", q_acc_config, 0, 5, 1)
acc_q_slider:set_value(2)

local rslider = enemies_sect:slider_int("R If Enemies Hit >=", num_nmeR, 1, 5, 1)
rslider:set_value(1)

local checkbox_debug = debug_sect:checkbox("Print Statements", debug_config)
checkbox_debug:set_value(false)

local checkbox_pix_drawings = draw_sect:checkbox("Draw Pix (Q) Range", pix_drawings_config)
local checkbox_q_drawings = draw_sect:checkbox("Draw Q Range", q_drawings_config)
local checkbox_w_drawings = draw_sect:checkbox("Draw W Range", w_drawings_config)
local checkbox_e_drawings = draw_sect:checkbox("Draw E Range", e_drawings_config)
checkbox_pix_drawings:set_value(false)
checkbox_q_drawings:set_value(false)
checkbox_w_drawings:set_value(false)
checkbox_e_drawings:set_value(false)


local w_pref_enemy = pref_sect:checkbox("Pref W Enemy", w_pref_enemy_config)
local w_pref_ally = pref_sect:checkbox("Pref W Ally", w_pref_ally_config)
local w_pref_self = pref_sect:checkbox("Pref W Self", w_pref_self_config)
local e_pref_enemy = pref_sect:checkbox("Pref E Enemy", e_pref_enemy_config)
local e_pref_ally = pref_sect:checkbox("Pref E Ally", e_pref_ally_config)
local e_pref_self = pref_sect:checkbox("Pref E Self", e_pref_self_config)
w_pref_enemy:set_value(false)
w_pref_ally:set_value(true)
w_pref_self:set_value(false)
e_pref_enemy:set_value(false)
e_pref_ally:set_value(true)
e_pref_self:set_value(false)

local r_health_slider = pref_sect:slider_int("R Health Threshhold (%)", health_config, 0, 100, 1)
r_health_slider:set_value(35)


--Nenny Range DB for prio
RangeDB = {
    aatrox = {Range = 625, Prio = 3}, --adc 5, mid 4,  fighter 3, support 2, tnak 1
    ahri = {Range = 880, Prio = 4},
    akali = {Range = 825, Prio = 4},
    alistar = {Range = 700, Prio = 1},
    amumu = {Range = 1100, Prio = 1},
    anivia = {Range = 1075, Prio = 4},
    annie = {Range = 625, Prio = 4},
    aphelios = {Range =650, Prio = 5},
    ashe = {Range = 1200, Prio = 5},
    aurelionsol = {Range = 1500, Prio = 4},
    azir = {Range = 740, Prio = 4},
    bard = {Range = 950, Prio = 2},
    blitzcrank = {Range = 1150, Prio = 2},
    brand = {Range = 1050, Prio = 3},
    braum = {Range = 1000, Prio = 1},
    caitlyn = {Range = 1250, Prio = 5},
    camille = {Range = 650, Prio = 3},
    cassiopeia = {Range = 850, Prio = 4},
    chogath = {Range = 950, Prio = 3},
    corki = {Range = 1500, Prio = 5},
    darius ={Range = 535, Prio = 1},
    diana = {Range = 900, Prio = 4},
    draven = {Range = 1050, Prio = 5},
    drmundo = {Range = 975, Prio = 1},
    ekko = {Range = 1175, Prio = 4},
    elise = {Range = 850, Prio = 3},
    evelynn = {Range = 800, Prio = 3},
    ezreal = {Range = 1150, Prio = 5},
    fiddlesticks = {Range = 850, Prio = 3},
    fiora = {Range = 750, Prio = 3},
    fizz = {Range = 1300, Prio = 4},
    galio = {Range = 825, Prio = 3},
    gangplank = {Range = 625, Prio = 3}, -- UPDATE FOR E enventually
    garen = {Range = 400, Prio = 1},
    gnar = {Range = 1125, Prio = 3},
	gragas = {Range = 850, Prio = 2},
	graves = {Range = 800, Prio = 3},
	hecarim = {Range = 350, Prio = 3},
	heimerdinger = {Range = 1325, Prio = 4},
	illaoi = {Range = 850, Prio = 3},
	irelia = {Range = 950, Prio = 3},
	ivern = {Range = 1075, Prio = 1},
	janna = {Range = 1750, Prio = 2},
    jarvaniv = {Range = 860, Prio = 2},
    jax = {Range = 700, Prio = 3},
	jayce = {Range = 1600, Prio = 3},
	jhin = {Range = 1750, Prio = 5}, -- TEST A LOT
	jinx = {Range = 1450, Prio = 5},
	kaisa = {Range = 1750, Prio = 5}, -- TEST A LOT
	kalista = {Range = 1150, Prio = 5},
	karma = {Range = 950, Prio = 2},
	kharthus = {Range = 875, Prio = 4},
    kassadin = {Range = 600, Prio = 4},
    katarina = {Range = 725, Prio = 4},
	kayle = {Range = 900, Prio = 4},
	kayn = {Range = 700, Prio = 3},
	kennen = {Range = 1050, Prio = 3},
    khazix = {Range = 1000, Prio = 3 },
    kindred = {Range = 560, Prio = 4}, --TEST A LOT
	kled = {Range = 800, Prio = 2},
	kogmaw = {Range = 1800, Prio = 5},
	leblanc ={Range = 925, Prio = 4},
	leesin = {Range = 1100, Prio = 3},
    leona = {Range = 875, Prio = 1},
    lilia = {Range = 500, Prio = 3}, --test a lot
	lissandra = {Range = 1025, Prio = 4},
	lucian = {Range = 900, Prio = 5},
	lulu = {Range = 925, Prio = 2},
	lux = {Range = 1175, Prio = 4},
	malphite = {Range = 1000, Prio = 1},
	malzahar = {Range = 900, Prio = 4},
    maokai = {Range = 600, Prio = 1},
    masteryi = {Range = 600, Prio = 3},
	missfortune = {Range = 1000, Prio = 5},
	mordekaiser = {Range = 900, Prio = 3},
	morgana = {Range = 1250, Prio = 2},
    nami = {Range = 875, Prio = 2},
    nasus = {Range = 700, Prio = 2},
	nautilus = {Range = 925, Prio = 1},
	neeko = {Range = 1000, Prio = 4},
	nidalee = {Range = 1500, Prio = 3},
    nocturne = {Range = 1200, Prio = 3},
    nunu = {Range =  625, Prio = 2}, --CHECK NAME IN GAME
	olaf = {Range = 1000, Prio = 3},
	orianna = {Range = 825, Prio = 4},
	ornn = {Range = 800, Prio = 1},
	pantheon = {Range = 1200, Prio = 3},
	poppy = {Range = 430, Prio = 2},
	pyke = {Range = 1100, Prio = 3},
	qiyana = {Range = 925, Prio = 4},
	quinn = {Range = 1025, Prio = 3},
	rakan = {Range = 850, Prio = 2},
    reksai = {Range = 1625, Prio = 3},
    rell = {Range = 700, Prio = 1},
	rengar = {Range = 1000, Prio = 4},
	riven = {Range = 900, Prio = 3},
	rumble = {Range = 825, Prio = 4},
    ryze = {Range = 1000, Prio = 4},
    samira = {Range = 950, Prio = 5},
	sejuani = {Range = 650, Prio = 1},
    senna = {Range = 975, Prio = 5 }, -- TEST A LOT
    seraphine = {Range = 900, Prio = 4},
    sett = {Range = 790, Prio = 3},
    shaco = {Range = 625, Prio = 2},
    shen = {Range = 600, Prio = 1},
    shyvana = {Range = 925, Prio = 3},
    singed = {Range = 1000, Prio = 1},
	sion = {Range = 750, Prio = 1},
	sivir = {Range = 1250, Prio = 5},
	skarner = {Range = 1000, Prio = 3},
	sona = {Range = 825, Prio = 2},
	soraka = {Range = 810, Prio = 4},
	swain = {Range = 850, Prio = 3},
	sylas = {Range = 850, Prio = 4},
	syndra = {Range = 800, Prio = 4},
	tahmkench = {Range = 900, Prio = 1},
	taliyah = {Range = 1000, Prio = 4},
    talon = {Range = 650, Prio = 4},
    taric = {Range = 610, Prio = 1},
    teemo = {Range = 680, Prio = 4},
	thresh = {Range = 1100, Prio = 2},
    tristana = {Range = 900, Prio = 5},
    trundle = {Range =  650, Prio = 2},
	tryndamere = {Range = 660, Prio = 3},
    twistedfate = {Range = 1450, Prio = 4},
    twitch = {Range = 950, Prio = 5},
    udyr = {Range =  800, Prio = 3}, --test
    urgot = {Range = 800, Prio = 2}, 
    varus = {Range = 1525, Prio = 5},
    vayne = {Range = 550, Prio = 5},
	veigar = {Range = 900, Prio = 4},
	velkoz = {Range = 1550, Prio = 4}, -- 1100 is q IF ult is too hight
	vi = {Range = 725, Prio = 3}, 
	viktor = {Range = 1150, Prio = 4}, --- IMPORTANT TO TEST ASAP NEED HELP
    vladimir = {Range = 600, Prio = 3},
    volibear = {Range = 1200, Prio = 3},
    warwick = {Range = 350, Prio = 3},
    monkeyking = {Range =  650, Prio = 3},
	xayah = {Range = 1100, Prio = 5},
	xerath = {Range = 1400, Prio = 4}, 
	xinzhao = {Range = 900, Prio = 3},
	yasuo = {Range = 1000, Prio = 4},
	yone = {Range = 1000, Prio = 4}, --- might need tweaking
	yorick = {Range = 700, Prio = 1},
	yuumi = {Range = 1100, Prio = 1}, --test as target
	zac = {Range = 800, Prio = 1},
	zed = {Range = 900, Prio = 4}, --- WILL NEED WORK 
	ziggs =  {Range = 850, Prio = 4},
	zilean = {Range = 900, Prio = 2},
	zoe = {Range = 1600, Prio = 4},
	zyra = {Range = 1100, Prio = 2},
    zeri =  {Range = 1500, Prio = 5}
}


-- Debug function thanks to pingpongpow
function Prints(str)
    local dbg = 1
    if dbg == 1 and checkbox_debug:get_value() == true then
        print(str)
    end
end




--[[
    TS <3 Nenny start
    adding/editing for ally prio
]]--

local TSsection = my_nav:add_section("Enemy Priorities")
local allyTSsection = my_nav:add_section("Ally Priorities")

local champLowercase = nil

local function get_prio(name)
    local lowerName =  string.lower(name)
    if RangeDB[lowerName] ~= nil then return RangeDB[lowerName].Prio else return 1 end
end

--Enemy prio
local enemyChampName = {}

for i, enemy in pairs(features.entity_list:get_enemies()) do

    enemyChampName[i] = enemy.champion_name.text

end
if enemyChampName [1] ~= nil then 
	Champ1Conf = g_config:add_int(get_prio(enemyChampName[1]),enemyChampName[1])
	Champ1 = TSsection:slider_int(enemyChampName[1] , Champ1Conf,         1,        5,     1)

end
if enemyChampName [2] ~= nil then 
	Champ2Conf = g_config:add_int(get_prio(enemyChampName[2]),enemyChampName[2])
	Champ2 = TSsection:slider_int(enemyChampName[2] , Champ2Conf,         1,        5,     1)
end
if enemyChampName [3] ~= nil then 
	Champ3Conf = g_config:add_int(get_prio(enemyChampName[3]),enemyChampName[3])
	Champ3 = TSsection:slider_int(enemyChampName[3] , Champ3Conf,         1,        5,     1)
end
if enemyChampName [4] ~= nil then 
	Champ4Conf = g_config:add_int(get_prio(enemyChampName[4]),enemyChampName[4])
	Champ4 = TSsection:slider_int(enemyChampName[4], Champ4Conf,         1,        5,     1)
end
if enemyChampName [5] ~= nil then 
	Champ5Conf = g_config:add_int(get_prio(enemyChampName[5]),enemyChampName[5])
	Champ5 = TSsection:slider_int(enemyChampName[5] , Champ5Conf,         1,        5,     1)
end

enemy_priority = {}
local function update_priority_enemy()

    if enemyChampName[1] ~= nil then enemy_priority[1] = Champ1:get_value()  end
    if enemyChampName[2] ~= nil then enemy_priority[2] = Champ2:get_value()  end
    if enemyChampName[3] ~= nil then enemy_priority[3] = Champ3:get_value()  end
    if enemyChampName[4] ~= nil then enemy_priority[4] = Champ4:get_value()  end
    if enemyChampName[5] ~= nil then enemy_priority[5] = Champ5:get_value()  end
end




--Ally Prio
local allyChampName = {}

for i, ally in pairs(features.entity_list:get_allies()) do
    if ally:is_hero() then
        allyChampName[i] = ally.champion_name.text
    end
end
if allyChampName [1] ~= nil then 
	allyChamp1Conf = g_config:add_int(get_prio(allyChampName[1]),allyChampName[1])
	allyChamp1 = allyTSsection:slider_int(allyChampName[1] , allyChamp1Conf,         1,        5,     1)

end
if allyChampName [2] ~= nil then 
	allyChamp2Conf = g_config:add_int(get_prio(allyChampName[2]),allyChampName[2])
	allyChamp2 = allyTSsection:slider_int(allyChampName[2] , allyChamp2Conf,         1,        5,     1)
end
if allyChampName [3] ~= nil then 
	allyChamp3Conf = g_config:add_int(get_prio(allyChampName[3]),allyChampName[3])
	allyChamp3 = allyTSsection:slider_int(allyChampName[3] , allyChamp3Conf,         1,        5,     1)
end
if allyChampName [4] ~= nil then 
	allyChamp4Conf = g_config:add_int(get_prio(allyChampName[4]),allyChampName[4])
	allyChamp4 = allyTSsection:slider_int(allyChampName[4], allyChamp4Conf,         1,        5,     1)
end
if allyChampName [5] ~= nil then 
	allyChamp5Conf = g_config:add_int(get_prio(allyChampName[5]),allyChampName[5])
	allyChamp5 = allyTSsection:slider_int(allyChampName[5] , allyChamp5Conf,         1,        5,     1)
end

ally_priority = {}

local function update_priority_ally()

    if allyChampName[1] ~= nil then ally_priority[1] = allyChamp1:get_value()  end
    if allyChampName[2] ~= nil then ally_priority[2] = allyChamp2:get_value()  end
    if allyChampName[3] ~= nil then ally_priority[3] = allyChamp3:get_value()  end
    if allyChampName[4] ~= nil then ally_priority[4] = allyChamp4:get_value()  end
    if allyChampName[5] ~= nil then ally_priority[5] = allyChamp5:get_value()  end
end


--[[
    TS <3 Nenny end
]]--


function get_target()
    update_priority_enemy()
    EnemyTarget = nil
    local prio = 0

    for i, enemy in ipairs(features.entity_list:get_enemies()) do
        if not features.target_selector:is_bad_target(enemy.index) then
            if g_local.position:dist_to(enemy.position) < 2000 then
                if enemy_priority[i] ~= 0 then 
                    if enemy_priority[i] > prio then
                    prio = enemy_priority[i] 
                    EnemyTarget = enemy
                    end
                end
            end
        end
    end
    return EnemyTarget
    
end

function get_target_ally()
    update_priority_ally()
    AllyTarget = nil
    local prio = 0

    for i, ally in ipairs(features.entity_list:get_allies()) do
        if ally:is_alive() and ally.health > 1 and ally:is_hero() and not ally:is_invalid_object() then
            if g_local.position:dist_to(ally.position) < 2000 then
                if ally_priority[i] ~= 0 then 
                    if ally_priority[i] > prio then
                    prio = ally_priority[i] 
                    AllyTarget = ally
                    end
                end
            end
        end
    end
    return AllyTarget
    
end



function NumEnemiesInRange(range)
    Prints("Enemies around")
    local numAround = 0
    for _,entity in pairs(features.entity_list:get_enemies()) do
        if  entity ~= nil and not entity:is_invisible() and entity:is_alive() and entity.position:dist_to(g_local.position) <= range  then
            numAround = numAround + 1
        end
    end
    Prints("Enemies around end")
    return numAround
end
function NumEnemiesInRangeTarget(range)
    Prints("Enemies around Target")
    update_priority_ally()
    get_target_ally()
    local target = AllyTarget
    local numAround = 0
    for _,entity in pairs(features.entity_list:get_enemies()) do
        if  entity ~= nil and not entity:is_invisible() and entity:is_alive() and entity.position:dist_to(target.position) <= range  then
            numAround = numAround + 1
        end
    end
    Prints("Enemies around Target end")
    return numAround
end



function createEnemiesList()
    return features.entity_list:get_enemies()
end

function createEnemyMinionsList()
    return features.entity_list:get_enemy_minions()
end

function getTargetMr(target)
    --return 100 / (target.MR+100)
    return 100 / (target.total_mr + 100)
end

function getTargetArmor(target)
    --return 100 / (target.armor+100)
    return 100 / (target.total_armor + 100)
end

function getDistance(from,to)
    return from:dist_to(to)
end


local mySpells = {
    q = {
        lastCast = 0,
        manaCost = {50 , 55 , 60 , 65 , 70},
        spell = g_local:get_spell_book():get_spell_slot(e_spell_slot.q),
        spellSlot = e_spell_slot.q,
        Range = 950,
        Width = 120,
        Speed = 1450,
        Level = 0,
        Base = {70, 105, 140, 175, 210},
        CastTime = 0.25,
        coolDown = {7 , 7 , 7 , 7 , 7},
    },
    
    w = {
        lastCast = 0,
        manaCost = {65, 65, 65, 65, 65},
        spell = g_local:get_spell_book():get_spell_slot(e_spell_slot.w),
        spellSlot = e_spell_slot.w,
        Range = 650,
        Speed = 2250,
        Level = 0,
        CastTimeEnemy = 0.2419,
        CastTimeAlly = 0,
        coolDown = {17, 16, 15, 14, 13}
    },
    e = {
        lastCast = 0,
        manaCost = {60, 65, 70, 75, 80},
        spell = g_local:get_spell_book():get_spell_slot(e_spell_slot.e),
        spellSlot = e_spell_slot.e,
        Range = 650,
        Level = 0,
        CastTime = 0,
        coolDown = {8, 8, 8, 8, 8}
   },
    r = {
        lastCast = 0,
        manaCost = {100, 100, 100},
        spell = g_local:get_spell_book():get_spell_slot(e_spell_slot.r),
        spellSlot = e_spell_slot.r,
        Range =  900,
        Radius = 400,
        Level = 0,
        CastTime = 0,
        coolDown = {120, 100, 80}, 
    }
}
function mySpells:refreshSpells()
    self['q'].Level = g_local:get_spell_book():get_spell_slot(e_spell_slot.q).level
    self['q'].spell = g_local:get_spell_book():get_spell_slot(e_spell_slot.q)
    self['q'].spellSlot = e_spell_slot.q

    self['w'].Level = g_local:get_spell_book():get_spell_slot(e_spell_slot.w).level
    self['w'].spell = g_local:get_spell_book():get_spell_slot(e_spell_slot.w)
    self['w'].spellSlot = e_spell_slot.w

    self['e'].Level = g_local:get_spell_book():get_spell_slot(e_spell_slot.e).level
    self['e'].spell = g_local:get_spell_book():get_spell_slot(e_spell_slot.e)
    self['e'].spellSlot = e_spell_slot.e

    self['r'].Level = g_local:get_spell_book():get_spell_slot(e_spell_slot.r).level
    self['r'].spell = g_local:get_spell_book():get_spell_slot(e_spell_slot.r)
    self['r'].spellSlot = e_spell_slot.r
end


function mySpells:isSpellReady(spell)
    if self[spell].spell:is_ready() then
        return true
    else
        return false
    end
end


function mySpells:haveEnoughMana(spell)
    if g_local.mana >= self[spell].manaCost[self[spell].Level] then
        return true
    else
        return false
    end
end


function mySpells:canCast(spell)
    self:refreshSpells()
    if self:isSpellReady(spell) and self:haveEnoughMana(spell) then
        return true
    else
        return false
    end
end




function mySpells:isSpellInRange(spell,target)
    print(self[spell].Range)
    if target.position:dist_to(g_local.position) <= self[spell].Range then
        return true
    else
        return false
    end
end


function mySpells:predPosition(spell,target)
    local pred = features.prediction:predict(target.index, self[spell].Range, self[spell].Speed, self[spell].Width, self[spell].CastTime, g_local.position)
    return pred
end







function mySpells:wSpellEnemy()
    local mode = features.orbwalker:get_mode()
    if (mode == Combo_key and checkboxw:get_value() == true) or (mode == Harass_key and checkbox_harass_w:get_value() == true) then
        if features.orbwalker:is_in_attack() == false then
            if self:canCast('w') then
                if w_pref_enemy:get_value() == true then
                    update_priority_enemy()
                    get_target()
                    local target = EnemyTarget
                    print("enemy target == " .. target.champion_name.text)
                    if target ~= nil and getDistance(g_local.position, target.position) <= self['w'].Range then
                        g_input:cast_spell(e_spell_slot.w, EnemyTarget)
                    end
                end
            end
        end
    end
end
function mySpells:wSpellAlly()
    local mode = features.orbwalker:get_mode()
    if (mode == Combo_key and checkboxw:get_value() == true) or (mode == Harass_key and checkbox_harass_w:get_value() == true) then
        if self:canCast('w') then
            if w_pref_ally:get_value() == true then
                update_priority_ally()
                get_target_ally()
                local target = AllyTarget
                print("Ally target == " .. target.champion_name.text)
                if target ~= nil and target:is_ally() and not target == g_local and getDistance(g_local.position, target.position) <= self['w'].Range then
                    local Wnum = NumEnemiesInRange(650)
                    if Wnum >= 1 then
                        g_input:cast_spell(e_spell_slot.w, AllyTarget)
                    end
                end
            end
        end
    end
end
function mySpells:wSpellSelf()
    local mode = features.orbwalker:get_mode()
    if (mode == Combo_key and checkboxw:get_value() == true) or (mode == Harass_key and checkbox_harass_w:get_value() == true) then
        if self:canCast('w') then
            if w_pref_self:get_value() == true then
                local target = g_local
                print("g_local target == " .. target.champion_name.text)
                if target ~= nil and target:is_ally() and getDistance(g_local.position, target.position) <= self['w'].Range then
                    local Wnum = NumEnemiesInRange(900)
                    if Wnum >= 1 then
                        g_input:cast_spell(e_spell_slot.w, g_local)
                    end
                end
            end
        end
    end
end
--[[function mySpells:wSpellCancel()
    if (mode == Combo_key and checkboxw:get_value() == true) or (mode == Harass_key and checkbox_harass_w:get_value() == true) then
        if self:canCast('w') then
            for i, enemy in pairs(features.entity_list:get_enemies()) do
                if getDistance(enemy.position, target.position) <= self['w'].Range then


end--]]









function mySpells:eSpellEnemy()
    local mode = features.orbwalker:get_mode()
    if (mode == Combo_key and checkboxe:get_value() == true) or (mode == Harass_key and checkbox_harass_e:get_value() == true) then
        if self:canCast('e') then
            if e_pref_enemy:get_value() == true then
                update_priority_enemy()
                get_target()
                local target = EnemyTarget
                print("enemy target == " .. target.champion_name.text)
                if target ~= nil and getDistance(g_local.position, target.position) <= self['e'].Range then
                    g_input:cast_spell(e_spell_slot.e, EnemyTarget)
                end
            end
        end
    end

end
function mySpells:eSpellAlly()
    local mode = features.orbwalker:get_mode()
    if (mode == Combo_key and checkboxe:get_value() == true) or (mode == Harass_key and checkbox_harass_e:get_value() == true) then
        if self:canCast('e') then
            if e_pref_ally:get_value() == true then
                update_priority_ally()
                get_target_ally()
                local target = AllyTarget
                print("ally target == " .. target.champion_name.text)
                for i, enemy in pairs(features.entity_list:get_enemies()) do
                    if getDistance(enemy.position, target.position) <= 2000 then
                        if enemy:get_spell_book():get_spell_cast_info():get_target_index() == target.index or enemy:get_spell_book():get_spell_cast_info():get_target_index() ~= nil or features.evade:is_position_safe(target.position, false) == false then
                            print("enemies target = " .. enemy:get_spell_book():get_spell_cast_info():get_target_index())
                            print("AllyTarget = " .. target.index)
                            if target ~= nil and target:is_ally() and getDistance(g_local.position, target.position) <= self['e'].Range then
                                g_input:cast_spell(e_spell_slot.e, target)
                            end
                        end
                    end
                end
            end
        end
    end
end
function mySpells:eSpellSelf()
    local mode = features.orbwalker:get_mode()
    if (mode == Combo_key and checkboxe:get_value() == true) or (mode == Harass_key and checkbox_harass_e:get_value() == true) then
        if self:canCast('e') then
            if e_pref_self:get_value() == true then
                update_priority_ally()
                get_target_ally()
                local target = g_local
                print("g_local target == " .. target.champion_name.text)
                if target ~= nil and target:is_ally() and getDistance(g_local.position, target.position) <= self['e'].Range then
                    for i, enemy in pairs(features.entity_list:get_enemies()) do
                        if getDistance(enemy.position, target.position) <= 2000 then
                            if enemy:get_spell_book():get_spell_cast_info():get_target_index() == target.index or enemy:get_spell_book():get_spell_cast_info():get_target_index() ~= nil or features.evade:is_position_safe(g_local.position, false) == false then
                                print("enemies target = " .. enemy:get_spell_book():get_spell_cast_info():get_target_index())
                                print("AllyTarget = " .. target.index)
                                if target ~= nil and target:is_ally() and getDistance(g_local.position, target.position) <= self['e'].Range then
                                    g_input:cast_spell(e_spell_slot.e, target)
                                end
                            end
                        end
                    end
                end
            end
        end
    end
end











function mySpells:qSpell()
    local mode = features.orbwalker:get_mode()
    
    if (mode == Combo_key and checkboxq:get_value() == true) or (mode == Harass_key and checkbox_harass_q:get_value() == true) then
        if features.orbwalker:is_in_attack() == false and features.evade:is_active() == false then
            if self:canCast('q') then
                local target = features.target_selector:get_default_target()
                if target ~= nil and getDistance(g_local.position, target.position) < self['q'].Range then
                    local qHit = features.prediction:predict(target.index, self['q'].Range, self['q'].Speed, self['q'].Width, 0, g_local.position)
                    if (qHit.valid and qHit.hitchance >= acc_q_slider:get_value()) then
                        g_input:cast_spell(e_spell_slot.q, qHit.position)
                    end
                end
            end
        end
    end

    if (mode == Combo_key and checkboxq:get_value() == true) or (mode == Harass_key and checkbox_harass_q:get_value() == true) then
        if features.orbwalker:is_in_attack() == false and features.evade:is_active() == false then
            if self:canCast('q') then
                local target = features.target_selector:get_default_target()
                if target ~= nil and getDistance(g_local.position, target.position) >= self['q'].Range then
                    for i, obj in pairs(features.entity_list:get_all()) do
                        if obj:dist_to_local() <= 1950 then
                            if obj:get_object_name() == "LuluFaerie" then
                                local qHit2 = features.prediction:predict(target.index, self['q'].Range, self['q'].Speed, self['q'].Width, 0, obj.position)
                                if (qHit2.valid and qHit2.hitchance >= acc_q_slider:get_value()) and getDistance(target.position, obj.position) < self['q'].Range then
                                    g_input:cast_spell(e_spell_slot.q, qHit2.position)
                                end
                            end
                        end
                    end
                end
            end
        end
    end


end

function mySpells:wSpell()
    if w_pref_enemy:get_value() == true then
        mySpells:wSpellEnemy()
    end
    if w_pref_ally:get_value() == true then
        mySpells:wSpellAlly()
    end
    if w_pref_self:get_value() == true then
        mySpells:wSpellSelf()
    end
end

function mySpells:eSpell()
    if e_pref_enemy:get_value() == true then
        mySpells:eSpellEnemy()
    end
    if e_pref_ally:get_value() == true then
        mySpells:eSpellAlly()
    end
    if e_pref_self:get_value() == true then
        mySpells:eSpellSelf()
    end
end



function mySpells:rSpell()
    local mode = features.orbwalker:get_mode()

    --R for peel (ally)
    if mode == Combo_key and checkboxr:get_value() == true then
        if self:canCast('r') then
            update_priority_ally()
            get_target_ally()
            local target = AllyTarget
            if target ~= nil and target:is_ally() and not target:is_local() and getDistance(g_local.position, target.position) <= self['r'].Range then
            local Rnum = NumEnemiesInRangeTarget(380)
                if Rnum >= rslider:get_value() then
                    g_input:cast_spell(e_spell_slot.r, target)
                end
            end
        end
    end
    --R for health (ally)
    if mode == Combo_key and checkboxr:get_value() == true then
        if self:canCast('r') then
            update_priority_ally()
            get_target_ally()
            local target = AllyTarget
            if target ~= nil and target:is_ally() and not target:is_local() and getDistance(g_local.position, target.position) <= self['r'].Range then
                if NumEnemiesInRangeTarget(900) >= 1 then
                    if features.evade:is_position_safe(target.position, false) == false and (target.health / target.max_health) * 100 <= r_health_slider:get_value() and target.health ~= 0 then
                        g_input:cast_spell(e_spell_slot.r, target)
                    end
                end
            end
        end
    end



    --R for health (self)
    if mode == Combo_key or Harass_key or Flee_key and checkboxr:get_value() == true then
        if self:canCast('r') then
            if (g_local.health / g_local.max_health) * 100 <= r_health_slider:get_value() and g_local.health ~= 0 then
                if NumEnemiesInRange(900) >= 1 then
                    for i, enemy in pairs(features.entity_list:get_enemies()) do
                        if getDistance(enemy.position, g_local.position) <= 2000 then
                            if enemy:get_spell_book():get_spell_cast_info():get_target_index() == g_local.index or enemy:get_spell_book():get_spell_cast_info():get_target_index() ~= nil then
                                if features.evade:is_position_safe(g_local.position, false) == false then
                                    g_input:cast_spell(e_spell_slot.r, g_local.position)
                                end
                            end
                        end
                    end
                end
            end
        end
    end
    --R for peel (Self)
    if mode == Combo_key and checkboxr:get_value() == true then
        if self:canCast('r') then
            local Rnum = NumEnemiesInRange(380)
            print("RNum ==" .. Rnum)
            if Rnum >= rslider:get_value() then
                g_input:cast_spell(e_spell_slot.r, g_local.position)
            end
        end
    end





end


--draws
cheat.register_callback("render", function()
    if checkbox_q_drawings:get_value() == true and g_local:get_spell_book():get_spell_slot(e_spell_slot.q):is_ready() then
      purple = color:new(201, 7, 245)
      g_render:circle_3d(g_local.position, purple, self['q'].Range, 2, 100, 2)
    end
end)
--Q Pix
cheat.register_callback("render", function()
    if checkbox_pix_drawings:get_value() == true and g_local:get_spell_book():get_spell_slot(e_spell_slot.q):is_ready() then
        for i, obj in pairs(features.entity_list:get_all()) do
            if obj:dist_to_local() <= 1950 then
                if obj:get_object_name() == "LuluFaerie" then
                    purple = color:new(201, 7, 245)
                    g_render:circle_3d(obj.position, purple, 825, 2, 100, 2)
                end
            end
        end
    end
end)
cheat.register_callback("render", function()
    if checkbox_w_drawings:get_value() == true and g_local:get_spell_book():get_spell_slot(e_spell_slot.w):is_ready() then
      green = color:new(0, 255, 21)
      g_render:circle_3d(g_local.position, green, self['w'].Range, 2, 100, 2)
    end
end)
cheat.register_callback("render", function()
    if checkbox_e_drawings:get_value() == true and g_local:get_spell_book():get_spell_slot(e_spell_slot.e):is_ready() then
      blue = color:new(76, 0, 255)
      g_render:circle_3d(g_local.position, blue, self['e'].Range, 2, 100, 2)
    end
end)

cheat.register_callback("pre-feature", get_target)
cheat.register_callback("pre-feature", get_target_ally)

cheat.register_module(
    {
        champion_name = "Lulu",

        spell_q = function()
            mySpells:qSpell()
        end,


        spell_w = function()
            mySpells:wSpell()
        end,


        spell_e = function()
            mySpells:eSpell()
        end,

        spell_r = function()
            mySpells:rSpell()
        end,

        
        get_priorities = function()
            return {
            "spell_e",
            "spell_w",
            "spell_q",
            "spell_r",
            }
        end
    }
)
