-- As of 1.1.0
-- Many thanks to TheRustyKnife for working out the inheritance tree
-- Top down: Start with our type and find the parent
-- Bottom up: Start with a parent and find it"s children
return {
    top_down = {
        entity = "prototype-base",
        equipment = "prototype-base",
        accumulator = "entity-with-owner",
        ["asteroid-chunk"] = "prototype-base",
        ["space-platform-starter-pack"] = "prototype-base",
        ["space-location"] = "prototype-base",
        ["planet"] = "space-location",
        ["space-connection"] = "prototype-base",
        surface = "prototype-base",
        ["surface-property"] = "prototype-base",
        ["burner-usage"] = "prototype-base",
        quality = "prototype-base",
        ["lightning-attractor"] = "entity-with-owner",
        lightning = "prototype-base",
        ["fusion-generator"] = "entity-with-owner",
        ["fusion-reactor"] = "entity-with-owner",
        ["active-defense-equipment"] = "equipment",
        ["equipment-ghost"] = "equipment",
        ["inventory-bonus-equipment"] = "equipment",
        ammo = "item",
        ["ammo-turret"] = "turret",
        armor = "tool",
        arrow = "entity",
        ["artillery-turret"] = "entity-with-owner",
        ["agricultural-tower"] = "entity-with-owner",
        ["assembling-machine"] = "crafting-machine",
        ["battery-equipment"] = "equipment",
        beacon = "entity-with-owner",
        ["belt-immunity-equipment"] = "equipment",
        blueprint = "selection-tool",
        ["blueprint-book"] = "item-with-inventory",
        boiler = "entity-with-owner",
        ["burner-generator"] = "entity-with-owner",
        capsule = "item",
        car = "vehicle",
        ["cargo-wagon"] = "rolling-stock",
        ["combat-robot"] = "flying-robot",
        ["capture-robot"] = "flying-robot",
        ["construction-robot"] = "robot-with-logistic-interface",
        container = "entity-with-owner",
        corpse = "entity",
        ["crafting-machine"] = "entity-with-owner",
        ["curved-rail-a"] = "rail",
        ["curved-rail-b"] = "rail",
        ["elevated-curved-rail-a"] = "curved-rail-a",
        ["elevated-curved-rail-b"] = "curved-rail-b",
        ["legacy-curved-rail"] = "rail",
        ["half-diagonal-rail"] = "rail",
        ["elevated-half-diagonal-rail"] = "half-diagonal-rail",
        ["rail-ramp"] = "rail",
        decorative = "entity",
        ["deconstruction-item"] = "selection-tool",
        ["electric-pole"] = "entity-with-owner",
        ["electric-turret"] = "turret",
        ["energy-shield-equipment"] = "equipment",
        ["entity-with-health"] = "entity",
        ["entity-with-owner"] = "entity-with-health",
        explosion = "entity",
        fish = "entity-with-health",
        ["fluid-wagon"] = "rolling-stock",
        ["flying-text"] = "entity",
        ["flying-robot"] = "entity-with-owner",
        furnace = "crafting-machine",
        generator = "entity-with-owner",
        ["generator-equipment"] = "equipment",
        gun = "item",
        ["heat-pipe"] = "entity-with-owner",
        inserter = "entity-with-owner",
        ["item-entity"] = "entity",
        ["item-with-inventory"] = "item-with-label",
        ["item-with-label"] = "item",
        lab = "entity-with-owner",
        lamp = "entity-with-owner",
        ["land-mine"] = "entity-with-owner",
        locomotive = "rolling-stock",
        ["logistic-container"] = "container",
        ["logistic-robot"] = "robot-with-logistic-interface",
        market = "entity-with-owner",
        ["mining-drill"] = "entity-with-owner",
        module = "item",
        ["movement-bonus-equipment"] = "equipment",
        ["night-vision-equipment"] = "equipment",
        ["optimized-particle"] = "prototype-base",
        pipe = "entity-with-owner",
        ["pipe-to-ground"] = "entity-with-owner",
        character = "entity-with-owner",
        ["programmable-speaker"] = "entity-with-owner",
        projectile = "entity",
        pump = "entity-with-owner",
        radar = "entity-with-owner",
        rail = "entity-with-owner",
        ["rail-remnants"] = "corpse",
        ["rail-signal"] = "rail-signal-base",
        ["rail-signal-base"] = "entity-with-owner",
        ["rail-support"] = "entity-with-owner",
        reactor = "entity-with-owner",
        ["repair-tool"] = "tool",
        resource = "entity",
        roboport = "entity-with-owner",
        segment = "entity-with-owner",
        ["segmented-unit"] = "segment",
        ["robot-with-logistic-interface"] = "flying-robot",
        ["rocket-defense"] = "entity-with-owner",
        ["selection-tool"] = "item-with-label",
        ["smart-container"] = "container",
        ["solar-panel"] = "entity-with-owner",
        ["solar-panel-equipment"] = "equipment",
        ["space-platform-hub"] = "entity-with-owner",
        ["cargo-pod"] = "entity-with-owner",
        ["cargo-bay"] = "entity-with-owner",
        ["cargo-landing-pad"] = "entity-with-owner",
        ["spidertron-remote"] = "item",
        ["spider-vehicle"] = "vehicle",
        ["spider-leg"] = "entity-with-owner",
        ["spider-unit"] = "entity-with-owner",
        splitter = "transport-belt-connectable",
        ["lane-splitter"] = "transport-belt-connectable",
        sticker = "entity",
        ["straight-rail"] = "rail",
        ["legacy-straight-rail"] = "rail",
        ["elevated-straight-rail"] = "straight-rail",
        tool = "item",
        ["train-stop"] = "entity-with-owner",
        ["rolling-stock"] = "vehicle",
        ["transport-belt"] = "transport-belt-connectable",
        ["transport-belt-connectable"] = "entity-with-owner",
        tree = "entity-with-health",
        plant = "tree",
        turret = "entity-with-owner",
        ["underground-belt"] = "transport-belt-connectable",
        unit = "entity-with-owner",
        ["unit-spawner"] = "entity-with-owner",
        vehicle = "entity-with-owner",
        wall = "entity-with-owner",
        ["build-entity-achievement"] = "achievement",
        ["construct-with-robots-achievement"] = "achievement",
        ["deconstruct-with-robots-achievement"] = "achievement",
        ["deliver-by-robots-achievement"] = "achievement",
        ["dont-build-entity-achievement"] = "achievement",
        ["dont-craft-manually-achievement"] = "achievement",
        ["dont-use-entity-in-energy-production-achievement"] = "achievement",
        ["finish-the-game-achievement"] = "achievement",
        ["group-attack-achievement"] = "achievement",
        ["kill-achievement"] = "achievement",
        ["player-damaged-achievement"] = "achievement",
        ["produce-achievement"] = "achievement",
        ["produce-per-hour-achievement"] = "achievement",
        ["research-achievement"] = "achievement",
        ["train-path-achievement"] = "achievement",
        ["arithmetic-combinator"] = "combinator",
        ["selector-combinator"] = "combinator",
        combinator = "entity-with-owner",
        ["display-panel"] = "entity-with-owner",
        ["constant-combinator"] = "entity-with-owner",
        ["decider-combinator"] = "combinator",
        ["fluid-turret"] = "turret",
        gate = "entity-with-owner",
        loader = "transport-belt-connectable",
        ["loader-1x1"] = "loader",
        ["linked-belt"] = "transport-belt-connectable",
        ["offshore-pump"] = "entity-with-owner",
        ["power-switch"] = "entity-with-owner",
        ["rail-chain-signal"] = "rail-signal-base",
        ["roboport-equipment"] = "equipment",
        ["rocket-silo"] = "assembling-machine",
        ["storage-tank"] = "entity-with-owner",
        ["item-with-entity-data"] = "item",
        ["simple-entity"] = "entity-with-health",
        ["item-with-tags"] = "item-with-label",
        ["entity-ghost"] = "entity",
        ["electric-energy-interface"] = "entity-with-owner",
        ["leaf-particle"] = "optimized-particle",
        ["flame-thrower-explosion"] = "explosion",
        ["character-corpse"] = "entity",
        ["simple-entity-with-force"] = "entity-with-owner",
        ["simple-entity-with-owner"] = "entity-with-owner",
        ["rocket-silo-rocket-shadow"] = "entity",
        ["rocket-silo-rocket"] = "entity",
        ["item-request-proxy"] = "entity",
        ["deconstructible-tile-proxy"] = "entity",
        fire = "entity",
        ["combat-robot-count"] = "achievement",
        ["tile-ghost"] = "entity",
        ["particle-source"] = "entity",
        stream = "entity",
        ["rail-planner"] = "item",
        beam = "entity",
        ["artillery-projectile"] = "entity",
        ["infinity-container"] = "logistic-container",
        ["temporary-container"] = "container",
        ["artillery-flare"] = "optimized-particle",
        cliff = "entity",
        ["artillery-wagon"] = "rolling-stock",
        ["infinity-pipe"] = "pipe",
        ["copy-paste-tool"] = "selection-tool",
        ["highlight-box"] = "entity",
        ["speech-bubble"] = "entity",
        ["heat-interface"] = "entity-with-owner",
        ["upgrade-item"] = "selection-tool",
        ["utility-sprites"] = "prototype-base",
        ["noise-expression"] = "prototype-base",
        ["noise-function"] = "prototype-base",
        ["trivial-smoke"] = "prototype-base",
        item = "prototype-base",
        ["item-subgroup"] = "prototype-base",
        ["item-group"] = "prototype-base",
        recipe = "prototype-base",
        fluid = "prototype-base",
        ["virtual-signal"] = "prototype-base",
        ["autoplace-control"] = "prototype-base",
        tile = "prototype-base",
        ["optimized-decorative"] = "prototype-base",
        ["damage-type"] = "prototype-base",
        ["ammo-category"] = "prototype-base",
        ["fuel-category"] = "prototype-base",
        ["recipe-category"] = "prototype-base",
        ["resource-category"] = "prototype-base",
        ["module-category"] = "prototype-base",
        ["equipment-grid"] = "prototype-base",
        ["equipment-category"] = "prototype-base",
        technology = "prototype-base",
        shortcut = "prototype-base",
        achievement = "prototype-base",
        tutorial = "prototype-base",
        ["custom-input"] = "prototype-base",
        ["linked-container"] = "entity-with-owner",
        ["asteroid-collector"] = "entity-with-owner",
        asteroid = "entity-with-owner",
        thruster = "entity-with-owner",
    },
    bottom_up = {
        ["prototype-base"] = {
            entity = {
                ["entity-with-health"] = {
                    ["entity-with-owner"] = {
                        accumulator = {},
                        ["asteroid-collector"] = {},
                        asteroid = {},
                        thruster = {},
                        turret = {
                            ["ammo-turret"] = {},
                            ["electric-turret"] = {},
                            ["fluid-turret"] = {},
                        },
                        ["artillery-turret"] = {},
                        ["crafting-machine"] = {
                            ["assembling-machine"] = {
                                ["rocket-silo"] = {},
                            },
                            furnace = {},
                        },
                        beacon = {},
                        boiler = {},
                        ["burner-generator"] = {},
                        vehicle = {
                            car = {},
                            ["rolling-stock"] = {
                                ["cargo-wagon"] = {},
                                ["fluid-wagon"] = {},
                                locomotive = {},
                                ["artillery-wagon"] = {},
                            },
                            ["spider-vehicle"] = {}
                        },
                        ["flying-robot"] = {
                            ["combat-robot"] = {},
                            ["capture-robot"] = {},
                            ["robot-with-logistic-interface"] = {
                                ["construction-robot"] = {},
                                ["logistic-robot"] = {},
                            },
                        },
                        container = {
                            ["logistic-container"] = {
                                ["infinity-container"] = {},
                            },
                            ["smart-container"] = {},
                            ["temporary-container"] = {},
                        },
                        rail = {
                            ["curved-rail-a"] = {
                                ["elevated-curved-rail-a"] = {},},
                            ["curved-rail-b"] = {
                                ["elevated-curved-rail-b"] = {},
                            },
                            ["half-diagonal-rail"] = {
                                ["elevated-half-diagonal-rail"] = {},
                            },
                            ["legacy-straight-rail"] = {},
                            ["legacy-curved-rail"] = {},
                            ["rail-ramp"] = {},
                            ["straight-rail"] = {
                                ["elevated-straight-rail"] = {},
                            },
                        },
                        ["electric-pole"] = {},
                        ["fusion-generator"] = {},
                        ["fusion-reactor"] = {},
                        ["agricultural-tower "] = {},
                        generator = {},
                        ["heat-pipe"] = {},
                        inserter = {},
                        lab = {},
                        lamp = {},
                        ["land-mine"] = {},
                        ["lightning-attractor"] = {},
                        market = {},
                        ["mining-drill"] = {},
                        pipe = {
                            ["infinity-pipe"] = {},
                        },
                        ["pipe-to-ground"] = {},
                        character = {},
                        ["programmable-speaker"] = {},
                        pump = {},
                        radar = {},
                        ["rail-signal-base"] = {
                            ["rail-signal"] = {},
                            ["rail-chain-signal"] = {},
                        },
                        ["rail-support"] = {},
                        reactor = {},
                        roboport = {},
                        segment = {
                            ["segmented-unit"] = {},
                        },
                        ["rocket-defense"] = {},
                        ["solar-panel"] = {},
                        ["space-platform-hub"] = {},
                        ["cargo-pod"] = {},
                        ["cargo-bay"] = {},
                        ["cargo-landing-pad"] = {},
                        ["spider-leg"] = {},
                        ["spider-unit"] = {},
                        ["transport-belt-connectable"] = {
                            splitter = {},
                            ["lane-splitter"] = {},
                            ["transport-belt"] = {},
                            ["linked-belt"] = {},
                            ["underground-belt"] = {},
                            loader = {
                                ["loader-1x1"] = {},
                            },
                        },
                        ["train-stop"] = {},
                        unit = {},
                        ["unit-spawner"] = {},
                        wall = {},
                        combinator = {
                            ["arithmetic-combinator"] = {},
                            ["decider-combinator"] = {},
                            ["selector-combinator"] = {},
                        },
                        ["display-panel"] = {},
                        ["constant-combinator"] = {},
                        gate = {},
                        ["offshore-pump"] = {},
                        ["power-switch"] = {},
                        ["storage-tank"] = {},
                        ["electric-energy-interface"] = {},
                        ["simple-entity-with-owner"] = {
                            ["simple-entity-with-force"] = {},
                        },
                        ["heat-interface"] = {},
                        ["linked-container"] = {},
                    },
                    fish = {},
                    ["simple-entity"] = {},
                    tree = {
                        plant ={},
                    },
                },
                arrow = {},
                corpse = {
                    ["rail-remnants"] = {},
                },
                decorative = {},
                explosion = {
                    ["flame-thrower-explosion"] = {},
                },
                ["flying-text"] = {},
                ["item-entity"] = {},
                ["optimized-particle"] = {
                    ["leaf-particle"] = {},
                    ["artillery-flare"] = {},
                },
                projectile = {},
                resource = {},
                sticker = {},
                ["entity-ghost"] = {},
                ["character-corpse"] = {},
                ["rocket-silo-rocket-shadow"] = {},
                ["rocket-silo-rocket"] = {},
                ["item-request-proxy"] = {},
                ["deconstructible-tile-proxy"] = {},
                fire = {},
                ["tile-ghost"] = {},
                ["particle-source"] = {},
                stream = {},
                beam = {},
                ["artillery-projectile"] = {},
                cliff = {},
                ["highlight-box"] = {},
                ["speech-bubble"] = {},
            },
            equipment = {
                ["active-defense-equipment"] = {},
                ["battery-equipment"] = {},
                ["belt-immunity-equipment"] = {},
                ["energy-shield-equipment"] = {},
                ["equipment-ghost"] = {},
                ["generator-equipment"] = {},
                ["inventory-bonus-equipment"] = {},
                ["movement-bonus-equipment"] = {},
                ["night-vision-equipment"] = {},
                ["solar-panel-equipment"] = {},
                ["roboport-equipment"] = {},
            },
            item = {
                ammo = {},
                tool = {
                    armor = {},
                    ["repair-tool"] = {},
                },
                ["item-with-label"] = {
                    ["selection-tool"] = {
                        blueprint = {},
                        ["deconstruction-item"] = {},
                        ["copy-paste-tool"] = {},
                        ["upgrade-item"] = {},
                    },
                    ["item-with-inventory"] = {
                        ["blueprint-book"] = {},
                    },
                    ["item-with-tags"] = {},
                },
                capsule = {},
                gun = {},
                module = {},
                ["item-with-entity-data"] = {},
                ["rail-planner"] = {},
                ["spidertron-remote"] = {}
            },
            achievement = {
                ["build-entity-achievement"] = {},
                ["construct-with-robots-achievement"] = {},
                ["deconstruct-with-robots-achievement"] = {},
                ["deliver-by-robots-achievement"] = {},
                ["dont-build-entity-achievement"] = {},
                ["dont-craft-manually-achievement"] = {},
                ["dont-use-entity-in-energy-production-achievement"] = {},
                ["finish-the-game-achievement"] = {},
                ["group-attack-achievement"] = {},
                ["kill-achievement"] = {},
                ["player-damaged-achievement"] = {},
                ["produce-achievement"] = {},
                ["produce-per-hour-achievement"] = {},
                ["research-achievement"] = {},
                ["train-path-achievement"] = {},
                ["combat-robot-count"] = {},
            },
            ["asteroid-chunk"] = {},
            ["space-platform-starter-pack"] = {},
            ["space-location"] = {
                ["planet"] = {},
            },
            ["space-connection"] = {},
            surface = {},
            ["surface-property"] = {},
            lightning = {},
            ["burner-usage"] = {},
            ["utility-sprites"] = {},
            ["noise-expression"] = {},
            ["noise-function"] = {},
            ["trivial-smoke"] = {},
            ["item-subgroup"] = {},
            ["item-group"] = {},
            recipe = {},
            fluid = {},
            ["virtual-signal"] = {},
            ["autoplace-control"] = {},
            tile = {},
            ["optimized-decorative"] = {},
            ["damage-type"] = {},
            ["ammo-category"] = {},
            ["fuel-category"] = {},
            ["recipe-category"] = {},
            ["resource-category"] = {},
            ["module-category"] = {},
            ["equipment-grid"] = {},
            ["equipment-category"] = {},
            technology = {},
            shortcut = {},
            tutorial = {},
            ["custom-input"] = {},
            quality = {},
        },
        font = {},
        ["gui-style"] = {},
        ["utility-constants"] = {},
        ["utility-sounds"] = {},
        sprite = {},
        ["god-controller"] = {},
        ["editor-controller"] = {},
        ["spectator-controller"] = {},
        ["mouse-cursor"] = {},
        ["ambient-sound"] = {},
        ["wind-sound"] = {},
        ["map-settings"] = {},
        ["map-gen-presets"] = {},
        sound = {},
        ["remote-controller"] = {},
        ["trigger-target-type"] = {},
    },
}
