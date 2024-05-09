local config = lib.require('config')

function vehicleHealthColor(progress)
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


local function OpenVehicleMenu()

    if cache.vehicle then
        local vehicle = cache.vehicle
        local fuelProgress
        
        local vehicleModelHash = GetEntityModel(vehicle)
        local vehicleSpawnCode = string.lower(GetDisplayNameFromVehicleModel(vehicleModelHash))
        local vehicleName = GetLabelText(GetDisplayNameFromVehicleModel(vehicleModelHash))
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

        if config.fuel == 'ox_fuel' then
            fuelProgress = Entity(vehicle)?.state and Entity(vehicle)?.state.fuel or GetVehicleFuelLevel(vehicle)
        else
            fuelProgress = exports[config.Fuel]:GetFuel(vehicle)
        end


        if vehicleName == 'NULL' then
            lib.notify({ description = 'Vehicle name not defined', type = 'error' })
        elseif vehicleClass == nil then
            lib.notify({ description = 'Vehicle class not defined in config', type = 'error' })
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
                        title = ('Fuel Level: %s'):format(tostring(math.ceil(fuelProgress))),
                        progress = math.ceil(fuelProgress),
                        colorScheme = '#FFFF00',
                        icon = 'fas fa-gas-pump'
                    },
                    {
                        title = ('Engine Health: %s'):format(tostring(math.ceil(lib.getVehicleProperties(vehicle).engineHealth / 10))),
                        progress = (lib.getVehicleProperties(vehicle).engineHealth / 10),
                        colorScheme = vehicleHealthColor(math.ceil(lib.getVehicleProperties(vehicle).engineHealth / 10)),
                        icon = 'fas fa-car-battery'
                    },
                    {
                        title = ('Body Health: %s'):format(tostring(math.ceil(lib.getVehicleProperties(vehicle).bodyHealth / 10))),
                        progress = (lib.getVehicleProperties(vehicle).bodyHealth / 10),
                        colorScheme = vehicleHealthColor(math.ceil(lib.getVehicleProperties(vehicle).bodyHealth / 10)),
                        icon = 'fas fa-car-burst'
                    },
                    {
                        title = 'Vehicle Primary Color',
                        description = 'Color: ' .. lib.getVehicleProperties(vehicle).color1,
                        icon = 'fa-solid fa-car',
                    },
                    {
                        title = 'Vehicle Secondary Color',
                        description = 'Color: ' .. lib.getVehicleProperties(vehicle).color2,
                        icon = 'fa-solid fa-car',
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
        lib.notify({ description = 'You are not in a vehicle', type = 'error' })
    end
end

RegisterCommand("vehinfo", OpenVehicleMenu)


