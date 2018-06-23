# Author: Corporate
# Date: 20180210

sub EVENT_CLICKDOOR
{
	if (($doorid >= 8 and $doorid <= 12) and ($client->GetRaid()))
	{
		my $instZoneID = 223;									# Plane of Time B 223
		my $instZoneSN = plugin::ZoneShortName($instZoneID); 	# potimeb
		my $instTime = 43200; 									# 12 hours in seconds (43200) - instance duration
	
		# Get instance ID "assigned" to your raid
		my $raidInstID = plugin::AD_GetRaidInstanceId($client->GetRaid()->GetID(), $instZoneID);
		# Get client lockout status
		my $lockedOut = plugin::AD_CheckInstanceLockout($charid, $instZoneID);
		
		# No instance tied to raid, and client not locked out
		if (($raidInstID == 0) and ($lockedOut == 0))
		{
			# Create instance
			my $createdInst = quest::CreateInstance($instZoneSN, 0, $instTime);
			# Tie raid and instance together
			plugin::AD_AddRaidInstance($client->GetRaid()->GetID(), $instZoneID, $createdInst, $instTime);
			# Set to phase 1 initially
			plugin::AD_UpdateRaidInstanceProgress($instZoneID, $createdInst, "phase", 1);
			# Assign client
			$client->AssignToInstance($createdInst);
			#$client->Message(15, "[DEBUG] Created and joined instance.");
		}
		# Instance is tied to raid, and client not locked out
		elsif (($raidInstID > 0) and ($lockedOut == 0))
		{
			# Remove any old instance
			plugin::RemoveCharacterFromInstance();
			# Assign to instance tied to raid
			$client->AssignToInstance($raidInstID);
			#$client->Message(15, "[DEBUG] Joined instance.");
		}
		# No instance tied to raid, and client is locked out
		elsif (($raidInstID == 0) and ($lockedOut != 0))
		{
			#$client->Message(15, "[DEBUG] Lockout status: ".$lockedOut);
			#$client->Message(15, "[DEBUG] Instance ID: ".$raidInstID);
			my $lockoutTimeRemaining = plugin::AD_GetInstanceLockoutTimeRemaining($charid, $instZoneID);
			$client->Message(15, "Locked out: ".$lockoutTimeRemaining);
		}
					
		# Get client instance they are currently in
		my $clientInstID = quest::GetInstanceID($instZoneSN, 0);
		
		if ($clientInstID > 0)
		{
			my $raidInstPhase = plugin::AD_GetRaidInstanceProgress($instZoneID, $raidInstID, "phase");
			
			$client->Message(10, "The portal, dim at first, begins to glow brighter.");
			$client->Message(10, "The portal flashes briefly, then glows steadily.");
			
			# Send client to their instance
			if ($raidInstPhase == 6)
			{
				quest::MovePCInstance($instZoneID, $clientInstID, 337, 1, 8, 64);
			}
			elsif ($raidInstPhase == 5)
			{
				quest::MovePCInstance($instZoneID, $clientInstID, -358, 0, 4, 64);
			}
			elsif ($raidInstPhase == 4)
			{
				quest::MovePCInstance($instZoneID, $clientInstID, -382, -11, 349, 62);
			}
			elsif ($raidInstPhase == 3)
			{
				quest::MovePCInstance($instZoneID, $clientInstID, 681, 1113, 496, 56);
			}
			# Phase 1 - 2
			else
			{
				if ($doorid == 8) # Phase 1 - Air
				{
					quest::MovePCInstance($instZoneID, $clientInstID, -36, 1352, 496, 62);
				}
				elsif ($doorid == 9) # Phase 1 - Water
				{
					quest::MovePCInstance($instZoneID, $clientInstID, -51, 857, 496, 62);
				}
				elsif ($doorid == 10) # Phase 1 - Earth
				{
					quest::MovePCInstance($instZoneID, $clientInstID, -35, 1636, 496, 62);
				}
				elsif ($doorid == 11) # Phase 1 - Fire
				{
					quest::MovePCInstance($instZoneID, $clientInstID, -55, 569, 496, 62);
				}
				elsif ($doorid == 12) # Phase 1 - Undead
				{
					quest::MovePCInstance($instZoneID, $clientInstID, -27, 1103, 496, 62);
				}
			}
		}
	}
	else
	{
		$client->Message(15, "You are not in a raid.");
	}
}