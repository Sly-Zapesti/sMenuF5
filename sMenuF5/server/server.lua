ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

ESX.RegisterServerCallback('sly:playergroup', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
	if xPlayer ~= nil then
		local playerGroup = xPlayer.getGroup()
        if playerGroup ~= nil then 
            cb(playerGroup)
        else
            cb(nil)
        end
	else
		cb(nil)
	end
end)

ESX.RegisterServerCallback('Sly:facture', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)

	MySQL.Async.fetchAll('SELECT * FROM billing WHERE identifier = @identifier', {
		['@identifier'] = xPlayer.identifier
	}, function(result)
		local bills = {}

		for i = 1, #result do
			bills[#bills + 1] = {
				id = result[i].id,
				label = result[i].label,
				amount = result[i].amount
			}
		end

		cb(bills)
	end)
end)


ESX.RegisterServerCallback('Sly:getOtherPlayerData', function(source, cb, target, notify)
	local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)


    if xPlayer then
        local data = {
            name = xPlayer.getName(),
            job = xPlayer.job.label,
            grade = xPlayer.job.grade_label,
            inventory = xPlayer.getInventory(),
            accounts = xPlayer.getAccounts(),
            weapons = xPlayer.getLoadout(),
			--argentpropre = xPlayer.getMoney()
        }

        cb(data)
    end
end)

RegisterServerEvent('Sly:RecruterF5')
AddEventHandler('Sly:RecruterF5', function(target, job, grade)
	local _source = source
	local sourceXPlayer = ESX.GetPlayerFromId(_source)
	local targetXPlayer = ESX.GetPlayerFromId(target)
	targetXPlayer.setJob(job, grade)
	TriggerClientEvent('esx:showNotification', _source, "Vous avez ~g~recruté " .. targetXPlayer.name .. "~w~.")
	TriggerClientEvent('esx:showNotification', target, "Vous avez été ~g~embauché par " .. sourceXPlayer.name .. "~w~.")
end)

RegisterServerEvent('Sly:PromotionF5')
AddEventHandler('Sly:PromotionF5', function(target)
	local _source = source

	local sourceXPlayer = ESX.GetPlayerFromId(_source)
	local targetXPlayer = ESX.GetPlayerFromId(target)

	if (targetXPlayer.job.grade == 3) then
		TriggerClientEvent('esx:showNotification', _source, "Vous ne pouvez pas plus ~b~promouvoir~w~ d'avantage.")
	else
		if (sourceXPlayer.job.name == targetXPlayer.job.name) then
			local grade = tonumber(targetXPlayer.job.grade) + 1
			local job = targetXPlayer.job.name

			targetXPlayer.setJob(job, grade)

			TriggerClientEvent('esx:showNotification', _source, "Vous avez ~b~promu " .. targetXPlayer.name .. "~w~.")
			TriggerClientEvent('esx:showNotification', target, "Vous avez été ~b~promu~s~ par " .. sourceXPlayer.name .. "~w~.")
		end
	end
end)


RegisterServerEvent('Sly:RetrograderF5')
AddEventHandler('Sly:RetrograderF5', function(target)
	local _source = source

	local sourceXPlayer = ESX.GetPlayerFromId(_source)
	local targetXPlayer = ESX.GetPlayerFromId(target)

	if (targetXPlayer.job.grade == 0) then
		TriggerClientEvent('esx:showNotification', _source, "Vous ne pouvez pas plus ~r~rétrograder~w~ d'avantage.")
	else
		if (sourceXPlayer.job.name == targetXPlayer.job.name) then
			local grade = tonumber(targetXPlayer.job.grade) - 1
			local job = targetXPlayer.job.name

			targetXPlayer.setJob(job, grade)

			TriggerClientEvent('esx:showNotification', _source, "Vous avez ~r~rétrogradé " .. targetXPlayer.name .. "~w~.")
			TriggerClientEvent('esx:showNotification', target, "Vous avez été ~r~rétrogradé par " .. sourceXPlayer.name .. "~w~.")
		else
			TriggerClientEvent('esx:showNotification', _source, "Vous n'avez pas ~r~l'autorisation~w~.")
		end
	end
end)

