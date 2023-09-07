MEMORY_TABLE = {}

NAOMI_CVS2_MEMORY_TABLE = {
    ['game_timer'] = 0x8C2259C4,
    ['game_timer_ms'] = 0x8C2259C6,
    ['stage_id'] = 0x8C18A5B0,
    ['p1_facing_right'] = 0x8C241A1A,
    ['p1_char_id'] = 0x8C241861,
    ['p1_health'] = 0x8C2419A8,
    ['p1_max_health'] = 0x8C2419AC,
    ['p1_team1'] = 0x8C241D80,
    ['p1_team2'] = 0x8C241D81,
    ['p1_team3'] = 0x8C241D82,
    ['p1_ratio'] = 0x8C2419C0,
    ['p1_groove'] = 0x8C241D90,
    ['p1_power'] = 0x8C2419C0,
    ['p2_facing_right'] = 0x8C241FE6,
    ['p2_char_id'] = 0x8C241E2D,
    ['p2_health'] = 0x8C241F74,
    ['p2_max_health'] = 0x8C241F78,
    ['p2_team1'] = 0x8C24234C,
    ['p2_team2'] = 0x8C24234D,
    ['p2_team3'] = 0x8C24234E,
    ['p2_ratio'] = 0x8C241F8C,
    ['p2_groove'] = 0x8C24235C,
    ['p2_power'] = 0x8C242012,
    ['p1_damage'] = 0x8C25E008,
    ['p1_combo_damage'] = 0x8C25E00C,
    ['p1_max_combo'] = 0x8C2419F5
}

DC_CVS2_MEMORY_TABLE = {
    ['game_timer'] = 0x0C332AF8,
    ['game_timer_ms'] = 0x0C332AFA,
    ['stage_id'] = 0x0C332FC4,
    ['p1_facing_right'] = 0x0C34EB5A,
    ['p1_char_id'] = 0x0C34E9A1,
    ['p1_health'] = 0x0C34EAE8,
    ['p1_max_health'] = 0x0C34EAEC,
    ['p1_team1'] = 0x0C34EEC0,
    ['p1_team2'] = 0x0C34EEC1,
    ['p1_team3'] = 0x0C34EEC2,
    ['p1_ratio'] = 0x0C34EB00,
    ['p1_groove'] = 0x0C34EB7B,
    ['p1_power'] = 0x0C34EB86,
    ['p2_facing_right'] = 0x0C34F12E,
    ['p2_char_id'] = 0x0C34EF75,
    ['p2_health'] = 0x0C34F0BC,
    ['p2_max_health'] = 0x0C34F0C0,
    ['p2_team1'] = 0x0C34F494,
    ['p2_team2'] = 0x0C34F495,
    ['p2_team3'] = 0x0C34F496,
    ['p2_ratio'] = 0x0C34F0D4,
    ['p2_groove'] = 0x0C34F14F,
    ['p2_power'] = 0x0C34F15A,
    ['p1_damage'] = 0x0C36B418,
    ['p1_combo_damage'] = 0x0C36B420,
    ['p1_max_combo'] = 0x0C34EB35
}

CHARACTER = {"Ryu", "Ken", "Chun-Li", "Guile", "Zangief", "Dhalsim", "E. Honda", "Blanka", "Claw", "Sagat", "Dictator",
             "Sakura", "Cammy", "Akuma", "Morrigan", "Evil Ryu", "Kyo", "Iori", "Terry", "Ryo", "Mai", "Kim", "Geese",
             "Yamazaki", "Raiden", "Rugal", "Vice", "Benimaru", "Yuri", "King", "Nakoruru", "Orochi Iori", "Boxer",
             "Dan", "Joe", "Eagle", "Maki", "Kyosuke", "Athena", "Chang", "Todo", "Rock", "Hibiki", "Haohmaru", "Yun",
             "Shin Akuma", "Ultimate Rugal", "Rolento"}

GROOVES = {"C", "A", "P", "S", "N", "K"}

