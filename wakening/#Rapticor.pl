sub EVENT_COMBAT {
	if($combat_state==1) {
		quest::emote("pounces on $name in a flurry of deadly claws and teeth.");
	}
}

sub EVENT_DEATH_COMPLETE
{	
	plugin::SpawnFabled();
}