RegisterServerEvent('Sly:VirerF5')
AddEventHandler('Sly:VirerF5', function(target)
	local _source = source
	local sourceXPlayer = ESX.GetPlayerFromId(_source)
	local targetXPlayer = ESX.GetPlayerFromId(target)
	local job = "unemployed"
	local grade = "0"
	if (sourceXPlayer.job.name == targetXPlayer.job.name) then
		targetXPlayer.setJob(job, grade)
		TriggerClientEvent('esx:showNotification', _source, "Vous avez ~r~viré " .. targetXPlayer.name .. "~w~.")
		TriggerClientEvent('esx:showNotification', target, "Vous avez été ~g~viré par " .. sourceXPlayer.name .. "~w~.")
	else
		TriggerClientEvent('esx:showNotification', _source, "Vous n'avez pas ~r~l'autorisation~w~.")
	end
end)

RegisterServerEvent('Sly:MenuGangRecruterF5')
AddEventHandler('Sly:MenuGangRecruterF5', function(target, job, grade)
	local _source = source
	local sourceXPlayer = ESX.GetPlayerFromId(_source)
	local targetXPlayer = ESX.GetPlayerFromId(target)
	targetXPlayer.setJob2(job, grade)
	TriggerClientEvent('esx:showNotification', _source, "Vous avez ~g~recruté " .. targetXPlayer.name .. "~w~.")
	TriggerClientEvent('esx:showNotification', target, "Vous avez été ~g~embauché par " .. sourceXPlayer.name .. "~w~.")
end)

RegisterServerEvent('Sly:MenuGangPromotionF5')
AddEventHandler('Sly:MenuGangPromotionF5', function(target)
	local _source = source

	local sourceXPlayer = ESX.GetPlayerFromId(_source)
	local targetXPlayer = ESX.GetPlayerFromId(target)

	if (targetXPlayer.job2.grade == 3) then
		TriggerClientEvent('esx:showNotification', _source, "Vous ne pouvez pas plus ~b~promouvoir~w~ d'avantage.")
	else
		if (sourceXPlayer.job2.name == targetXPlayer.job2.name) then
			local grade = tonumber(targetXPlayer.job2.grade) + 1
			local job = targetXPlayer.job2.name

			targetXPlayer.setJob2(job, grade)

			TriggerClientEvent('esx:showNotification', _source, "Vous avez ~b~promu " .. targetXPlayer.name .. "~w~.")
			TriggerClientEvent('esx:showNotification', target, "Vous avez été ~b~promu~s~ par " .. sourceXPlayer.name .. "~w~.")
		end
	end
end)


RegisterServerEvent('Sly:MenuGangRetrograderF5')
AddEventHandler('Sly:MenuGangRetrograderF5', function(target)
	local _source = source

	local sourceXPlayer = ESX.GetPlayerFromId(_source)
	local targetXPlayer = ESX.GetPlayerFromId(target)

	if (targetXPlayer.job2.grade == 0) then
		TriggerClientEvent('esx:showNotification', _source, "Vous ne pouvez pas plus ~r~rétrograder~w~ d'avantage.")
	else
		if (sourceXPlayer.job2.name == targetXPlayer.job2.name) then
			local grade = tonumber(targetXPlayer.job2.grade) - 1
			local job = targetXPlayer.job2.name

			targetXPlayer.setJob2(job, grade)

			TriggerClientEvent('esx:showNotification', _source, "Vous avez ~r~rétrogradé " .. targetXPlayer.name .. "~w~.")
			TriggerClientEvent('esx:showNotification', target, "Vous avez été ~r~rétrogradé par " .. sourceXPlayer.name .. "~w~.")
		else
			TriggerClientEvent('esx:showNotification', _source, "Vous n'avez pas ~r~l'autorisation~w~.")
		end
	end
end)

