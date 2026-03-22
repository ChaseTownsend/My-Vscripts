IncludeScript("fatcat_library")

local projectile = CreateProjectile({
    owner = Host
    model = "models/player/scout.mdl"
    thinkfunc = 1
    force = 1250
    delay = -1
    min = Vector(-15, -15, -15)
    max = Vector(15, 15, 15)
})