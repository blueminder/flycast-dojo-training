DC_MVC2_MEMORY_TABLE = {
    ['game_timer'] = 0x2C289630,
    ['stage_id'] = 0x2C289638,
    ['stage_id_select'] = 0x22C26A95C,
    ['p1_level'] = 0x2C28964A,
    ['p1_char1_facing_right'] = 0x2C268450,
    ['p1_char2_facing_right'] = 0x2C268F98,
    ['p1_char3_facing_right'] = 0x2C269AE0,
    ['p1_char1_id'] = 0x2C268341,
    ['p1_char2_id'] = 0x2C268E89,
    ['p1_char3_id'] = 0x2C2699D1,
    ['p1_char1_active'] = 0x2C268340,
    ['p1_char2_active'] = 0x2C268E88,
    ['p1_char3_active'] = 0x2C2699D0,
    ['p1_char1_health'] = 0x2C268760,
    ['p1_char2_health'] = 0x2C2692A8,
    ['p1_char3_health'] = 0x2C269DF0,
    ['p2_level'] = 0x2C28964B,
    ['p2_char1_facing_right'] = 0x2C2689F4,
    ['p2_char2_facing_right'] = 0x2C26953C,
    ['p2_char3_facing_right'] = 0x2C26A084,
    ['p2_char1_id'] = 0x2C2688E5,
    ['p2_char2_id'] = 0x2C26942D,
    ['p2_char3_id'] = 0x2C269F75,
    ['p2_char1_active'] = 0x2C2688E4,
    ['p2_char2_active'] = 0x2C26942C,
    ['p2_char3_active'] = 0x2C269F74,
    ['p2_char1_health'] = 0x2C268D04,
    ['p2_char2_health'] = 0x2C26984C,
    ['p2_char3_health'] = 0x2C26A394,
    ['in_match'] = 0x2C289624
}

CHARACTER = {"Ryu", "Zangief", "Guile", "Morrigan", "Anakaris", "Strider", "Cyclops", "Wolverine", "Psylocke", "Iceman",
             "Rogue", "Captain America", "Spider-Man", "Hulk", "Venom", "Dr. Doom", "Tron Bonne", "Jill", "Hayato",
             "Ruby Heart", "Son Son", "Amingo", "Marrow", "Cable", "Abyss 1", "Abyss 2", "Abyss 3", "Chun-Li",
             "Mega Man", "Roll", "Akuma", "Bulleta", "Felicia", "Charlie", "Sakura", "Dan", "Cammy", "Dhalsim",
             "Dictator", "Ken", "Gambit", "Juggernaut", "Storm", "Sabretooth", "Magneto", "Shuma Gorath", "War Machine",
             "Silver Samurai", "Omega Red", "Spiral", "Colossus", "Iron Man", "Sentinel", "Blackheart", "Thanos", "Jin",
             "Captain Commando", "Bone Wolverine", "Servbot"}

STAGES = {"Airship", "Desert", "Industrial", "Circus", "Swamp", "Cavern", "Clock Tower", "River", "Abyss Temple",
          "Airship (Alt)", "Desert (Alt)", "Training", "Circus (Alt)", "Swamp (Alt)", "Cavern (Alt)",
          "Clock Tower (Alt)", "River (Alt)"}

function cbStart()
    local s = flycast.state
    print("Game started: " .. s.media)
    print("Game Id: " .. s.gameId)
    print("Display: " .. s.display.width .. "x" .. s.display.height)
end