GROOVE_COLORS = {{0.11, 0.98, 0, 0.8}, {0, 0.82, 1, 0.8}, {0, 0.83, 0.63, 0.8}, {0.72, 0.39, 0.96, 0.8}, {1, 1, 0, 0.8},
                 {0.96, 0, 0, 0.8}}

STAGES = {"Aomori", "Shanghai", "Nairobi", "Kinderdijk", "London", "Barentsburg", "New York", "Osaka",
          "Osaka Tower Rooftop", "Osaka In Flames", "Training"}

freeze_timer = true;

function cbStart()
    local s = flycast.state
    print("Game started: " .. s.media)
    print("Game Id: " .. s.gameId)
    print("Display: " .. s.display.width .. "x" .. s.display.height)
end

function cbOverlay()
    local ui = flycast.ui
    local MEMORY = flycast.memory

    if (flycast.state.gameId == 'CAPCOM VS SNK 2  JAPAN') then
        MEMORY_TABLE = NAOMI_CVS2_MEMORY_TABLE
    elseif (flycast.state.gameId == 'T1249M') then
        MEMORY_TABLE = DC_CVS2_MEMORY_TABLE
    end

    if MEMORY_TABLE == {} then
        return
    end

    if freeze_timer then
        if MEMORY.read8(MEMORY_TABLE.p1_facing_right) ~= MEMORY.read8(MEMORY_TABLE.p2_facing_right) then
            MEMORY.write8(MEMORY_TABLE.game_timer, 99)
            MEMORY.write8(MEMORY_TABLE.game_timer_ms, 59)
        end
    end

    if MEMORY.read8(MEMORY_TABLE.p1_facing_right) ~= MEMORY.read8(MEMORY_TABLE.p2_facing_right) and
        flycast.config.dojo.ShowTrainingGameOverlay then
        ui.beginWindow("Game", 10, 10, 300, 0)
        ui.text("Game Timer")
        ui.rightText(MEMORY.read8(MEMORY_TABLE.game_timer))

        ui.text("Stage")
        ui.rightText(STAGES[MEMORY.read8(MEMORY_TABLE.stage_id) + 1])

        if freeze_timer then
            ui.button('Unfreeze Timer', function()
                freeze_timer = false
            end)
        else
            ui.button('Freeze Timer', function()
                freeze_timer = true
            end)
        end
        ui.endWindow()

        ui.beginWindow("Attack Data", math.floor((flycast.state.display.width / 2) - 125),
            math.floor((flycast.state.display.height / 4) - 50), 250, 0)

        ui.text("Damage")
        ui.rightText(MEMORY.read16(MEMORY_TABLE.p1_damage))

        ui.text("Combo Damage")
        ui.rightText(MEMORY.read16(MEMORY_TABLE.p1_combo_damage))

        ui.text("Max Combo")
        ui.rightText(MEMORY.read8(MEMORY_TABLE.p1_max_combo))

        ui.endWindow()

        ui.beginWindow("P1", math.floor((flycast.state.display.width / 4) - 125),
            math.floor((flycast.state.display.height / 4) - 50), 250, 0)

        ui.text(CHARACTER[MEMORY.read8(MEMORY_TABLE.p1_char_id) + 1])

        if MEMORY.read8(MEMORY_TABLE.p1_health) ~= 255 then
            p1_health = MEMORY.read16(MEMORY_TABLE.p1_health)
            p1_max_health = MEMORY.read16(MEMORY_TABLE.p1_max_health)

            if p1_health >= math.floor(0.75 * p1_max_health) then
                ui.rightTextColor(p1_health, 0.99, 0.99, 0.11, 0.8)
            elseif p1_health >= math.floor(0.5 * p1_max_health) then
                ui.rightTextColor(p1_health, 0.99, 0.76, 0.03, 0.8)
            elseif p1_health >= math.floor(0.25 * p1_max_health) then
                ui.rightTextColor(p1_health, 0.99, 0.44, 0.03, 0.8)
            else
                ui.rightTextColor(p1_health, 0.99, 0.24, 0.03, 0.8)
            end
        end

        ui.text("Ratio")
        p1_ratio = MEMORY.read8(MEMORY_TABLE.p1_ratio) + 1
        if p1_ratio == 4 then
            ui.rightTextColor(p1_ratio, 0.73, 0.54, 0.99, 0.8)
        elseif p1_ratio == 3 then
            ui.rightTextColor(p1_ratio, 0, 0.83, 0.99, 0.8)
        elseif p1_ratio == 2 then
            ui.rightTextColor(p1_ratio, 0.12, 0.98, 0.03, 0.8)
        elseif p1_ratio == 1 then
            ui.rightTextColor(p1_ratio, 0.99, 0.98, 0.03, 0.8)
        end

        p1_team1 = ""
        p1_team2 = ""
        p1_team3 = ""

        if MEMORY.read8(MEMORY_TABLE.p1_team1) < 49 then
            p1_team1 = CHARACTER[MEMORY.read8(MEMORY_TABLE.p1_team1) + 1]
        end

        if (p1_ratio < 4) then
            if MEMORY.read8(MEMORY_TABLE.p1_team2) < 49 then
                p1_team2 = CHARACTER[MEMORY.read8(MEMORY_TABLE.p1_team2) + 1]
            end

            if MEMORY.read8(MEMORY_TABLE.p1_team3) < 49 then
                p1_team3 = CHARACTER[MEMORY.read8(MEMORY_TABLE.p1_team3) + 1]
            end
        end

        ui.text("Team")
        ui.sameLinePlaceholderRight(p1_team1 .. p1_team2 .. p1_team3 .. "    ")
        if (p1_team1 == CHARACTER[MEMORY.read8(MEMORY_TABLE.p1_char_id) + 1]) then
            ui.textColor(p1_team1, 250, 250, 0, 0.8)
        else
            ui.text(p1_team1)
        end
        ui.sameLine()

        if (p1_team2 == CHARACTER[MEMORY.read8(MEMORY_TABLE.p1_char_id) + 1]) then
            ui.textColor(p1_team2, 250, 250, 0, 0.8)
        else
            ui.text(p1_team2)
        end
        ui.sameLine()

        if (p1_team3 == CHARACTER[MEMORY.read8(MEMORY_TABLE.p1_char_id) + 1]) then
            ui.textColor(p1_team3, 250, 250, 0, 0.8)
        else
            ui.text(p1_team3)
        end

        ui.text("Groove")
        grcolor = GROOVE_COLORS[MEMORY.read8(MEMORY_TABLE.p1_groove) + 1]
        ui.rightTextColor(GROOVES[MEMORY.read8(MEMORY_TABLE.p1_groove) + 1], grcolor[1], grcolor[2], grcolor[3],
            grcolor[4])

        ui.text("Facing")
        if MEMORY.read8(MEMORY_TABLE.p1_facing_right) == 1 then
            ui.rightText("Right")
        else
            ui.rightText("Left")
        end

        ui.endWindow()

        ui.beginWindow("P1 Dummy", math.floor((flycast.state.display.width / 4) - 250),
            math.floor((flycast.state.display.height * (3 / 4))) - 125, 125, 0)
        ui.button('Jump', function()
            jump(1)
        end)
        ui.button('Toward', function()
            forward(1, MEMORY.read8(MEMORY_TABLE.p1_facing_right))
        end)
        ui.button('Away', function()
            block(1, MEMORY.read8(MEMORY_TABLE.p1_facing_right))
        end)
        ui.button('Crouch', function()
            crouch(1)
        end)
        ui.button('Release', function()
            release_all(1)
        end)

        ui.button('Forfeit', function()
            MEMORY.write16(MEMORY_TABLE.p1_health, 0)
            MEMORY.write8(MEMORY_TABLE.game_timer, 0)
            MEMORY.write8(MEMORY_TABLE.game_timer_ms, 0)
        end)

        ui.button('Restore Health', function()
            max_health = MEMORY.read16(MEMORY_TABLE.p1_max_health)
            MEMORY.write16(MEMORY_TABLE.p1_health, max_health)
        end)

        ui.endWindow()

        ui.beginWindow("P2", math.floor((flycast.state.display.width * (3 / 4)) - 125),
            math.floor((flycast.state.display.height / 4) - 50), 250, 0)

        ui.text(CHARACTER[MEMORY.read8(MEMORY_TABLE.p2_char_id) + 1])
        if MEMORY.read8(MEMORY_TABLE.p2_health) ~= 255 then
            p2_health = MEMORY.read16(MEMORY_TABLE.p2_health)
            p2_max_health = MEMORY.read16(MEMORY_TABLE.p2_max_health)

            if p2_health >= math.floor(0.75 * p2_max_health) then
                ui.rightTextColor(p2_health, 0.99, 0.99, 0.11, 0.8)
            elseif p2_health >= math.floor(0.5 * p2_max_health) then
                ui.rightTextColor(p2_health, 0.99, 0.76, 0.03, 0.8)
            elseif p2_health >= math.floor(0.25 * p2_max_health) then
                ui.rightTextColor(p2_health, 0.99, 0.44, 0.03, 0.8)
            else
                ui.rightTextColor(p2_health, 0.99, 0.24, 0.03, 0.8)
            end
        end

        ui.text("Ratio")
        p2_ratio = MEMORY.read8(MEMORY_TABLE.p2_ratio) + 1
        if p2_ratio == 4 then
            ui.rightTextColor(p2_ratio, 0.73, 0.54, 0.99, 0.8)
        elseif p2_ratio == 3 then
            ui.rightTextColor(p2_ratio, 0, 0.83, 0.99, 0.8)
        elseif p2_ratio == 2 then
            ui.rightTextColor(p2_ratio, 0.12, 0.98, 0.03, 0.8)
        elseif p2_ratio == 1 then
            ui.rightTextColor(p2_ratio, 0.99, 0.98, 0.03, 0.8)
        end

        p2_team1 = ""
        p2_team2 = ""
        p2_team3 = ""

        if MEMORY.read8(MEMORY_TABLE.p2_team1) < 49 then
            p2_team1 = CHARACTER[MEMORY.read8(MEMORY_TABLE.p2_team1) + 1]
        end

        if (p2_ratio < 4) then
            if MEMORY.read8(MEMORY_TABLE.p2_team2) < 49 then
                p2_team2 = CHARACTER[MEMORY.read8(MEMORY_TABLE.p2_team2) + 1]
            end

            if MEMORY.read8(MEMORY_TABLE.p2_team3) < 49 then
                p2_team3 = CHARACTER[MEMORY.read8(MEMORY_TABLE.p2_team3) + 1]
            end
        end

        ui.text("Team")
        ui.sameLinePlaceholderRight(p2_team1 .. p2_team2 .. p2_team3 .. "    ")
        if (p2_team1 == CHARACTER[MEMORY.read8(MEMORY_TABLE.p2_char_id) + 1]) then
            ui.textColor(p2_team1, 250, 250, 0, 0.8)
        else
            ui.text(p2_team1)
        end
        ui.sameLine()

        if (p2_team2 == CHARACTER[MEMORY.read8(MEMORY_TABLE.p2_char_id) + 1]) then
            ui.textColor(p2_team2, 250, 250, 0, 0.8)
        else
            ui.text(p2_team2)
        end
        ui.sameLine()

        if (p2_team3 == CHARACTER[MEMORY.read8(MEMORY_TABLE.p2_char_id) + 1]) then
            ui.textColor(p2_team3, 250, 250, 0, 0.8)
        else
            ui.text(p2_team3)
        end

        ui.text("Groove")
        grcolor = GROOVE_COLORS[MEMORY.read8(MEMORY_TABLE.p2_groove) + 1]
        ui.rightTextColor(GROOVES[MEMORY.read8(MEMORY_TABLE.p2_groove) + 1], grcolor[1], grcolor[2], grcolor[3],
            grcolor[4])

        ui.text("Facing")
        if MEMORY.read8(MEMORY_TABLE.p2_facing_right) == 1 then
            ui.rightText("Right")
        else
            ui.rightText("Left")
        end

        ui.endWindow()

        ui.beginWindow("P2 Dummy", math.floor(flycast.state.display.width * (3 / 4)) + 125,
            math.floor(flycast.state.display.height * (3 / 4)) - 125, 125, 0)

        ui.button('Jump', function()
            jump(2)
        end)
        ui.button('Toward', function()
            forward(2, MEMORY.read8(MEMORY_TABLE.p2_facing_right))
        end)
        ui.button('Away', function()
            block(2, MEMORY.read8(MEMORY_TABLE.p2_facing_right))
        end)
        ui.button('Crouch', function()
            crouch(2)
        end)
        ui.button('Release', function()
            release_all(2)
        end)

        ui.button('Forfeit', function()
            MEMORY.write16(MEMORY_TABLE.p2_health, 0)
            MEMORY.write8(MEMORY_TABLE.game_timer, 0)
            MEMORY.write8(MEMORY_TABLE.game_timer_ms, 0)
        end)

        ui.button('Restore Health', function()
            max_health = MEMORY.read16(MEMORY_TABLE.p2_max_health)
            MEMORY.write16(MEMORY_TABLE.p2_health, max_health)
        end)

        ui.endWindow()
    end
