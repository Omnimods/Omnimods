data:extend {
    {
        type = "mod-data",
        name = "omnimods",
        data = {
            ---@type {base: string?,compressed: string?,compact: string?,nanite: string?,quantum: string?,singularity: string?}
            compressed_recipes = {},
            compressed_technologies = {--[[
                base_or_compressed_tech_name = {
                    base = regular_tech_name,
                    compressed = compressed_tech_name   
                }]]
            }
        }
    }
}