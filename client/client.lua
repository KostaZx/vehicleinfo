local config = lib.require('config')

local function vehicleHealthColor(progress)
    if progress >= 75 then
        return 'green'
    elseif progress < 75 and progress >= 50 then
        return 'yellow'
    elseif progress < 50 and progress >= 25 then
        return 'orange'
    elseif progress < 25 and progress >= 0 then
        return 'red'
    end
end

local function getModLabel(vehicle, modType)
    local modValue = GetVehicleMod(vehicle, modType)
    
    if modValue == -1 then
        return 'Stock'
    else
        local modLabel = GetLabelText(GetModTextLabel(vehicle, modType, GetVehicleMod(vehicle, modType)))
        return modLabel ~= 'NULL' and modLabel or 'Not defined'
    end
end

local function OpenVehicleMenu()
    if cache.vehicle then
        local vehicle = cache.vehicle
        local fuelProgress

        local vehicleModelHash = GetEntityModel(vehicle)
        local vehicleSpawnCode = string.lower(GetDisplayNameFromVehicleModel(vehicleModelHash))
        local vehicleName = GetLabelText(GetDisplayNameFromVehicleModel(vehicleModelHash))
        local vehicleClass = config.vehicleClass[vehicleSpawnCode]

        local engineMod = GetVehicleMod(vehicle, 11)
        local brakeMod = GetVehicleMod(vehicle, 12)
        local suspensionMod = GetVehicleMod(vehicle, 13)
        local transmissionMod = GetVehicleMod(vehicle, 14)
        local armourMod = GetVehicleMod(vehicle, 16)
        local turboEnabled = IsToggleModOn(vehicle, 18)

        engineMod = engineMod ~= -1 and tostring(engineMod).." LVL" or 'Stock'
        brakeMod = brakeMod ~= -1 and tostring(brakeMod).." LVL" or 'Stock'
        suspensionMod = suspensionMod ~= -1 and tostring(suspensionMod).." LVL" or 'Stock'
        transmissionMod = transmissionMod ~= -1 and tostring(transmissionMod).." LVL" or 'Stock'
        armourMod = armourMod ~= -1 and tostring(armourMod).." LVL" or 'Stock'

        if config.fuel == 'ox_fuel' then
            fuelProgress = Entity(vehicle) and Entity(vehicle).state and Entity(vehicle).state.fuel or GetVehicleFuelLevel(vehicle)
        else
            fuelProgress = exports[config.fuel]:GetFuel(vehicle)
        end
    

        lib.registerContext({
            id = 'vehicle_menu',
            title = 'Vehicle Information',
            options = {
                {
                    title = vehicleName,
                    description = 'Plate: ' .. GetVehicleNumberPlateText(vehicle),
                    icon = 'fa-solid fa-car',
                },
                {
                    title = 'Vehicle Class',
                    description = 'Class: ' .. (vehicleClass or 'Not defined'),
                    icon = 'fa-solid fa-chart-simple',
                },
                {
                    title = 'Fuel Level',
                    description = ('Level: %s'):format(tostring(math.ceil(fuelProgress))),
                    progress = math.ceil(fuelProgress),
                    colorScheme = '#FFFF00',
                    icon = 'fas fa-gas-pump'
                },
                {
                    title = 'Engine Health',
                    description = ('Health: %s%%'):format(tostring(math.ceil(lib.getVehicleProperties(vehicle).engineHealth / 10))),
                    progress = (lib.getVehicleProperties(vehicle).engineHealth / 10),
                    colorScheme = vehicleHealthColor(math.ceil(lib.getVehicleProperties(vehicle).engineHealth / 10)),
                    icon = 'fas fa-car-battery'
                },
                {
                    title = 'Body Health',
                    description = ('Health: %s%%'):format(tostring(math.ceil(lib.getVehicleProperties(vehicle).bodyHealth / 10))),
                    progress = (lib.getVehicleProperties(vehicle).bodyHealth / 10),
                    colorScheme = vehicleHealthColor(math.ceil(lib.getVehicleProperties(vehicle).bodyHealth / 10)),
                    icon = 'fas fa-car-burst'
                },
                {
                    title = 'Vehicle Engine',
                    description = 'Engine: ' .. engineMod,
                    icon = 'fa-solid fa-car',
                },
                {
                    title = 'Vehicle Brakes',
                    description = 'Brakes: ' .. brakeMod,
                    icon = 'fa-solid fa-car',
                },
                {
                    title = 'Vehicle Suspension',
                    description = 'Suspension: ' .. suspensionMod,
                    icon = 'fa-solid fa-car',
                },
                {
                    title = 'Vehicle Transmission',
                    description = 'Transmission: ' .. transmissionMod,
                    icon = 'fa-solid fa-car',
                },
                {
                    title = 'Vehicle Armour',
                    description = 'Armour: ' .. armourMod,
                    icon = 'fa-solid fa-car',
                },
                {
                    title = 'Turbo',
                    description = 'Turbo: ' .. (turboEnabled and 'Enabled' or 'Disabled'),
                    icon = 'fa-solid fa-car',
                },
                {
                    title = 'Vehicle Spoilers',
                    description = 'Spoiler: ' .. getModLabel(vehicle, 0),
                    icon = 'fa-solid fa-car',
                },
                {
                    title = 'Vehicle Front Bumper',
                    description = 'Bumper: ' .. getModLabel(vehicle, 1),
                    icon = 'fa-solid fa-car',
                },
                {
                    title = 'Vehicle Rear Bumper',
                    description = 'Bumper: ' .. getModLabel(vehicle, 2),
                    icon = 'fa-solid fa-car',
                },
                {
                    title = 'Vehicle Skirt',
                    description = 'Skirt: ' .. getModLabel(vehicle, 3),
                    icon = 'fa-solid fa-car',
                },
                {
                    title = 'Vehicle Exhaust',
                    description = 'Exhaust: ' .. getModLabel(vehicle, 4),
                    icon = 'fa-solid fa-car',
                },
                {
                    title = 'Vehicle Grille',
                    description = 'Grille: ' .. getModLabel(vehicle, 6),
                    icon = 'fa-solid fa-car',
                },
                {
                    title = 'Vehicle Left Wing',
                    description = 'Wing: ' .. getModLabel(vehicle, 8),
                    icon = 'fa-solid fa-car',
                },
                {
                    title = 'Vehicle Right Wing',
                    description = 'Wing: ' .. getModLabel(vehicle, 9),
                    icon = 'fa-solid fa-car',
                },
                {
                    title = 'Vehicle Roof',
                    description = 'Roof: ' .. getModLabel(vehicle, 10),
                    icon = 'fa-solid fa-car',
                },
                {
                    title = 'Vehicle Horn',
                    description = 'Horn: ' .. getModLabel(vehicle, 14),
                    icon = 'fa-solid fa-car',
                },
                {
                    title = 'Vehicle Tyre Smoke',
                    description = 'Tyre Smoke: ' .. getModLabel(vehicle, 20),
                    icon = 'fa-solid fa-car',
                },
                {
                    title = 'Vehicle Hydraulics',
                    description = 'Hydraulics: ' .. getModLabel(vehicle, 21),
                    icon = 'fa-solid fa-car',
                },
                {
                    title = 'Vehicle Xenon Lights',
                    description = 'Xenon Lights: ' .. getModLabel(vehicle, 22),
                    icon = 'fa-solid fa-car',
                },
                {
                    title = 'Vehicle Wheels',
                    description = 'Wheels: ' .. getModLabel(vehicle, 23),
                    icon = 'fa-solid fa-car',
                },
                {
                    title = 'Vehicle Left Door',
                    description = 'Door: ' .. getModLabel(vehicle, 46),
                    icon = 'fa-solid fa-car',
                },
                {
                    title = 'Vehicle Right Door',
                    description = 'Door: ' .. getModLabel(vehicle, 47),
                    icon = 'fa-solid fa-car',
                },
                {
                    title = 'Vehicle Livery',
                    description = 'Livery: ' .. getModLabel(vehicle, 48),
                    icon = 'fa-solid fa-car',
                },
            }
        })
        lib.showContext('vehicle_menu')
    else
        lib.notify({ description = 'You are not in a vehicle', type = 'error' })
    end
end


RegisterCommand('vehinfo', OpenVehicleMenu)