end

function dummy_action_buttons(player)
end

function switch_character_a(player)
    release_all(player)

    local BTN_B = 1 << 1
    local BTN_A = 1 << 2
    local BTN_Y = 1 << 9
    local BTN_X = 1 << 10
    flycast.input.pressButtons(player, BTN_X | BTN_A)
end

function switch_character_b(player)
    release_all(player)

    local BTN_B = 1 << 1
    local BTN_A = 1 << 2
    local BTN_Y = 1 << 9
    local BTN_X = 1 << 10
    flycast.input.pressButtons(player, BTN_Y | BTN_B)
end

function jump(player)
    local DPAD_DOWN = 1 << 5
    local DPAD_UP = 1 << 4
    flycast.input.releaseButtons(player, DPAD_DOWN)
    flycast.input.pressButtons(player, DPAD_UP)
end

function forward(player, facing_right)
    local DPAD_LEFT = 1 << 6
    local DPAD_RIGHT = 1 << 7
    if facing_right == 1 then
        flycast.input.releaseButtons(player, DPAD_LEFT)
        flycast.input.pressButtons(player, DPAD_RIGHT)
    else
        flycast.input.releaseButtons(player, DPAD_RIGHT)
        flycast.input.pressButtons(player, DPAD_LEFT)
    end
