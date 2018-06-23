function event_death_complete(e)
	-- send a signal to the zone_status that I died
	eq.signal(223097,6);
end

function event_spawn(e)
    eq.set_next_hp_event(85)
end

function event_hp(e)
    -- His resists are suppose to change?
    if (e.hp_event == 85) then
        eq.modify_npc_stat("min_hit", "600")
        eq.modify_npc_stat("max_hit", "1300")
        eq.zone_emote(15, "Blisters and festering sores covering Bertoxxulous's hide burst. A noxious ooze bleeds down his scarred flesh, strengthening his physical body.")
        eq.set_next_hp_event(70)
    elseif (e.hp_event == 70) then
        eq.modify_npc_stat("min_hit", "700")
        eq.modify_npc_stat("max_hit", "1500")
        eq.zone_emote(15, "Blisters and festering sores covering Bertoxxulous's hide burst. A noxious ooze bleeds down his scarred flesh, strengthening his physical body.")
        eq.set_next_hp_event(55)
    elseif (e.hp_event == 55) then
        eq.modify_npc_stat("min_hit", "800")
        eq.modify_npc_stat("max_hit", "1700")
        eq.zone_emote(15, "Blisters and festering sores covering Bertoxxulous's hide burst. A noxious ooze bleeds down his scarred flesh, strengthening his physical body.")
        eq.set_next_hp_event(40)
    elseif (e.hp_event == 40) then
        eq.modify_npc_stat("min_hit", "700")
        eq.modify_npc_stat("max_hit", "1500")
        eq.zone_emote(15, "Bertoxxulous falters, nearly imperceptibly.")
        eq.set_next_hp_event(25)
    elseif (e.hp_event == 25) then
        eq.modify_npc_stat("min_hit", "600")
        eq.modify_npc_stat("max_hit", "1300")
        eq.zone_emote(15, "Bertoxxulous falters, nearly imperceptibly.")
        eq.set_next_hp_event(10)
    elseif (e.hp_event == 10) then
        eq.modify_npc_stat("min_hit", "500")
        eq.modify_npc_stat("max_hit", "1200")
        eq.zone_emote(15, "Bertoxxulous falters, nearly imperceptibly.")
    end
end
