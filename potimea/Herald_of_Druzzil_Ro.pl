# Author: Corporate
# Date: 20180125

use warnings;

my $instZoneID = 223; # Plane of Time B
my $instTime = 43200; # 12 hours in seconds (43200) - instance duration

sub EVENT_SAY
{
	if ($text =~/Hail/i)
	{
		plugin::Whisper("I am sorry if we have met and I do not remember you. I have become more and more fractured. My time here is short as I feel my existence slipping away. Quickly - tell me what you need.");
		plugin::Whisper("Translocate to [".quest::saylink("The Plane of Knowledge",1)."]");
		
		# Must be in raid
		if ($client->GetRaid())
		{
			if (CheckLockout($instZoneID) == 0)
			{
				# Get instance ID "assigned" to your raid
				my $raidInstID = plugin::AD_GetRaidInstanceId($client->GetRaid()->GetID(), $instZoneID);
				if ($raidInstID == 0)
				{
					plugin::Whisper("Begin at the start of [".quest::saylink("p2ask",1,"Phase 2")."], [".quest::saylink("p3ask",1,"Phase 3")."], [".quest::saylink("p4ask",1,"Phase 4")."], or [".quest::saylink("p5ask",1,"Phase 5")."]?");
				}
				else
				{
					plugin::Whisper("You raid already has an instance assigned to it.");
				}
			}
		}
		else
		{
			plugin::Whisper("You must be in a raid if you want further help from me.");
		}
	}
	elsif ($text =~/p2ask/i)
	{
		plugin::Whisper("Create Plane of Time B instance for your raid at beginning of Phase 2 - Are you sure? [".quest::saylink("p2confirmed", 1, "Yes")."]");
	}
	elsif ($text =~/p3ask/i)
	{
		plugin::Whisper("Create Plane of Time B instance for your raid at beginning of Phase 3 - Are you sure? [".quest::saylink("p3confirmed", 1, "Yes")."]");
	}
	elsif ($text =~/p4ask/i)
	{
		plugin::Whisper("Create Plane of Time B instance for your raid at beginning of Phase 4 - Are you sure? [".quest::saylink("p4confirmed", 1, "Yes")."]");
	}
	elsif ($text =~/p5ask/i)
	{
		plugin::Whisper("Create Plane of Time B instance for your raid at beginning of Phase 5 - Are you sure? [".quest::saylink("p5confirmed", 1, "Yes")."]");
	}
	elsif ($text =~/The Plane of Knowledge/i)
	{
		plugin::Whisper("Translocate to The Plane of Knowledge - Are you sure? [".quest::saylink("tlpokconfirmed", 1, "Yes")."]");
	}
	elsif ($text =~/p2confirmed/i)
	{
		CreateRaidInstance(2);
	}
	elsif ($text =~/p3confirmed/i)
	{
		CreateRaidInstance(3);
	}
	elsif ($text =~/p4confirmed/i)
	{
		CreateRaidInstance(4);
	}
	elsif ($text =~/p5confirmed/i)
	{
		CreateRaidInstance(5);
	}
	elsif ($text =~/tlpokconfirmed/i)
	{
		quest::movepc(202, 232.92, -248.8, -125.0, 165.0);
	}
}

sub CheckLockout
{
	my $instZoneID = $_[0]; # The zoneid of instance
	
	# Get client lockout status
	my $lockedOut = plugin::AD_CheckInstanceLockout($charid, $instZoneID);
	
	# If lockout is not 0, then client is locked out
	if ($lockedOut != 0)
	{
		my $lockoutTimeRemaining = plugin::AD_GetInstanceLockoutTimeRemaining($charid, $instZoneID);
		plugin::Whisper("Your lockout time has ".$lockoutTimeRemaining." remaining.");
		return 1;
	}
	
	return 0;
}

sub CreateRaidInstance
{
	my $instZonePhase = $_[0]; # The phase of instance to set to
	my $instZoneSN = plugin::ZoneShortName($instZoneID); # potimeb
	my $instMsg = plugin::Zone($instZoneID)." (".$instZoneSN.")."; # "The Plane of Time (potimeb)"
	
	# Get client lockout status
	my $lockedOut = plugin::AD_CheckInstanceLockout($charid, $instZoneID);
	
	# Player must be in a raid. This is a "double check" at this point.
	if ($client->GetRaid() and $lockedOut == 0)
	{
		# If this is zero then we should create an instance.
		my $raidInstID = plugin::AD_GetRaidInstanceId($client->GetRaid()->GetID(), $instZoneID);
		if ($raidInstID == 0)
		{
			my $createdInst = quest::CreateInstance($instZoneSN, 0, $instTime);
			plugin::AD_AddRaidInstance($client->GetRaid()->GetID(), $instZoneID, $createdInst, $instTime);
			plugin::AD_UpdateRaidInstanceProgress($instZoneID, $createdInst, "phase", $instZonePhase);
			plugin::Whisper("Instance created: ".$instMsg);
			plugin::Whisper("Time Phase set to: ".$instZonePhase);
		}
		else
		{
			plugin::Whisper("You raid already has an instance assigned to it.");
		}
	}
}
