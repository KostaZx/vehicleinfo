local config = require('config.shared')

local function OpenVehicleMenu()
    local playerPed = cache.ped

    if IsPedInAnyVehicle(playerPed, false) then
        local vehicle = GetVehiclePedIsIn(playerPed, false)
        local vehicleName = qbx.getVehicleDisplayName(vehicle)
        local vehicleModelHash = GetEntityModel(vehicle)
        local vehicleSpawnCode = string.lower(GetDisplayNameFromVehicleModel(vehicleModelHash))
        local vehicleClass = config.class[vehicleSpawnCode]

        local engineMod = GetVehicleMod(vehicle, 11) 
        local brakeMod = GetVehicleMod(vehicle, 12)
        local suspensionMod = GetVehicleMod(vehicle, 13) 
        local transmissionMod = GetVehicleMod(vehicle, 13) 
        local turboEnabled = IsToggleModOn(vehicle, 18) 
        
        engineMod = engineMod ~= -1 and tostring(engineMod).." LVL" or 'Stock'
        brakeMod = brakeMod ~= -1 and tostring(brakeMod).." LVL" or 'Stock'
        suspensionMod = suspensionMod ~= -1 and tostring(suspensionMod).." LVL" or 'Stock'
        transmissionMod = transmissionMod ~= -1 and tostring(transmissionMod).." LVL" or 'Stock'


        if vehicleName == 'NULL' then
            exports.qbx_core:Notify('Vehicle name not defined.', 'error')
        elseif vehicleClass == nil then
            exports.qbx_core:Notify('Vehicle class not defined in config', 'error')
        else
            lib.registerContext({
                id = 'vehicle_menu',
                title = 'Vehicle Information',
                options = {
                    {
                        title = 'Vehicle Name',
                        description = 'Name: ' .. vehicleName,
                        icon = 'fa-solid fa-car',
                    },
                    {
                        title = 'Vehicle Class',
                        description = 'Class: ' .. vehicleClass,
                        icon = 'fa-solid fa-chart-simple',
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
                        title = 'Turbo',
                        description = 'Turbo: ' .. (turboEnabled and 'Enabled' or 'Disabled'),
                        icon = 'fa-solid fa-car',
                    },
                }
            })
            lib.showContext('vehicle_menu')
        end
    else
        exports.qbx_core:Notify('You are not in a vehicle.', 'error')
    end
end

RegisterCommand("vehinfo", OpenVehicleMenu)
