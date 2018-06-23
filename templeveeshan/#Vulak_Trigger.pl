#Spawns Vulak if no boss mobs are up. 

sub EVENT_SPAWN {
	quest::settimer("checkvulak", 30);
}

sub EVENT_TIMER {
	if ($timer eq "checkvulak") {
		if (not defined (plugin::ReadQGlobal("vulakcooldown"))) {
			@bossestocheck = (124077,124076,124008,124103,124074,124017);
			$bossesup = 0;
			foreach $checkboss (@bossestocheck) {
				if ($entity_list->GetMobByNpcTypeID($checkboss)) {
					++$bossesup;
				}
			}
			if ($bossesup == 0) {
				if (not $entity_list->GetMobByNpcTypeID(124155)) {
					quest::spawn2(124155,0,0,-739.4,517.2,121,255); ## Spawn Vulak
				}
			}
		}
	}
}