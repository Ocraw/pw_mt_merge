-- pipeworks/moretubes/straight.lua
-- One Way Tube and Straight Only Tube of different conductivity
-- SPDX-License-Identifier: LGPL-3.0-or-later

local mod_mesecons = minetest.get_modpath("mesecons")
local mod_digilines = minetest.get_modpath("digilines")

local S = minetest.get_translator("pipeworks")
local texture_alpha_mode = minetest.features.use_texture_alpha_string_modes and "clip" or true

local function apply_make_tube_tile(tiles)
    local rtn_tiles = {}
    for i, tile in ipairs(tiles) do
        rtn_tiles[i] = pipeworks.make_tube_tile(tile)
    end
    return rtn_tiles
end

local one_way_rules = {
    connect_sides = { left = 1, right = 1 },
    can_go = function(pos, node, velocity, stack)
        return { velocity }
    end,
    can_insert = function(pos, node, stack, direction)
        local dir = pipeworks.facedir_to_right_dir(node.param2)
        return vector.equals(dir, direction)
    end,
    priority = 75 -- Higher than normal tubes, but lower than receivers
}

local straight_tube_rules = {
    connect_sides = { left = 1, right = 1 },
    can_go = function(pos, node, velocity, stack)
        return { velocity }
    end,
    can_insert = function(pos, node, stack, direction)
        local dir = pipeworks.facedir_to_right_dir(node.param2)
        return vector.equals(dir, direction) or vector.equals(vector.multiply(dir, -1), direction)
    end,
    priority = 75 -- Higher than normal tubes, but lower than receivers
}

minetest.register_node("pipeworks:straight_tube", {
    description = S("Straight Only Tube"),
    tiles = apply_make_tube_tile({
        "pipeworks_tube_straight.png^pipeworks_straight_tube_overlay.png^[transformR180",
        "pipeworks_tube_straight.png^pipeworks_straight_tube_overlay.png^[transformR180",
        "pipeworks_one_way_tube_output.png",
        "pipeworks_one_way_tube_output.png",
        "pipeworks_tube_straight.png^pipeworks_straight_tube_overlay.png",
        "pipeworks_tube_straight.png^pipeworks_straight_tube_overlay.png^[transformR180",
    }),
    use_texture_alpha = texture_alpha_mode,
    paramtype2 = "facedir",
    drawtype = "nodebox",
    paramtype = "light",
    node_box = {
        type = "fixed",
        fixed = { { -1 / 2, -9 / 64, -9 / 64, 1 / 2, 9 / 64, 9 / 64 } }
    },
    groups = { snappy = 2, choppy = 2, oddly_breakable_by_hand = 2, tubedevice = 1, axey = 1, handy = 1, pickaxey = 1 },
    is_ground_content = false,
    _mcl_hardness = 0.8,
    _sound_def = {
        key = "node_sound_wood_defaults",
    },
    tube = straight_tube_rules,
    after_place_node = pipeworks.after_place,
    after_dig_node = pipeworks.after_dig,
    on_rotate = pipeworks.on_rotate,
    check_for_pole = pipeworks.check_for_vert_tube,
    check_for_horiz_pole = pipeworks.check_for_horiz_tube
})

minetest.register_craft({
    output = "pipeworks:straight_tube 3",
    recipe = { { "pipeworks:tube_1", "pipeworks:tube_1", "pipeworks:tube_1" } }
})

local groups = { mesecon = 2, snappy = 2, choppy = 2, oddly_breakable_by_hand = 2, tubedevice = 1, axey = 1, handy = 1, pickaxey = 1 }
local groups_on = table.copy(groups)
groups_on.not_in_creative_inventory = 1

