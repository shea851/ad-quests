use warnings;

sub EVENT_SPAWN {
	quest::settimer ("checkvex", 30);
}

sub EVENT_TIMER {

	my $ahr_npcid = 158096;

	if ($timer eq "checkvex") {
		if (not defined (plugin::ReadQGlobal("atencooldown"))) {
			if (not $entity_list->GetMobByNpcTypeID($ahr_npcid)) {
				@bossescheck = (158014,158010,158015,158012,158013,158007,158008,158011,158009);
				$bossesnowup = 0;
				foreach my $checkboss (@bossescheck) {
					if ($entity_list->GetMobByNpcTypeID($checkboss)) {
						++$bossesnowup;
					}
				}
				if ($bossesnowup == 0) {
					if (not $entity_list->GetMobByNpcTypeID($ahr_npcid)) {
						quest::depopall(158087);
						quest::depopall(158088);
						quest::depopall(158089);
						quest::depopall(158090);
						quest::depopall(158091);
						quest::depopall(158094);
						quest::spawn2($ahr_npcid,0,0,1412,0,248.63,192);
					}
				}
			}
		}
	}
}