RegisterServerEvent('Sly:MenuGangVirerF5')
AddEventHandler('Sly:MenuGangVirerF5', function(target)
	local _source = source
	local sourceXPlayer = ESX.GetPlayerFromId(_source)
	local targetXPlayer = ESX.GetPlayerFromId(target)
	local job = "unemployed"
	local grade = "0"
	if (sourceXPlayer.job2.name == targetXPlayer.job2.name) then
		targetXPlayer.setJob2(job, grade)
		TriggerClientEvent('esx:showNotification', _source, "Vous avez ~r~viré " .. targetXPlayer.name .. "~w~.")
		TriggerClientEvent('esx:showNotification', target, "Vous avez été ~g~viré par " .. sourceXPlayer.name .. "~w~.")
	else
		TriggerClientEvent('esx:showNotification', _source, "Vous n'avez pas ~r~l'autorisation~w~.")
	end
end)

-------------- ADMINISTRATION ----------------------


ESX.RegisterServerCallback('Sly:getUsergroup', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
	local group = xPlayer.getGroup()
	cb(group)
end)

ESX.RegisterServerCallback('Sly:AdminvehiculeMenuF', function(source, cb)

    local xPlayer = ESX.GetPlayerFromId(source)
    local adminveh = {}

    MySQL.Async.fetchAll('SELECT * FROM sly_adminvehicule', {

    }, function(result)

        for i=1, #result, 1 do

            table.insert(adminveh, {
                name = result[i].name,
                label = result[i].label,
                category = result[i].category,
            })

        end

        cb(adminveh)
    
    end)

end)


RegisterNetEvent('Sly:AdminGiveMoneyMenuF')
AddEventHandler('Sly:AdminGiveMoneyMenuF', function(tik)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)

	xPlayer.addMoney(tik)
end)


RegisterServerEvent("Sly:AmmuAchatPistolet")
AddEventHandler("Sly:AmmuAchatPistolet", function(label)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)

    
	xPlayer.addWeapon(label, 250)
	
		
end)

RegisterServerEvent("Sly:AmmuAchatMitraillette")
AddEventHandler("Sly:AmmuAchatMitraillette", function(label)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)

    
	xPlayer.addWeapon(label, 250)
		
end)

RegisterServerEvent("Sly:AmmuAchatPompe")
AddEventHandler("Sly:AmmuAchatPompe", function(label)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)

    
	xPlayer.addWeapon(label, 250)
		
end)

RegisterServerEvent("Sly:AmmuAchatAssault")
AddEventHandler("Sly:AmmuAchatAssault", function(label)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)

    
	xPlayer.addWeapon(label, 250)
		
end)

RegisterServerEvent("Sly:AmmuAchatMitrailleur")
AddEventHandler("Sly:AmmuAchatMitrailleur", function(label)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)

	xPlayer.addWeapon(label, 250)
		
end)

RegisterServerEvent("Sly:AmmuAchatSniper")
AddEventHandler("Sly:AmmuAchatSniper", function(label)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)

	xPlayer.addWeapon(label, 250)
		
end)

RegisterServerEvent("Sly:AmmuAchatLanceur")
AddEventHandler("Sly:AmmuAchatLanceur", function(label)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)

    xPlayer.addWeapon(label, 250)
		
end)

RegisterServerEvent("Sly:AmmuAchatGrenade")
AddEventHandler("Sly:AmmuAchatGrenade", function(label)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)

    xPlayer.addWeapon(label, 250)
		
end)

RegisterServerEvent("Sly:AmmuAchatArmeBlanche")
AddEventHandler("Sly:AmmuAchatArmeBlanche", function(label)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)

    xPlayer.addWeapon(label, 250)
		
end)