if mod_mesecons then
    mesecon.register_node("pipeworks:conducting_one_way_tube", {
        description = S("Conducting One Way Tube"),
        is_ground_content = false,
        use_texture_alpha = texture_alpha_mode,
        --sounds = mesecon.node_sound.stone,
        paramtype2 = "facedir",
        drawtype = "nodebox",
        paramtype = "light",
        node_box = {
            type = "fixed",
            fixed = { { -1 / 2, -9 / 64, -9 / 64, 1 / 2, 9 / 64, 9 / 64 } }
        },
        _mcl_hardness = 0.8,
        _sound_def = {
            key = "node_sound_wood_defaults",
        },
        tube = one_way_rules,
        after_place_node = pipeworks.after_place,
        after_dig_node = pipeworks.after_dig,
        on_rotate = pipeworks.on_rotate,
        check_for_pole = pipeworks.check_for_vert_tube,
        check_for_horiz_pole = pipeworks.check_for_horiz_tube
    }, {
        groups = groups,
        tiles = apply_make_tube_tile({
            "pipeworks_tube_straight.png^pipeworks_conductor_tube_overlay.png^pipeworks_one_way_tube_overlay.png^[transformR180",
            "pipeworks_tube_straight.png^pipeworks_conductor_tube_overlay.png^pipeworks_one_way_tube_overlay.png^[transformR180",
            "pipeworks_one_way_tube_output.png^pipeworks_conductor_tube_output_overlay.png",
            "pipeworks_one_way_tube_output.png^pipeworks_conductor_tube_output_overlay.png",
            "pipeworks_tube_straight.png^pipeworks_conductor_tube_overlay.png^pipeworks_one_way_tube_overlay.png",
            "pipeworks_tube_straight.png^pipeworks_conductor_tube_overlay.png^pipeworks_one_way_tube_overlay.png^[transformR180",
        }),
        mesecons = {
            conductor = {
                state = mesecon.state.off,
                rules = pipeworks.mesecons_rules,
                onstate = "pipeworks:conducting_one_way_tube_on"
            }
        }
    }, {
        groups = groups_on,
        tiles = apply_make_tube_tile({
            "pipeworks_tube_straight.png^pipeworks_conductor_tube_on_overlay.png^pipeworks_one_way_tube_overlay.png^[transformR180",
            "pipeworks_tube_straight.png^pipeworks_conductor_tube_on_overlay.png^pipeworks_one_way_tube_overlay.png^[transformR180",
            "pipeworks_one_way_tube_output.png^pipeworks_conductor_tube_on_output_overlay.png",
            "pipeworks_one_way_tube_output.png^pipeworks_conductor_tube_on_output_overlay.png",
            "pipeworks_tube_straight.png^pipeworks_conductor_tube_on_overlay.png^pipeworks_one_way_tube_overlay.png",
            "pipeworks_tube_straight.png^pipeworks_conductor_tube_on_overlay.png^pipeworks_one_way_tube_overlay.png^[transformR180",
        }),
        mesecons = {
            conductor = {
                state = mesecon.state.on,
                rules = pipeworks.mesecons_rules,
                offstate = "pipeworks:conducting_one_way_tube_off"
            }
        }
    })

    mesecon.register_node("pipeworks:conducting_straight_tube", {
        description = S("Conducting Straight Only Tube"),
        is_ground_content = false,
        use_texture_alpha = texture_alpha_mode,
        --sounds = mesecon.node_sound.stone,
        paramtype2 = "facedir",
        drawtype = "nodebox",
        paramtype = "light",
        node_box = {
            type = "fixed",
            fixed = { { -1 / 2, -9 / 64, -9 / 64, 1 / 2, 9 / 64, 9 / 64 } }
        },
        _mcl_hardness = 0.8,
        _sound_def = {
            key = "node_sound_wood_defaults",
        },
        tube = straight_tube_rules,
        after_place_node = pipeworks.after_place,
        after_dig_node = pipeworks.after_dig,
        on_rotate = pipeworks.on_rotate,
        check_for_pole = pipeworks.check_for_vert_tube,
        check_for_horiz_pole = pipeworks.check_for_horiz_tube
    }, {
        groups = groups,
        tiles = apply_make_tube_tile({
            "pipeworks_tube_straight.png^pipeworks_conductor_tube_overlay.png^pipeworks_straight_tube_overlay.png^[transformR180",
            "pipeworks_tube_straight.png^pipeworks_conductor_tube_overlay.png^pipeworks_straight_tube_overlay.png^[transformR180",
            "pipeworks_one_way_tube_output.png^pipeworks_conductor_tube_output_overlay.png",
            "pipeworks_one_way_tube_output.png^pipeworks_conductor_tube_output_overlay.png",
            "pipeworks_tube_straight.png^pipeworks_conductor_tube_overlay.png^pipeworks_straight_tube_overlay.png",
            "pipeworks_tube_straight.png^pipeworks_conductor_tube_overlay.png^pipeworks_straight_tube_overlay.png^[transformR180",
        }),
        mesecons = {
            conductor = {
                state = mesecon.state.off,
                rules = pipeworks.mesecons_rules,
                onstate = "pipeworks:conducting_straight_tube_on"
            }
        }
    }, {
        groups = groups_on,
        tiles = apply_make_tube_tile({
            "pipeworks_tube_straight.png^pipeworks_conductor_tube_on_overlay.png^pipeworks_straight_tube_overlay.png^[transformR180",
            "pipeworks_tube_straight.png^pipeworks_conductor_tube_on_overlay.png^pipeworks_straight_tube_overlay.png^[transformR180",
            "pipeworks_one_way_tube_output.png^pipeworks_conductor_tube_on_output_overlay.png",
            "pipeworks_one_way_tube_output.png^pipeworks_conductor_tube_on_output_overlay.png",
            "pipeworks_tube_straight.png^pipeworks_conductor_tube_on_overlay.png^pipeworks_straight_tube_overlay.png",
            "pipeworks_tube_straight.png^pipeworks_conductor_tube_on_overlay.png^pipeworks_straight_tube_overlay.png^[transformR180",
        }),
        mesecons = {
            conductor = {
                state = mesecon.state.on,
                rules = pipeworks.mesecons_rules,
                offstate = "pipeworks:conducting_straight_tube_off"
            }
        }
    })

    minetest.register_craft({
        type = "shapeless",
        output = "pipeworks:conducting_one_way_tube_off",
        recipe = { "pipeworks:one_way_tube", "mesecons:mesecon" }
    })

    minetest.register_craft({
        type = "shapeless",
        output = "pipeworks:conducting_straight_tube_off",
        recipe = { "pipeworks:straight_tube", "mesecons:mesecon" }
    })

    minetest.register_craft({
        output = "pipeworks:conducting_straight_tube_off 3",
        recipe = { { "pipeworks:conductor_tube_off_1", "pipeworks:conductor_tube_off_1", "pipeworks:conductor_tube_off_1" } }
    })
