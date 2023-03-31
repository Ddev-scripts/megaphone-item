# megaphone-item


FORK OF https://github.com/cbdev9/Megaphone-for-FiveM

## Changes
- Adapt for ESX
- Remove dependencies to scully emote
- Alternative of buggy PMA-VOICE overrideProximityRange


## TODO :
- Add qb-core player death event


## How to install

### Edit the cycleproximity command ( pma-voice → client → commands.lua)

```
RegisterCommand('cycleproximity', function()
	-- Proximity is either disabled, or manually overwritten.
	if GetConvarInt('voice_enableProximityCycle', 1) ~= 1 or disableProximityCycle then return end
	local newMode = mode + 1

	-- If we're within the range of our voice modes, allow the increase, otherwise reset to the first state
	if newMode <= #Cfg.voiceModes then
		-- If the current mode is Megaphone, skip it
		if Cfg.voiceModes[mode][2] == "Megaphone" then
			newMode = newMode + 1
		end

		-- If the next mode is Megaphone, skip it
		while newMode <= #Cfg.voiceModes and Cfg.voiceModes[newMode][2] == "Megaphone" do
			newMode = newMode + 1
			if newMode > #Cfg.voiceModes then -- Reset newMode to 1 if it exceeds the index limit
				newMode = 1
			end
		end

		mode = newMode
	else
		mode = 1
	end

	setProximityState(Cfg.voiceModes[mode][1], false)
	TriggerEvent('pma-voice:setTalkingMode', mode)
end, false)

```

### Add the new setMegaphone export ( pma-voice → client → commands.lua)

```
table.insert(Cfg.voiceModes, {60.0, "Megaphone"})
 
exports("setMegaphone", function(bool, value)
	if bool then
		mode = #Cfg.voiceModes
		setProximityState(Cfg.voiceModes[#Cfg.voiceModes][1], true)
		TriggerEvent('pma-voice:setTalkingMode', #Cfg.voiceModes)
	else
		mode = value
		setProximityState(Cfg.voiceModes[value][1], false)
		TriggerEvent('pma-voice:setTalkingMode', value)
	end
end)

```
### Drag and drop the resource :)

