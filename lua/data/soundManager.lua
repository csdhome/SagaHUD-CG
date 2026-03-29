-- Sound Manager
-- Ported from SagaHUD AP 4.2
-- Plays audio feedback for autopilot events.
-- Sound files go in: MyDocuments/NQ/DualUniverse/audio/SagaHUD/

SoundManager = (function()
    local this = {}
    this.enabled = true
    this.currentPriority = -1

    -- Sound definitions: path relative to DU audio folder, priority (higher = more important)
    this.sounds = {
        uiSelect            = { path = 'SagaHUD/UI_Select.mp3',            priority = 0 },
        uiBack              = { path = 'SagaHUD/UI_Back.mp3',              priority = 0 },
        uiSwitch            = { path = 'SagaHUD/UI_Switch.mp3',            priority = 0 },
        autopilotEnabled    = { path = 'SagaHUD/AutopilotEnabled.mp3',     priority = 1 },
        autopilotDisabled   = { path = 'SagaHUD/AutopilotDisabled.mp3',    priority = 1 },
        startup             = { path = 'SagaHUD/Startup.mp3',              priority = 1 },
        destinationReached  = { path = 'SagaHUD/DestinationReached.mp3',   priority = 2 },
        waypointReached     = { path = 'SagaHUD/WaypointReached.mp3',      priority = 1 },
    }

    function this:init()
        local stored = Config:getValue(configDatabankMap.soundEnabled)
        if stored ~= nil then
            this.enabled = stored
        end
    end

    --- Play a sound by name if enabled and priority allows.
    --- @param soundName string key from this.sounds table
    --- @param force boolean|nil force play regardless of priority
    function this:play(soundName, force)
        if not this.enabled then return end
        local snd = this.sounds[soundName]
        if not snd then return end
        if system.playSound == nil then return end
        -- Play if nothing playing, forced, or higher/equal priority
        if force or snd.priority >= this.currentPriority then
            this.currentPriority = snd.priority
            system.playSound(snd.path)
        end
    end

    --- Toggle sound on/off.
    function this:toggle()
        this.enabled = not this.enabled
        Config:setValue(configDatabankMap.soundEnabled, this.enabled)
        P('Sounds ' .. (this.enabled and 'enabled' or 'disabled'))
    end

    return this
end)()