end

if mod_digilines then
    minetest.register_node("pipeworks:digiline_one_way_tube", {
        description = S("Digiline Conducting One Way Tube"),
        tiles = apply_make_tube_tile({
            "pipeworks_tube_straight.png^pipeworks_digiline_conductor_tube_plain.png^pipeworks_one_way_tube_overlay.png^[transformR180",
            "pipeworks_tube_straight.png^pipeworks_digiline_conductor_tube_plain.png^pipeworks_one_way_tube_overlay.png^[transformR180",
            "pipeworks_one_way_tube_output.png^pipeworks_digiline_conductor_tube_plain.png",
            "pipeworks_one_way_tube_output.png^pipeworks_digiline_conductor_tube_plain.png",
            "pipeworks_tube_straight.png^pipeworks_digiline_conductor_tube_plain.png^pipeworks_one_way_tube_overlay.png",
            "pipeworks_tube_straight.png^pipeworks_digiline_conductor_tube_plain.png^pipeworks_one_way_tube_overlay.png^[transformR180",
        }),
        use_texture_alpha = texture_alpha_mode,
        paramtype2 = "facedir",
        drawtype = "nodebox",
        paramtype = "light",
        node_box = {
            type = "fixed",
            fixed = { { -1 / 2, -9 / 64, -9 / 64, 1 / 2, 9 / 64, 9 / 64 } }
        },
        groups = { snappy = 2, choppy = 2, oddly_breakable_by_hand = 2, tubedevice = 1, axey = 1, handy = 1, pickaxey = 1 },
        is_ground_content = false,
        _mcl_hardness = 0.8,
        _sound_def = {
            key = "node_sound_wood_defaults",
        },
        tube = one_way_rules,
        digiline = { wire = { rules = pipeworks.digilines_rules } },
        after_place_node = pipeworks.after_place,
        after_dig_node = pipeworks.after_dig,
        on_rotate = pipeworks.on_rotate,
        check_for_pole = pipeworks.check_for_vert_tube,
        check_for_horiz_pole = pipeworks.check_for_horiz_tube
    })

    minetest.register_node("pipeworks:digiline_straight_tube", {
        description = S("Digiline Conducting Straight Only Tube"),
        tiles = apply_make_tube_tile({
            "pipeworks_tube_straight.png^pipeworks_digiline_conductor_tube_plain.png^pipeworks_straight_tube_overlay.png^[transformR180",
            "pipeworks_tube_straight.png^pipeworks_digiline_conductor_tube_plain.png^pipeworks_straight_tube_overlay.png^[transformR180",
            "pipeworks_one_way_tube_output.png^pipeworks_digiline_conductor_tube_plain.png",
            "pipeworks_one_way_tube_output.png^pipeworks_digiline_conductor_tube_plain.png",
            "pipeworks_tube_straight.png^pipeworks_digiline_conductor_tube_plain.png^pipeworks_straight_tube_overlay.png",
            "pipeworks_tube_straight.png^pipeworks_digiline_conductor_tube_plain.png^pipeworks_straight_tube_overlay.png^[transformR180",
        }),
        use_texture_alpha = texture_alpha_mode,
        paramtype2 = "facedir",
        drawtype = "nodebox",
        paramtype = "light",
        node_box = {
            type = "fixed",
            fixed = { { -1 / 2, -9 / 64, -9 / 64, 1 / 2, 9 / 64, 9 / 64 } }
        },
        groups = { snappy = 2, choppy = 2, oddly_breakable_by_hand = 2, tubedevice = 1, axey = 1, handy = 1, pickaxey = 1 },
        is_ground_content = false,
        _mcl_hardness = 0.8,
        _sound_def = {
            key = "node_sound_wood_defaults",
        },
        tube = straight_tube_rules,
        digiline = { wire = { rules = pipeworks.digilines_rules } },
        after_place_node = pipeworks.after_place,
        after_dig_node = pipeworks.after_dig,
        on_rotate = pipeworks.on_rotate,
        check_for_pole = pipeworks.check_for_vert_tube,
        check_for_horiz_pole = pipeworks.check_for_horiz_tube
    })

    minetest.register_craft({
        type = "shapeless",
        output = "pipeworks:digiline_one_way_tube",
        recipe = { "pipeworks:one_way_tube", "digilines:wire_std_00000000" }
    })

    minetest.register_craft({
        type = "shapeless",
        output = "pipeworks:digiline_straight_tube",
        recipe = { "pipeworks:straight_tube", "digilines:wire_std_00000000" }
    })

    minetest.register_craft({
        output = "pipeworks:digiline_straight_tube 3",
        recipe = { { "pipeworks:digiline_conductor_tube_1", "pipeworks:digiline_conductor_tube_1", "pipeworks:digiline_conductor_tube_1" } }
    })