end

function block(player, facing_right)
    local DPAD_LEFT = 1 << 6
    local DPAD_RIGHT = 1 << 7
    if facing_right == 1 then
        flycast.input.releaseButtons(player, DPAD_RIGHT)
        flycast.input.pressButtons(player, DPAD_LEFT)
    else
        flycast.input.releaseButtons(player, DPAD_LEFT)
        flycast.input.pressButtons(player, DPAD_RIGHT)
    end
end

function crouch(player)
    local DPAD_UP = 1 << 4
    local DPAD_DOWN = 1 << 5

    flycast.input.releaseButtons(player, DPAD_UP)
    flycast.input.pressButtons(player, DPAD_DOWN)
end

function crouch_block(player, facing_right)
    release_all(player)
    local DPAD_DOWN = 1 << 5
    local DPAD_LEFT = 1 << 6
    local DPAD_RIGHT = 1 << 7

    if facing_right == 1 then
        flycast.input.pressButtons(player, DPAD_DOWN | DPAD_LEFT)
    else
        flycast.input.pressButtons(player, DPAD_DOWN | DPAD_RIGHT)
    end
end

function release_all(player)
    local DPAD_UP = 1 << 4
    local DPAD_DOWN = 1 << 5
    local DPAD_LEFT = 1 << 6
    local DPAD_RIGHT = 1 << 7

    local BTN_B = 1 << 1
    local BTN_A = 1 << 2
    local BTN_Y = 1 << 9
    local BTN_X = 1 << 10

    flycast.input.releaseButtons(player, DPAD_UP | DPAD_DOWN | DPAD_LEFT | DPAD_RIGHT)
    flycast.input.releaseButtons(player, BTN_X | BTN_A | BTN_Y | BTN_B)
end

flycast_callbacks = {
    start = cbStart,
    overlay = cbOverlay
}

print("Callback set")
