# Ported to perl on 3/3/18 -Corporate

use warnings;

sub EVENT_SPAWN
{
	quest::setnexthpevent(76);
}

sub EVENT_SIGNAL
{
	if ($signal == 1)
	{
		quest::start(1);
	}
}

sub EVENT_WAYPOINT_ARRIVE
{
	if ($wp == 1)
	{
		quest::stop();
	}
}

sub EVENT_COMBAT
{
	if ($combat_state)
	{
		quest::settimer("quarm_adds", 30);
	}
	else
	{
		quest::stoptimer("quarm_adds");
	}
}

sub EVENT_TIMER
{
	if ($timer eq "quarm_adds")
	{
		# depop existing time vortex mobs
		quest::depopall(223112);
		# cast random AE
		$npc->CastSpell(quest::ChooseRandom(3770, 3771, 3769, 3768, 3780, 3767, 3773, 3777), $npc->GetID());
		# spawn 3 new ones randomly around Quarm.
		quest::spawn2(223112, 0, 0, $x+int(rand(100)-50), $y+int(rand(100)-50), $z, $h);
		quest::spawn2(223112, 0, 0, $x+int(rand(100)-50), $y+int(rand(100)-50), $z, $h);
		quest::spawn2(223112, 0, 0, $x+int(rand(100)-50), $y+int(rand(100)-50), $z, $h);
	}
}

sub EVENT_HP
{
	if ($hpevent == 76)
	{
		quest::emote(" roars in pain as his red head explodes in a shower of flaming ethereal energy!");
		$npc->SendIllusion(304, 2, 1, 1, 0, 1, 1, 0, 1, 0, 0, 0, 70); # remove red head
		$npc->CastSpell(3230, $npc->GetID());
		quest::setnexthpevent(51);
	}
	elsif ($hpevent == 51)
	{
		quest::emote(" roars in pain as his blue head explodes into pure ethereal energy!");
		$npc->SendIllusion(304, 2, 2, 2, 0, 1, 1, 0, 1, 0, 0, 0, 70); # remove blue head
		$npc->CastSpell(3230, $npc->GetID());
		quest::setnexthpevent(26);
	}
	elsif ($hpevent == 26)
	{
		quest::emote(" shakes the cavern with a bellow of pain as the white head explodes into a swirling vortex of ethereal energy!");
		$npc->SendIllusion(304, 2, 3, 3, 0, 1, 1, 0, 1, 0, 0, 0, 70); # remove white head
		$npc->CastSpell(3230, $npc->GetID());
	}
}

sub EVENT_DEATH_COMPLETE
{
	# signal zone_status that I died
	quest::signalwith(223097,7,1);
	# depop existing time vortex mobs
	quest::depopall(223112);
	# depop untargetable and pop targetable spawn Zebuxoruk's Cage
	quest::depop(223228);
	quest::spawn2(223214,0,0,-579,-1119,60.625,0);
	# emote to server that quarm died
	quest::we(15, "For a brief moment, it feels as if all time has stopped. Inside your mind, you hear a great beast screaming as it takes one last breath. It has been done. The gods have been overthrown.");
	quest::we(15, "After a short moment of peace and joy, you are swallowed by the horror of what has happened. You say, out loud for no one to hear, 'What have we done?'");
}

sub EVENT_KILLED_MERIT
{
	plugin::KillMerit();
}