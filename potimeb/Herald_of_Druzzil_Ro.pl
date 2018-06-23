# Author: Corporate
# Date: 20180303

use warnings;

sub EVENT_SAY
{
	if ($text =~/Hail/i)
	{
		plugin::Whisper("I feel much stronger within the bounds of this plane. Tell me what you need and I will assist you any way that I can.");
		plugin::Whisper("Translocate to [".quest::saylink("Earth Trial",1)."]");
		plugin::Whisper("Translocate to [".quest::saylink("Air Trial",1)."]");
		plugin::Whisper("Translocate to [".quest::saylink("Undead Trial",1)."]");
		plugin::Whisper("Translocate to [".quest::saylink("Water Trial",1)."]");
		plugin::Whisper("Translocate to [".quest::saylink("Fire Trial",1)."]");
		plugin::Whisper("Translocate to [".quest::saylink("The Plane of Time A",1)."]");
	}
	elsif ($text =~/Earth Trial/i)
	{
		quest::MovePCInstance(223, $instanceid, -48, 1636.5, 496.5, 125);
	}
	elsif ($text =~/Air Trial/i)
	{
		quest::MovePCInstance(223, $instanceid, -48, 1353.5, 496.5, 125);
	}
	elsif ($text =~/Undead Trial/i)
	{
		quest::MovePCInstance(223, $instanceid, -28, 1114.5, 496.5, 125);
	}
	elsif ($text =~/Water Trial/i)
	{
		quest::MovePCInstance(223, $instanceid, -48, 858.5, 496.5, 125);
	}
	elsif ($text =~/Fire Trial/i)
	{
		quest::MovePCInstance(223, $instanceid, -48, 575.5, 496.5, 125);
	}
	elsif ($text =~/The Plane of Time A/i)
	{
		plugin::Whisper("Translocate to The Plane of Time A - Are you sure? [".quest::saylink("tlconfirmed", 1, "Yes")."]");
	}
	elsif ($text=~/tlconfirmed/i)
	{
		quest::movepc(219, -37, -110, 8, 0);
	}
}