function cbOverlay()
    local ui = flycast.ui
    local MEMORY = flycast.memory

    if MEMORY.read8(DC_MVC2_MEMORY_TABLE.stage_id) == MEMORY.read8(DC_MVC2_MEMORY_TABLE.stage_id_select) and
        MEMORY.read8(DC_MVC2_MEMORY_TABLE.in_match) == 1 then
        MEMORY.write8(DC_MVC2_MEMORY_TABLE.game_timer, 99)

        ui.beginWindow("Game", 10, 10, 300, 0)
        ui.text("Game Timer")
        ui.rightText(MEMORY.read8(DC_MVC2_MEMORY_TABLE.game_timer))

        ui.text("Stage")
        ui.rightText(STAGES[MEMORY.read8(DC_MVC2_MEMORY_TABLE.stage_id) + 1])
        ui.endWindow()

        ui.beginWindow("P1", math.floor((flycast.state.display.width / 4) - 125),
            math.floor((flycast.state.display.height / 4) - 50), 250, 0)

        if MEMORY.read8(DC_MVC2_MEMORY_TABLE.p1_char1_active) == 1 then
            ui.text("* " .. CHARACTER[MEMORY.read8(DC_MVC2_MEMORY_TABLE.p1_char1_id) + 1])
        else
            ui.text(CHARACTER[MEMORY.read8(DC_MVC2_MEMORY_TABLE.p1_char1_id) + 1])
        end
        ui.rightText(MEMORY.read8(DC_MVC2_MEMORY_TABLE.p1_char1_health))

        if MEMORY.read8(DC_MVC2_MEMORY_TABLE.p1_char2_active) == 1 then
            ui.text("* " .. CHARACTER[MEMORY.read8(DC_MVC2_MEMORY_TABLE.p1_char2_id) + 1])
        else
            ui.text(CHARACTER[MEMORY.read8(DC_MVC2_MEMORY_TABLE.p1_char2_id) + 1])
        end
        ui.rightText(MEMORY.read8(DC_MVC2_MEMORY_TABLE.p1_char2_health))

        if MEMORY.read8(DC_MVC2_MEMORY_TABLE.p1_char3_active) == 1 then
            ui.text("* " .. CHARACTER[MEMORY.read8(DC_MVC2_MEMORY_TABLE.p1_char3_id) + 1])
        else
            ui.text(CHARACTER[MEMORY.read8(DC_MVC2_MEMORY_TABLE.p1_char3_id) + 1])
        end
        ui.rightText(MEMORY.read8(DC_MVC2_MEMORY_TABLE.p1_char3_health))

        ui.text("")

        ui.text("Level")
        ui.rightText(MEMORY.read8(DC_MVC2_MEMORY_TABLE.p1_level))

        if MEMORY.read8(DC_MVC2_MEMORY_TABLE.p1_char1_active) == 1 then
            ui.text("Character 1 Facing")
            if MEMORY.read8(DC_MVC2_MEMORY_TABLE.p1_char1_facing_right) == 1 then
                ui.rightText("Right")
            else
                ui.rightText("Left")
            end
        end

        if MEMORY.read8(DC_MVC2_MEMORY_TABLE.p1_char2_active) == 1 then
            ui.text("Character 2 Facing")
            if MEMORY.read8(DC_MVC2_MEMORY_TABLE.p1_char2_facing_right) == 1 then
                ui.rightText("Right")
            else
                ui.rightText("Left")
            end
        end

        if MEMORY.read8(DC_MVC2_MEMORY_TABLE.p1_char3_active) == 1 then
            ui.text("Character 3 Facing")
            if MEMORY.read8(DC_MVC2_MEMORY_TABLE.p1_char3_facing_right) == 1 then
                ui.rightText("Right")
            else
                ui.rightText("Left")
            end
        end

        ui.endWindow()

        ui.beginWindow("P1 Dummy", math.floor((flycast.state.display.width / 4) - 250),
            math.floor((flycast.state.display.height * (3 / 4))) - 125, 160, 0)

        ui.button('Switch Character A', function()
            switch_character_a(1)
        end)
        ui.button('Switch Character B', function()
            switch_character_b(1)
        end)

        ui.button('Jump', function()
            jump(1)
        end)
        ui.button('Forward', function()
            forward(1, MEMORY.read8(DC_MVC2_MEMORY_TABLE.p1_char1_facing_right))
        end)
        ui.button('Back', function()
            block(1, MEMORY.read8(DC_MVC2_MEMORY_TABLE.p1_char1_facing_right))
        end)
        ui.button('Crouch', function()
            crouch(1)
        end)
        ui.button('Release', function()
            release_all(1)
        end)

        ui.endWindow()

        ui.beginWindow("P2", math.floor((flycast.state.display.width * (3 / 4)) - 125),
            math.floor((flycast.state.display.height / 4) - 50), 250, 0)

        if MEMORY.read8(DC_MVC2_MEMORY_TABLE.p2_char1_active) == 1 then
            ui.text("* " .. CHARACTER[MEMORY.read8(DC_MVC2_MEMORY_TABLE.p2_char1_id) + 1])
        else
            ui.text(CHARACTER[MEMORY.read8(DC_MVC2_MEMORY_TABLE.p2_char1_id) + 1])
        end
        ui.rightText(MEMORY.read8(DC_MVC2_MEMORY_TABLE.p2_char1_health))

        if MEMORY.read8(DC_MVC2_MEMORY_TABLE.p2_char2_active) == 1 then
            ui.text("* " .. CHARACTER[MEMORY.read8(DC_MVC2_MEMORY_TABLE.p2_char2_id) + 1])
        else
            ui.text(CHARACTER[MEMORY.read8(DC_MVC2_MEMORY_TABLE.p2_char2_id) + 1])
        end
        ui.rightText(MEMORY.read8(DC_MVC2_MEMORY_TABLE.p2_char2_health))

        if MEMORY.read8(DC_MVC2_MEMORY_TABLE.p2_char3_active) == 1 then
            ui.text("* " .. CHARACTER[MEMORY.read8(DC_MVC2_MEMORY_TABLE.p2_char3_id) + 1])
        else
            ui.text(CHARACTER[MEMORY.read8(DC_MVC2_MEMORY_TABLE.p2_char3_id) + 1])
        end
        ui.rightText(MEMORY.read8(DC_MVC2_MEMORY_TABLE.p2_char3_health))

        ui.text("")

        ui.text("Level")
        ui.rightText(MEMORY.read8(DC_MVC2_MEMORY_TABLE.p2_level))

        if MEMORY.read8(DC_MVC2_MEMORY_TABLE.p2_char1_active) == 1 then
            ui.text("Character 1 Facing")
            if MEMORY.read8(DC_MVC2_MEMORY_TABLE.p2_char1_facing_right) == 1 then
                ui.rightText("Right")
            else
                ui.rightText("Left")
            end
        end

        if MEMORY.read8(DC_MVC2_MEMORY_TABLE.p2_char2_active) == 1 then
            ui.text("Character 2 Facing")
            if MEMORY.read8(DC_MVC2_MEMORY_TABLE.p2_char2_facing_right) == 1 then
                ui.rightText("Right")
            else
                ui.rightText("Left")
            end
        end

        if MEMORY.read8(DC_MVC2_MEMORY_TABLE.p2_char3_active) == 1 then
            ui.text("Character 3 Facing")
            if MEMORY.read8(DC_MVC2_MEMORY_TABLE.p2_char3_facing_right) == 1 then
                ui.rightText("Right")
            else
                ui.rightText("Left")
            end
        end

        ui.endWindow()

        ui.beginWindow("P2 Dummy", math.floor(flycast.state.display.width * (3 / 4)) + 125,
            math.floor(flycast.state.display.height * (3 / 4)) - 125, 160, 0)

        ui.button('Switch Character A', function()
            switch_character_a(2)
        end)
        ui.button('Switch Character B', function()
            switch_character_b(2)
        end)

        ui.button('Jump', function()
            jump(2)
        end)
        ui.button('Forward', function()
            forward(2, MEMORY.read8(DC_MVC2_MEMORY_TABLE.p2_char1_facing_right))
        end)
        ui.button('Back', function()
            block(2, MEMORY.read8(DC_MVC2_MEMORY_TABLE.p2_char1_facing_right))
        end)
        ui.button('Crouch', function()
            crouch(2)
        end)
        ui.button('Release', function()
            release_all(2)
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
f = 0
