# Author: Corporate
# Date: 20171229
# Purpose: Make those pesky healing wards do something

sub EVENT_SPAWN
{
	quest::settimer("healAura", 11);
	quest::settimer("healAuraSpawn", 1); # If you cast spell directly in event_spawn it is bugged
}

sub EVENT_TIMER
{
	if ($timer eq "healAura")
	{
		$npc->CastSpell(4795, $mobid);
	}
	elsif ($timer eq "healAuraSpawn")
	{
		quest::stoptimer("healAuraSpawn");
		$npc->CastSpell(4795, $mobid);
	}
}