end

if mod_mesecons and mod_digilines then
    mesecon.register_node("pipeworks:mesecon_and_digiline_conductor_one_way_tube", {
        description = S("Mesecon and Digiline Conducting One Way Tube"),
        is_ground_content = false,
        use_texture_alpha = texture_alpha_mode,
        --sounds = mesecon.node_sound.stone,
        paramtype2 = "facedir",
        drawtype = "nodebox",
        paramtype = "light",
        node_box = {
            type = "fixed",
            fixed = { { -1 / 2, -9 / 64, -9 / 64, 1 / 2, 9 / 64, 9 / 64 } }
        },
        _mcl_hardness = 0.8,
        _sound_def = {
            key = "node_sound_wood_defaults",
        },
        tube = one_way_rules,
        digiline = { wire = { rules = pipeworks.digilines_rules } },
        after_place_node = pipeworks.after_place,
        after_dig_node = pipeworks.after_dig,
        on_rotate = pipeworks.on_rotate,
        check_for_pole = pipeworks.check_for_vert_tube,
        check_for_horiz_pole = pipeworks.check_for_horiz_tube
    }, {
        groups = groups,
        tiles = apply_make_tube_tile({
            "pipeworks_tube_straight.png^pipeworks_conductor_tube_overlay.png^pipeworks_digiline_conductor_tube_plain.png^pipeworks_one_way_tube_overlay.png^[transformR180",
            "pipeworks_tube_straight.png^pipeworks_conductor_tube_overlay.png^pipeworks_digiline_conductor_tube_plain.png^pipeworks_one_way_tube_overlay.png^[transformR180",
            "pipeworks_one_way_tube_output.png^pipeworks_digiline_conductor_tube_plain.png^pipeworks_conductor_tube_output_overlay.png",
            "pipeworks_one_way_tube_output.png^pipeworks_digiline_conductor_tube_plain.png^pipeworks_conductor_tube_output_overlay.png",
            "pipeworks_tube_straight.png^pipeworks_conductor_tube_overlay.png^pipeworks_digiline_conductor_tube_plain.png^pipeworks_one_way_tube_overlay.png",
            "pipeworks_tube_straight.png^pipeworks_conductor_tube_overlay.png^pipeworks_digiline_conductor_tube_plain.png^pipeworks_one_way_tube_overlay.png^[transformR180",
        }),
        mesecons = {
            conductor = {
                state = mesecon.state.off,
                rules = pipeworks.mesecons_rules,
                onstate = "pipeworks:mesecon_and_digiline_conductor_one_way_tube_on"
            }
        }
    }, {
        groups = groups_on,
        tiles = apply_make_tube_tile({
            "pipeworks_tube_straight.png^pipeworks_conductor_tube_on_overlay.png^pipeworks_digiline_conductor_tube_plain.png^pipeworks_one_way_tube_overlay.png^[transformR180",
            "pipeworks_tube_straight.png^pipeworks_conductor_tube_on_overlay.png^pipeworks_digiline_conductor_tube_plain.png^pipeworks_one_way_tube_overlay.png^[transformR180",
            "pipeworks_one_way_tube_output.png^pipeworks_digiline_conductor_tube_plain.png^pipeworks_conductor_tube_on_output_overlay.png",
            "pipeworks_one_way_tube_output.png^pipeworks_digiline_conductor_tube_plain.png^pipeworks_conductor_tube_on_output_overlay.png",
            "pipeworks_tube_straight.png^pipeworks_conductor_tube_on_overlay.png^pipeworks_digiline_conductor_tube_plain.png^pipeworks_one_way_tube_overlay.png",
            "pipeworks_tube_straight.png^pipeworks_conductor_tube_on_overlay.png^pipeworks_digiline_conductor_tube_plain.png^pipeworks_one_way_tube_overlay.png^[transformR180",
        }),
        mesecons = {
            conductor = {
                state = mesecon.state.on,
                rules = pipeworks.mesecons_rules,
                offstate = "pipeworks:mesecon_and_digiline_conductor_one_way_tube_off"
            }
        }
    })

    mesecon.register_node("pipeworks:mesecon_and_digiline_conductor_straight_tube", {
        description = S("Mesecon and Digiline Conducting Straight Only Tube"),
        is_ground_content = false,
        use_texture_alpha = texture_alpha_mode,
        --sounds = mesecon.node_sound.stone,
        paramtype2 = "facedir",
        drawtype = "nodebox",
        paramtype = "light",
        node_box = {
            type = "fixed",
            fixed = { { -1 / 2, -9 / 64, -9 / 64, 1 / 2, 9 / 64, 9 / 64 } }
        },
        _mcl_hardness = 0.8,
        _sound_def = {
            key = "node_sound_wood_defaults",
        },
        tube = straight_tube_rules,
        digiline = { wire = { rules = pipeworks.digilines_rules } },
        after_place_node = pipeworks.after_place,
        after_dig_node = pipeworks.after_dig,
        on_rotate = pipeworks.on_rotate,
        check_for_pole = pipeworks.check_for_vert_tube,
        check_for_horiz_pole = pipeworks.check_for_horiz_tube
    }, {
        groups = groups,
        tiles = apply_make_tube_tile({
            "pipeworks_tube_straight.png^pipeworks_conductor_tube_overlay.png^pipeworks_digiline_conductor_tube_plain.png^pipeworks_straight_tube_overlay.png^[transformR180",
            "pipeworks_tube_straight.png^pipeworks_conductor_tube_overlay.png^pipeworks_digiline_conductor_tube_plain.png^pipeworks_straight_tube_overlay.png^[transformR180",
            "pipeworks_one_way_tube_output.png^pipeworks_digiline_conductor_tube_plain.png^pipeworks_conductor_tube_output_overlay.png",
            "pipeworks_one_way_tube_output.png^pipeworks_digiline_conductor_tube_plain.png^pipeworks_conductor_tube_output_overlay.png",
            "pipeworks_tube_straight.png^pipeworks_conductor_tube_overlay.png^pipeworks_digiline_conductor_tube_plain.png^pipeworks_straight_tube_overlay.png",
            "pipeworks_tube_straight.png^pipeworks_conductor_tube_overlay.png^pipeworks_digiline_conductor_tube_plain.png^pipeworks_straight_tube_overlay.png^[transformR180",
        }),
        mesecons = {
            conductor = {
                state = mesecon.state.off,
                rules = pipeworks.mesecons_rules,
                onstate = "pipeworks:mesecon_and_digiline_conductor_straight_tube_on"
            }
        }
    }, {
        groups = groups_on,
        tiles = apply_make_tube_tile({
            "pipeworks_tube_straight.png^pipeworks_conductor_tube_on_overlay.png^pipeworks_digiline_conductor_tube_plain.png^pipeworks_straight_tube_overlay.png^[transformR180",
            "pipeworks_tube_straight.png^pipeworks_conductor_tube_on_overlay.png^pipeworks_digiline_conductor_tube_plain.png^pipeworks_straight_tube_overlay.png^[transformR180",
            "pipeworks_one_way_tube_output.png^pipeworks_digiline_conductor_tube_plain.png^pipeworks_conductor_tube_on_output_overlay.png",
            "pipeworks_one_way_tube_output.png^pipeworks_digiline_conductor_tube_plain.png^pipeworks_conductor_tube_on_output_overlay.png",
            "pipeworks_tube_straight.png^pipeworks_conductor_tube_on_overlay.png^pipeworks_digiline_conductor_tube_plain.png^pipeworks_straight_tube_overlay.png",
            "pipeworks_tube_straight.png^pipeworks_conductor_tube_on_overlay.png^pipeworks_digiline_conductor_tube_plain.png^pipeworks_straight_tube_overlay.png^[transformR180",
        }),
        mesecons = {
            conductor = {
                state = mesecon.state.on,
                rules = pipeworks.mesecons_rules,
                offstate = "pipeworks:mesecon_and_digiline_conductor_straight_tube_off"
            }
        }
    })

    minetest.register_craft({
        type = "shapeless",
        output = "pipeworks:mesecon_and_digiline_conductor_one_way_tube_off",
        recipe = { "pipeworks:one_way_tube", "mesecons:mesecon", "digilines:wire_std_00000000" }
    })

    minetest.register_craft({
        type = "shapeless",
        output = "pipeworks:mesecon_and_digiline_conductor_one_way_tube_off",
        recipe = { "pipeworks:conducting_one_way_tube_off", "digilines:wire_std_00000000" }
    })

    minetest.register_craft({
        type = "shapeless",
        output = "pipeworks:mesecon_and_digiline_conductor_one_way_tube_off",
        recipe = { "pipeworks:digiline_one_way_tube", "mesecons:mesecon" }
    })

    minetest.register_craft({
        type = "shapeless",
        output = "pipeworks:mesecon_and_digiline_conductor_straight_tube_off",
        recipe = { "pipeworks:straight_tube", "mesecons:mesecon", "digilines:wire_std_00000000" }
    })

    minetest.register_craft({
        type = "shapeless",
        output = "pipeworks:mesecon_and_digiline_conductor_straight_tube_off",
        recipe = { "pipeworks:conducting_straight_tube_off", "digilines:wire_std_00000000" }
    })

    minetest.register_craft({
        type = "shapeless",
        output = "pipeworks:mesecon_and_digiline_conductor_straight_tube_off",
        recipe = { "pipeworks:digiline_straight_tube", "mesecons:mesecon" }
    })

    minetest.register_craft({
        output = "pipeworks:mesecon_and_digiline_conductor_straight_tube_off 3",
        recipe = { { "pipeworks:mesecon_and_digiline_conductor_tube_off_1", "pipeworks:mesecon_and_digiline_conductor_tube_off_1", "pipeworks:mesecon_and_digiline_conductor_tube_off_1" } }
    })
end
