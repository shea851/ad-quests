# Author: Corporate
# Date: 20171229
# Purpose: Make those pesky dd wards do something

sub EVENT_SPAWN
{
	quest::settimer("ddAura", 12);
	quest::settimer("ddAuraSpawn", 1); # If you cast spell directly in event_spawn it is bugged
}

sub EVENT_TIMER
{
	if ($timer eq "ddAura")
	{
		$npc->CastSpell(4841, $mobid);
	}
	elsif ($timer eq "ddAuraSpawn")
	{
		quest::stoptimer("ddAuraSpawn");
		$npc->CastSpell(4841, $mobid);
	}
}