    Config = {}

Config.NewESX = true

Config.Framework = 'ESX' -- ESX or QB

Config.Interaction = '3dtext' -- target or 3dtext

Config.Target = 'qtarget' -- qtarget or ox_target or qb-target


Config.Animations = {
        ['Pushups'] = {
            Enter = {Dict = "amb@world_human_push_ups@male@enter", Anim = "enter", Wait = 3050},
            Idle = {Dict = "amb@world_human_push_ups@male@idle_a", Anim = "idle_c"},
            Action = {Dict = "amb@world_human_push_ups@male@base", Anim = "base", Wait = 1100},
            Leave = {Dict = "amb@world_human_push_ups@male@exit", Anim = "exit", Wait = 3400},
        },
        ['Situps'] = {
            Enter = {Dict = "amb@world_human_sit_ups@male@enter", Anim = "enter", Wait = 4200},
            Idle = {Dict = "amb@world_human_sit_ups@male@idle_a", Anim = "idle_a"},
            Action = {Dict = "amb@world_human_sit_ups@male@base", Anim = "base", Wait = 3400},
            Leave = {Dict = "amb@world_human_sit_ups@male@exit", Anim = "exit", Wait = 3700},
        },
        ['Chins'] = {
            Enter = {Dict = "amb@prop_human_muscle_chin_ups@male@enter", Anim = "enter", Wait = 1600},
            Idle = {Dict = "amb@prop_human_muscle_chin_ups@male@idle_a", Anim = "idle_a"},
            Action = {Dict = "amb@prop_human_muscle_chin_ups@male@base", Anim = "base", Wait = 3000},
            Leave = {Dict = "amb@prop_human_muscle_chin_ups@male@exit", Anim = "exit", Wait = 3700},
        },
        ['Bench'] = {
            Enter = {Dict = "amb@prop_human_muscle_chin_ups@male@enter", Anim = "enter", Wait = 0},
            Idle = {Dict = "amb@prop_human_seat_muscle_bench_press@base", Anim = "base"},
            Action = {Dict = "amb@prop_human_seat_muscle_bench_press@idle_a", Anim = "idle_a", Wait = 2400},
            Leave = {Dict = "amb@prop_human_seat_muscle_bench_press@exit", Anim = "exit", Wait = 0},
        },
        ['FreeWeight'] = {
            Enter = {Dict = "amb@prop_human_muscle_chin_ups@male@enter", Anim = "enter", Wait = 0},
            Idle = {Dict = "amb@world_human_muscle_free_weights@male@barbell@idle_a", Anim = "idle_a"},
            Action = {Dict = "amb@world_human_muscle_free_weights@male@barbell@base", Anim = "base", Wait = 4000},
            Leave = {Dict = "amb@prop_human_seat_muscle_bench_press@exit", Anim = "exit", Wait = 0},
        },
        ['DoubleFreeWeight'] = {
            Enter = {Dict = "amb@prop_human_muscle_chin_ups@male@enter", Anim = "enter", Wait = 0},
            Idle = {Dict = "amb@world_human_muscle_free_weights@male@barbell@idle_a", Anim = "idle_a"},
            Action = {Dict = "amb@world_human_muscle_free_weights@male@barbell@base", Anim = "base", Wait = 4000},
            Leave = {Dict = "amb@prop_human_seat_muscle_bench_press@exit", Anim = "exit", Wait = 0},
        }
    }

Config.Skills = {
    SkillSystem = 'b1skillz', -- gamz or b1skillz
    ['Bench'] = {
        skill = 'Stamina', -- what skill Stamina, Strenght,
        add = 1 -- how much it will add per rep
    },
    ['Pushups'] = {
        skill = 'Stamina', -- what skill Stamina, Strenght,
        add = 1 -- how much it will add per rep
    },
    ['Situps'] = {
        skill = 'Stamina', -- what skill Stamina, Strenght,
        add = 1 -- how much it will add per rep
    },
    ['Chins'] = {
        skill = 'Stamina', -- what skill Stamina, Strenght,
        add = 1 -- how much it will add per rep
    },
    ['FreeWeight'] = {
        skill = 'Stamina', -- what skill Stamina, Strenght,
        add = 1 -- how much it will add per rep
    },
    ['DoubleFreeWeight'] = {
        skill = 'Stamina', -- what skill Stamina, Strenght,
        add = 1 -- how much it will add per rep
    },
}

Config.Gyms = {
    ['MuscleGym'] = {
        requireMembership = true,
        gymLibZone = {
            position = vec3(-1200.5439, -1570.2594, 4.6097),
            size = vec3(12, 28, 10),  -- Default size for zones
            rotation = 35,
            debug = false          -- Debug mode for zones
        },
        blip = {
            name = 'Muscle Gym',
            sprite = 311,
            scale   = 1.0,
            colour  = 38
        },
        Exercises = {
            ['Bench'] = {
                offset = 1.0,
                pos1 = vec4(-1200.8333, -1562.2758, 3.0097, 123.9983),
            },
            ['Chins'] = {
                offset = 0.5,
                pos1 = vec4(-1200.0295, -1571.1958, 3.6094, 217.9855),
            },
            ['Situps'] = {
                offset = 0.5,
                pos1 = vec4(-1203.2345, -1568.0068, 4.0081, 214.9541),
                pos2 = vec4(-1201.3048, -1566.5432, 4.0158, 221.0563)
            },
            ['Pushups'] = {
                offset = 0.5,
                pos1 = vec4(-1202.8159, -1570.3503, 3.6079, 119.7019),
            },
            ['FreeWeight'] = {
                offset = 1.0,
                pos1 = vec4(-1202.5111, -1565.2418, 3.6123, 345.9378),
            },
            ['DoubleFreeWeight'] = {
                offset = 1.0,
                pos1 = vec4(-1198.1160, -1565.0529, 3.6201, 309.8470),
            }
        },
        Shop = {
            npcLocation = vec4(-1195.655, -1577.574, 3.624, 139.5813),
            shop = {
                items = {
                    {
                        itemName = 'membership',
                        itemPrice = 50,
                        itemText = 'Membership',
                        itemDescription = 'Membership so you can workout here'
                    },
                    {
                        itemName = 'preworkout',
                        itemPrice = 20,
                        itemText = 'Preworkout',
                        itemDescription = 'So you have faster stamina load'
                    },
                }
            }
        }
    }
}