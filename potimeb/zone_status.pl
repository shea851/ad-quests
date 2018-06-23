# Author: Corporate
# Date: 20180211

# Notes:
# Logic for fail timer did not make it in because it just isn't in our server vision.

use warnings;

my $instZoneID = 223; # Plane of Time B 223
my $raidInstID = 0;

sub EVENT_SPAWN
{
	# Get instance id
	$raidInstID = $instanceid;
	# Reset all spawn conditions in zone
	ResetAllSpawnConditions();
	# Check which phase
	$phase = plugin::AD_GetRaidInstanceProgress($instZoneID, $raidInstID, "phase");

	if ($phase == 1)
	{
		SpawnPhaseOne();
	}
	elsif ($phase == 2)
	{
		UnlockPhaseOneDoors();
		# zone_emoter (223227)
		quest::signalwith(223227,2,1);
		SpawnPhaseTwo();
	}
	elsif ($phase == 3)
	{
		UnlockPhaseOneDoors();
		UnlockPhaseTwoDoors();
		SpawnPhaseThree();
	}
	elsif ($phase == 4)
	{
		UnlockPhaseOneDoors();
		UnlockPhaseTwoDoors();
		UnlockPhaseThreePortal();
		SpawnPhaseFour();
	}
	elsif ($phase == 5)
	{
		UnlockPhaseOneDoors();
		UnlockPhaseTwoDoors();
		UnlockPhaseThreePortal();
		UnlockPhaseFourStone();
		SpawnPhaseFive();	
	}
	elsif ($phase == 6)
	{
		UnlockPhaseOneDoors();
		UnlockPhaseTwoDoors();
		UnlockPhaseThreePortal();
		UnlockPhaseFourStone();
		UnlockPhaseFiveStone();
		SpawnPhaseSix();
	}
	elsif ($phase == 7)
	{
		UnlockPhaseOneDoors();
		UnlockPhaseTwoDoors();
		UnlockPhaseThreePortal();
		UnlockPhaseFourStone();
		UnlockPhaseFiveStone();
	}
}

sub EVENT_SIGNAL
{
	# Check which phase, stage, and step
	$phase = plugin::AD_GetRaidInstanceProgress($instZoneID, $raidInstID, "phase");
	$stage = plugin::AD_GetRaidInstanceProgress($instZoneID, $raidInstID, "stage");
	
	# Signal 1 comes from the phase 1 trigger mobs
	# If we are on phase 1 and stage 0 emote some stuff
	# Then update us to stage 1 which means phase 1 in progress
	if (($signal == 1) and ($phase == 1) and ($stage == 0))
	{
		# zone_emoter (223227)
		quest::signalwith(223227,1,1);
		# Set to stage 1
		plugin::AD_UpdateRaidInstanceProgress($instZoneID, $raidInstID, "stage", 1);
	}
	# Signal 2 comes from a phase 1 boss dying (or in other words, completing a phase 1 event)
	elsif ($signal == 2)
	{
		ControlPhaseOne();
	}
	# Signal 3 comes from a phase 2 mob dying
	elsif ($signal == 3)
	{
		ControlPhaseTwo();
	}
	# Signal 4 comes from a phase 3 mob dying
	elsif ($signal == 4)
	{
		ControlPhaseThree();
	}
	# Signal 5 comes from a phase 4 gods dying
	elsif ($signal == 5)
	{
		ControlPhaseFour();
	}
	# Signal 6 comes from a phase 5 gods dying
	elsif ($signal == 6)
	{
		ControlPhaseFive();
	}
	# Signal 7 comes from Quarm in phase 6
	elsif ($signal == 7)
	{
		plugin::AD_UpdateRaidInstanceProgress($instZoneID, $raidInstID, "phase", 7); # Update to phase 7
		UpdateLockouts(244800); # 68 hour lockout for completing P6
	}
	# Signal 8 comes from Druzzil Ro or something
	elsif ($signal == 8)
	{
		# kick everyone and depop zone? nahh I'm too nice
	}
}

sub ControlPhaseOne
{
	# Check which phase and stage
	$phase = plugin::AD_GetRaidInstanceProgress($instZoneID, $raidInstID, "phase");
	$stage = plugin::AD_GetRaidInstanceProgress($instZoneID, $raidInstID, "stage");
	
	# There are 5 events so we should end up with stage equal to 6 when phase 1 is complete
	if (($phase == 1) and ($stage > 0))
	{
		$stage++;
		
		if ($stage < 6)
		{
			plugin::AD_UpdateRaidInstanceProgress($instZoneID, $raidInstID, "stage", $stage);
		}
		# This means phase 1 is complete
		elsif ($stage == 6)
		{
			# Update to phase 2 stage 0
			plugin::AD_UpdateRaidInstanceProgress($instZoneID, $raidInstID, "phase", 2);
			plugin::AD_UpdateRaidInstanceProgress($instZoneID, $raidInstID, "stage", 0);
			UnlockPhaseOneDoors();
			# zone_emoter (223227)
			quest::signalwith(223227,2,1);
			# Spawn phase 2 mobs without the named
			SpawnPhaseTwo();
		}
	}
}

sub SpawnPhaseOne
{
		# Spawn phase 1
		quest::spawn2(223169,0,0,13.5,1632.4,492.3,0); # earth trigger
		quest::spawn2(223170,0,0,10.1,1350,492.6,0); # air trigger
		quest::spawn2(223171,0,0,18.0,1107,492.2,0); # undead trigger
		quest::spawn2(223172,0,0,11.5,857,492.5,0); # water trigger
		quest::spawn2(223173,0,0,13.2,574.2,492.3,0); # fire trigger
		
		# QOL teleporters
		quest::spawn2(219055,0,0,-57.5,1636.5,496.5,80); # earth teleporter
		quest::spawn2(219055,0,0,-57.5,1353.5,496.5,80); # air teleporter
		quest::spawn2(219055,0,0,-38.5,1114.5,496.5,80); # undead teleporter
		quest::spawn2(219055,0,0,-57.5,858.5,496.5,80); # water teleporter
		quest::spawn2(219055,0,0,-57.5,575.5,496.5,80); # fire teleporter
}

sub ControlPhaseTwo
{
	# Check which phase, stage, and step
	$phase = plugin::AD_GetRaidInstanceProgress($instZoneID, $raidInstID, "phase");
	$stage = plugin::AD_GetRaidInstanceProgress($instZoneID, $raidInstID, "stage");
	$step = plugin::AD_GetRaidInstanceProgress($instZoneID, $raidInstID, "step");

	if ($phase == 2)
	{
		$step++;
		
		if ($stage == 0)
		{
			# 45 mobs must die for stage 0 of phase 2
			if ($step < 45)
			{
				plugin::AD_UpdateRaidInstanceProgress($instZoneID, $raidInstID, "step", $step);
			}
			# This means first part of phase 2 is completed
			elsif ($step == 45)
			{
				plugin::AD_UpdateRaidInstanceProgress($instZoneID, $raidInstID, "stage", 1);
				plugin::AD_UpdateRaidInstanceProgress($instZoneID, $raidInstID, "step", 0);
				# Spawn phase 2 again, this time with named
				SpawnPhaseTwo();
			}
		}
		
		# 50 mobs must die for stage 1 of phase 2
		# This means phase 2 is complete
		if ($stage == 1)
		{
			if ($step < 50)
			{
				plugin::AD_UpdateRaidInstanceProgress($instZoneID, $raidInstID, "step", $step);
			}
			elsif ($step == 50)
			{
				# Update to phase 3 stage 0 step 0
				plugin::AD_UpdateRaidInstanceProgress($instZoneID, $raidInstID, "phase", 3);
				plugin::AD_UpdateRaidInstanceProgress($instZoneID, $raidInstID, "stage", 0);
				plugin::AD_UpdateRaidInstanceProgress($instZoneID, $raidInstID, "step", 0);
				UnlockPhaseTwoDoors();
				# zone_emoter (223227)
				quest::signalwith(223227,3,1);
				# Spawn phase 3
				ControlPhaseThree(); # Yes, it is correct for this to be control and not spawn
			}
		}
	}
}

sub SpawnPhaseTwo
{
	my $instZoneSN = plugin::ZoneShortName($instZoneID);
		
	if (quest::get_spawn_condition($instZoneSN, $raidInstID, 10) == 0)
	{
		# Spawn condition on for phase 2
		quest::spawn_condition($instZoneSN, $raidInstID, 10, 1);
	}
	else
	{
		# If it's started and this is triggered, flip it off and on to force full repop
		quest::spawn_condition($instZoneSN, $raidInstID, 10, 0);
		quest::clearspawntimers();
		
		quest::spawn_condition($instZoneSN, $raidInstID, 10, 1);
		
		# Spawn named since this is wave 2 of phase 2
		quest::spawn2(223134,0,0,262,1644,493,192.5); # Earthen_Overseer
		quest::spawn2(223118,0,0,262,1354,493,192.5); # Windshapen_Warlord_of_Air
		quest::spawn2(223127,0,0,262,1109,493,192.5); # Ralthos_Enrok
		quest::spawn2(223096,0,0,262,869,493,192.5); # War_Shapen_Emissary
		quest::spawn2(223146,0,0,262,574,493,192.5); # Gutripping_War_Beast
	}
}

sub ControlPhaseThree
{
	# Check which phase, stage, and step
	$phase = plugin::AD_GetRaidInstanceProgress($instZoneID, $raidInstID, "phase");
	$stage = plugin::AD_GetRaidInstanceProgress($instZoneID, $raidInstID, "stage");
	$step = plugin::AD_GetRaidInstanceProgress($instZoneID, $raidInstID, "step");

	if ($phase == 3)
	{
		# Run this only at the start
		if ($stage == 0)
		{
			# Update to stage 1 to avoid running this again
			plugin::AD_UpdateRaidInstanceProgress($instZoneID, $raidInstID, "stage", 1);
			# zone_emoter (223227)
			quest::signalwith(223227,3,1);
			# Trigger first wave spawns
			SpawnPhaseThree(1);
		}
		
		# Run this only on kills and not at start
		if ($stage > 0)
		{
			$step++;
		}
		
		if ($stage < 9)
		{
			# Handle phase 3 stage 1-9
			if ($step < 10)
			{
				plugin::AD_UpdateRaidInstanceProgress($instZoneID, $raidInstID, "step", $step);
			}
			elsif ($step == 10)
			{
				plugin::AD_UpdateRaidInstanceProgress($instZoneID, $raidInstID, "stage", $stage + 1);
				plugin::AD_UpdateRaidInstanceProgress($instZoneID, $raidInstID, "step", 0);
				# Trigger wave spawns
				SpawnPhaseThree($stage + 1);
			}
		}
		elsif ($stage == 9)
		{
			if ($step < 2)
			{
				plugin::AD_UpdateRaidInstanceProgress($instZoneID, $raidInstID, "step", $step);
			}
			elsif ($step == 2)
			{
				# Update to phase 4 stage 0 step 0
				plugin::AD_UpdateRaidInstanceProgress($instZoneID, $raidInstID, "phase", 4);
				plugin::AD_UpdateRaidInstanceProgress($instZoneID, $raidInstID, "stage", 0);
				plugin::AD_UpdateRaidInstanceProgress($instZoneID, $raidInstID, "step", 0);
				UnlockPhaseThreePortal();
				# zone_emoter (223227)
				quest::signalwith(223227,4,1);
				# Spawn phase 4
				SpawnPhaseFour();
			}
		}
	}
}

sub SpawnPhaseThree
{
	my $waveGroup = $_[0];
	my $instZoneSN = plugin::ZoneShortName($instZoneID);
	
	if (not defined $waveGroup)
	{
		$stage = plugin::AD_GetRaidInstanceProgress($instZoneID, $raidInstID, "stage");
		$waveGroup = $stage;
	}
	
	# wavegroup number represents phase 3 wave number
	
	if ($waveGroup == 1)
	{
		# Toggle ON phase 3 wave 1 spawn condition
		quest::spawn_condition($instZoneSN, $raidInstID, 2, 1);

		# Spawn the untargetable version of the phase 3 named
		quest::spawn2(223010,0,0,1280,1010,359.38,195); # A_Needletusk_Warboar
		quest::spawn2(223011,0,0,1280,1030,359.38,195); # Deathbringer_Rianit
		quest::spawn2(223012,0,0,1260,1250,359.38,195); # Sinrunal_Gorgedreal
		quest::spawn2(223013,0,0,1260,1270,359.38,195); # Herlsoakian
		quest::spawn2(223014,0,0,1280,1210,359.38,195); # Xerskel_Gerodnsal
		quest::spawn2(223015,0,0,1280,1190,359.38,195); # Dersool_Fal`Giersnaol
		quest::spawn2(223016,0,0,1260,970,359.38,195);  # Xeroan_Xi`Geruonask
		quest::spawn2(223017,0,0,1260,950,359.38,195);  # Kraksmaal_Fir`Dethsin
		quest::spawn2(223018,0,0,1300,1070,359.38,195); # Dreamwarp
		quest::spawn2(223019,0,0,1300,1090,359.38,195); # Champion_of_Torment
		quest::spawn2(223020,0,0,1300,1130,359.38,195); # Dark_Knight_of_Terris
		quest::spawn2(223021,0,0,1300,1150,359.38,195); # Undead_Squad_Leader
		quest::spawn2(223022,0,0,1230,1330,359.38,175); # A_Deadly_Warboar
		quest::spawn2(223023,0,0,1230,1310,359.38,175); # Deathbringer_Skullsmash
		
		# Spawn targetable for phase 3 wave 1
		quest::spawn2(223008,0,0,1250,1135,359.5,192); # A_Ferocious_Warboar
		quest::spawn2(223009,0,0,1250,1085,359.5,192); # Deathbringer_Blackheart
	}
	elsif ($waveGroup == 2)
	{
		# Toggle OFF phase 3 wave 1 spawn condition and clear spawn timers
		quest::spawn_condition($instZoneSN, $raidInstID, 2, 0);
		quest::clearspawntimers();
		
		# Toggle ON phase 3 wave 2 spawn condition
		quest::spawn_condition($instZoneSN, $raidInstID, 3, 1);
		
		# Depop untargetable and pop targetable versions
		quest::depop(223016); # Xeroan_Xi`Geruonask
		quest::depop(223017); # Kraksmaal_Fir`Dethsin
		quest::spawn2(223025,0,0,1250,1135,359.5,192); # Xeroan_Xi`Geruonask
		quest::spawn2(223024,0,0,1250,1085,359.5,192); # Kraksmaal_Fir`Dethsin
	}
	elsif ($waveGroup == 3)
	{
		# Toggle OFF phase 3 wave 2 spawn condition and clear spawn timers
		quest::spawn_condition($instZoneSN, $raidInstID, 3, 0);
		quest::clearspawntimers();
		
		# Toggle ON phase 3 wave 3 spawn condition
		quest::spawn_condition($instZoneSN, $raidInstID, 4, 1);
		
		# Depop untargetable and pop targetable versions
		quest::depop(223022); # A_Deadly_Warboar
		quest::depop(223023); # Deathbringer_Skullsmash
		quest::spawn2(223032,0,0,1250,1135,359.5,192); # A_Deadly_Warboar
		quest::spawn2(223031,0,0,1250,1085,359.5,192); # Deathbringer_Skullsmash
	}
	elsif ($waveGroup == 4)
	{
		# Toggle OFF phase 3 wave 3 spawn condition and clear spawn timers
		quest::spawn_condition($instZoneSN, $raidInstID, 4, 0);
		quest::clearspawntimers();
		
		# Toggle ON phase 3 wave 4 spawn condition
		quest::spawn_condition($instZoneSN, $raidInstID, 5, 1);
		
		# Depop untargetable and pop targetable versions
		quest::depop(223012); # Sinrunal_Gorgedreal
		quest::depop(223013); # Herlsoakian
		quest::spawn2(223038,0,0,1250,1085,359.5,192); # Sinrunal_Gorgedreal
		quest::spawn2(223037,0,0,1250,1135,359.5,192); # Herlsoakian
	}
	elsif ($waveGroup == 5)
	{
		# Toggle OFF phase 3 wave 4 spawn condition and clear spawn timers
		quest::spawn_condition($instZoneSN, $raidInstID, 5, 0);
		quest::clearspawntimers();
		
		# Toggle ON phase 3 wave 5 spawn condition
		quest::spawn_condition($instZoneSN, $raidInstID, 6, 1);
		
		# Depop untargetable and pop targetable versions
		quest::depop(223010); # A_Needletusk_Warboar
		quest::depop(223011); # Deathbringer_Rianit
		quest::spawn2(223047,0,0,1250,1085,359.5,192); # A_Needletusk_Warboar
		quest::spawn2(223046,0,0,1250,1135,359.5,192); # Deathbringer_Rianit
	}
	elsif ($waveGroup == 6)
	{
		# Toggle OFF phase 3 wave 5 spawn condition and clear spawn timers
		quest::spawn_condition($instZoneSN, $raidInstID, 6, 0);
		quest::clearspawntimers();
		
		# Toggle ON phase 3 wave 6 spawn condition
		quest::spawn_condition($instZoneSN, $raidInstID, 7, 1);
		
		# Depop untargetable and pop targetable versions
		quest::depop(223014); # Xerskel_Gerodnsal
		quest::depop(223015); # Dersool_Fal`Giersnaol
		quest::spawn2(223050,0,0,1250,1085,359.5,192); # Dersool_Fal`Giersnaol
		quest::spawn2(223051,0,0,1250,1135,359.5,192); # Xerskel_Gerodnsal
	}
	elsif ($waveGroup == 7)
	{
		# Toggle OFF phase 3 wave 6 spawn condition and clear spawn timers
		quest::spawn_condition($instZoneSN, $raidInstID, 7, 0);
		quest::clearspawntimers();
		
		# Toggle ON phase 3 wave 7 spawn condition
		quest::spawn_condition($instZoneSN, $raidInstID, 8, 1);
		
		# Depop untargetable and pop targetable versions
		quest::depop(223020); # Dark_Knight_of_Terris
		quest::depop(223021); # Undead_Squad_Leader
		quest::spawn2(223058,0,0,1250,1085,359.5,192); # Dark_Knight_of_Terris
		quest::spawn2(223057,0,0,1250,1135,359.5,192); # Undead_Squad_Leader
	}
	elsif ($waveGroup == 8)
	{
		# Toggle OFF phase 3 wave 7 spawn condition and clear spawn timers
		quest::spawn_condition($instZoneSN, $raidInstID, 8, 0);
		quest::clearspawntimers();
		
		# Toggle ON phase 3 wave 8 spawn condition
		quest::spawn_condition($instZoneSN, $raidInstID, 9, 1);
		
		# Depop untargetable and pop targetable versions
		quest::depop(223018); # Dreamwarp
		quest::depop(223019); # Champion_of_Torment
		quest::spawn2(223066,0,0,1250,1085,359.5,192); # Dreamwarp
		quest::spawn2(223065,0,0,1250,1135,359.5,192); # Champion_of_Torment
	}
	elsif ($waveGroup == 9)
	{
		# Toggle OFF phase 3 wave 8 spawn condition and clear spawn timers
		quest::spawn_condition($instZoneSN, $raidInstID, 9, 0);
		quest::clearspawntimers();
		
		# Spawn golems
		quest::spawn2(223073,0,0,1492,1110,374.1,195.5); # Avatar_of_the_Elements
		quest::spawn2(223074,0,0,1563,1110,374.1,195.5); # Supernatural_Guardian
	}
	
}

sub ControlPhaseFour
{
	# Check which phase and step
	$phase = plugin::AD_GetRaidInstanceProgress($instZoneID, $raidInstID, "phase");
	$step = plugin::AD_GetRaidInstanceProgress($instZoneID, $raidInstID, "step");
	
	if ($phase == 4)
	{
		# We have to do this so people cannot just kill 3 gods then recycle the zone and re-kill them
		
		# If the NPC is NOT up and has NOT yet been logged in the step
		if ((!$entity_list->GetNPCByNPCTypeID(223075)) and (index($step, 1) == -1))
		{
			plugin::AD_UpdateRaidInstanceProgress($instZoneID, $raidInstID, "step", $step . 1);
			UpdateLockouts(72000); # 20 hour lockout for killing at least 1 P4 boss
		}
		elsif ((!$entity_list->GetNPCByNPCTypeID(223076)) and (index($step, 2) == -1))
		{
			plugin::AD_UpdateRaidInstanceProgress($instZoneID, $raidInstID, "step", $step . 2);
			UpdateLockouts(72000); # 20 hour lockout for killing at least 1 P4 boss
		}
		elsif ((!$entity_list->GetNPCByNPCTypeID(223077)) and (index($step, 3) == -1))
		{
			plugin::AD_UpdateRaidInstanceProgress($instZoneID, $raidInstID, "step", $step . 3);
			UpdateLockouts(72000); # 20 hour lockout for killing at least 1 P4 boss
		}
		elsif ((!$entity_list->GetNPCByNPCTypeID(223078)) and (index($step, 4) == -1))
		{
			plugin::AD_UpdateRaidInstanceProgress($instZoneID, $raidInstID, "step", $step . 4);
			UpdateLockouts(72000); # 20 hour lockout for killing at least 1 P4 boss
		}
		
		# Grab step again
		$step = plugin::AD_GetRaidInstanceProgress($instZoneID, $raidInstID, "step");
			
		# 4 gods must die for phase 4 - this means phase 4 is complete
		if ((index($step, 1) != -1) and (index($step, 2) != -1) and (index($step, 3) != -1) and (index($step, 4) != -1))
		{
			# Update to phase 5 step 0
			plugin::AD_UpdateRaidInstanceProgress($instZoneID, $raidInstID, "phase", 5);
			plugin::AD_UpdateRaidInstanceProgress($instZoneID, $raidInstID, "step", 0);
			UnlockPhaseFourStone();
			# zone_emoter (223227)
			quest::signalwith(223227,5,1);
			# Spawn phase 5
			SpawnPhaseFive();
		}
	}
}

sub SpawnPhaseFour
{
	# Check which step
	$step = plugin::AD_GetRaidInstanceProgress($instZoneID, $raidInstID, "step");
	
	# Check for emote
	# Step does not match any, meaning all are up and we should emote
	if (not $step =~ /1|2|3|4/)
	{
		# zone_emoter (223227)
		quest::signalwith(223227,4,1);
	}
	
	# If the number cannot be found (results in -1) then spawn god
	# We have to do this so people cannot just kill 3 gods then recycle the zone and re-kill them
	if (index($step, 1) == -1)
	{
		quest::spawn2(223075,0,0,-310,307,365,95); # Terris Thule
	}
	
	if (index($step, 2) == -1)
	{
		quest::spawn2(223076,0,0,-320,-316,358,32.5); # Saryrn
	}
	
	if (index($step, 3) == -1)
	{
		quest::spawn2(223077,0,0,405,-84,358,192); # Tallon Zek
	}
	
	if (index($step, 4) == -1)
	{
		quest::spawn2(223078,0,0,405,75,358,192); # Vallon Zek
	}
}

sub ControlPhaseFive
{
	# Check which phase, stage, and step
	$phase = plugin::AD_GetRaidInstanceProgress($instZoneID, $raidInstID, "phase");
	$stage = plugin::AD_GetRaidInstanceProgress($instZoneID, $raidInstID, "stage");
	$step = plugin::AD_GetRaidInstanceProgress($instZoneID, $raidInstID, "step");
	
	if ($phase == 5)
	{
		# Fake spawn stage
		if ($stage == 0)
		{
			$step++;
			
			if ($step < 48)
			{
				plugin::AD_UpdateRaidInstanceProgress($instZoneID, $raidInstID, "step", $step);
			}
			elsif ($step == 48)
			{
				quest::depop(223098); # Fake Bertoxxulous
				quest::depop(223165); # Fake Cazic Thule
				quest::depop(223000); # Fake Innoruuk
				quest::depop(223001); # Fake Rallos Zek
				
				plugin::AD_UpdateRaidInstanceProgress($instZoneID, $raidInstID, "stage", 1);
				plugin::AD_UpdateRaidInstanceProgress($instZoneID, $raidInstID, "step", 0);
				SpawnPhaseFive();
			}
		}
		elsif ($stage == 1)
		{
			# We have to do this so people cannot just kill 3 gods then recycle the zone and re-kill them
			
			# If the NPC is NOT up and has NOT yet been logged in the step
			if ((!$entity_list->GetNPCByNPCTypeID(223142)) and (index($step, 1) == -1))
			{
				plugin::AD_UpdateRaidInstanceProgress($instZoneID, $raidInstID, "step", $step . 1);
				UpdateLockouts(158400); # 44 hour lockout for killing at least 1 P5 boss
			}
			elsif ((!$entity_list->GetNPCByNPCTypeID(223166)) and (index($step, 2) == -1))
			{
				plugin::AD_UpdateRaidInstanceProgress($instZoneID, $raidInstID, "step", $step . 2);
				UpdateLockouts(158400); # 44 hour lockout for killing at least 1 P5 boss
			}
			elsif ((!$entity_list->GetNPCByNPCTypeID(223167)) and (index($step, 3) == -1))
			{
				plugin::AD_UpdateRaidInstanceProgress($instZoneID, $raidInstID, "step", $step . 3);
				UpdateLockouts(158400); # 44 hour lockout for killing at least 1 P5 boss
			}
			elsif ((!$entity_list->GetNPCByNPCTypeID(223168)) and (index($step, 4) == -1))
			{
				plugin::AD_UpdateRaidInstanceProgress($instZoneID, $raidInstID, "step", $step . 4);
				UpdateLockouts(158400); # 44 hour lockout for killing at least 1 P5 boss
			}
			
			# Grab step again
			$step = plugin::AD_GetRaidInstanceProgress($instZoneID, $raidInstID, "step");
				
			# 4 gods must die for phase 5 - this means phase 5 is complete
			if ((index($step, 1) != -1) and (index($step, 2) != -1) and (index($step, 3) != -1) and (index($step, 4) != -1))
			{
				# Update to phase 6 stage 0 step 0
				plugin::AD_UpdateRaidInstanceProgress($instZoneID, $raidInstID, "phase", 6);
				plugin::AD_UpdateRaidInstanceProgress($instZoneID, $raidInstID, "stage", 0);
				plugin::AD_UpdateRaidInstanceProgress($instZoneID, $raidInstID, "step", 0);
				UnlockPhaseFiveStone();
				# zone_emoter (223227)
				quest::signalwith(223227,6,1);
				# Spawn phase 6
				SpawnPhaseSix();
			}
		}
	}
}

sub SpawnPhaseFive
{
	my $instZoneSN = plugin::ZoneShortName($instZoneID);
	
	$stage = plugin::AD_GetRaidInstanceProgress($instZoneID, $raidInstID, "stage");
	$step = plugin::AD_GetRaidInstanceProgress($instZoneID, $raidInstID, "step");
	
	# Always emote if this code runs and is stage 0
	if ($stage == 0)
	{
		quest::spawn2(223098,0,0,-299,-297,23.3,31); # Fake Bertoxxulous
		quest::spawn2(223165,0,0,-257,255,6,101.5); # Fake Cazic
		quest::spawn2(223000,0,0,303.3,306,13.3,161.5); # Fake Innoruuk
		quest::spawn2(223001,0,0,264,-279,18.75,217.5); # Fake Rallos

		# Reset step to 0 in case zone was reloaded halfway through stage 0
		plugin::AD_UpdateRaidInstanceProgress($instZoneID, $raidInstID, "step", 0);
		
		# Toggle ON phase 5 stage 0 spawn condition
		quest::spawn_condition($instZoneSN, $raidInstID, 1, 1);
		
		# zone_emoter (223227)
		quest::signalwith(223227,5,1);
	}
	elsif ($stage == 1)
	{
		# Toggle OFF phase 5 stage 0 spawn condition and clear spawn timers
		quest::spawn_condition($instZoneSN, $raidInstID, 1, 0);
		quest::clearspawntimers();
		
		# If the number cannot be found (results in -1) then spawn god
		# We have to do this so people cannot just kill 3 gods then recycle the zone and re-kill them
		if (index($step, 1) == -1)
		{
			quest::spawn2(223142,0,0,-299,-297,23.3,31); # Bertoxxulous
		}
		
		if (index($step, 2) == -1)
		{
			quest::spawn2(223166,0,0,-257,255,6,101.5); # Cazic Thule
		}
		
		if (index($step, 3) == -1)
		{
			quest::spawn2(223167,0,0,303.3,306,13.3,161.5); # Innoruuk
		}
		
		if (index($step, 4) == -1)
		{
			quest::spawn2(223168,0,0,264,-279,18.75,217.5); # Rallos Zek
		}
	}
}

sub SpawnPhaseSix
{
	# Check which phase
	$phase = plugin::AD_GetRaidInstanceProgress($instZoneID, $raidInstID, "phase");
	
	if ($phase == 6)
	{
		quest::spawn2(223201,0,0,-401,-1106,32.5,92.8125); # Quarm
		quest::spawn2(223101,0,0,244,-1106,-1.125,97.03125); # #A_Servitor_of_Peace
		quest::spawn2(223228,0,0,-579,-1119,60.625,0); # Zebuxoruk's Cage
	}
}

sub ResetAllSpawnConditions
{
	my $instZoneSN = plugin::ZoneShortName($instZoneID);
	
	# Reset all spawn conditions to 0 we want nothing up at zone boot or repop
	for (my $i = 1; $i <= 10; $i++)
	{
		quest::spawn_condition($instZoneSN, $raidInstID, $i, 0);
	}
}

sub UpdateLockouts
{
	my $lockoutTime = $_[0]; # in seconds
	my @charIdArr = plugin::AD_GetCharIDsInInstance($raidInstID);
		
	foreach my $charId (@charIdArr)
	{
		# Update lockout whether char is online or offline
		my $lockoutTimeRemaining = plugin::AD_GetInstanceLockoutTimeRemaining($charId, $instZoneID);
		
		# If char is online
		if ($entity_list->GetClientByCharID($charId))
		{
			plugin::AD_AddInstanceLockout($charId, $instZoneID, $entity_list->GetClientByCharID($charId)->GetCleanName(), $lockoutTime);
			$entity_list->GetClientByCharID($charId)->Message(15, "Your lockout time now has ".$lockoutTimeRemaining." remaining.");
		}
		# If char is offline
		else
		{
			plugin::AD_AddInstanceLockout($charId, $instZoneID, "Offline", $lockoutTime);
		}
	}
}

sub UnlockPhaseOneDoors
{
	for ($i=1; $i<=20; $i=$i+4)
	{
		$entity_list->FindDoor($i+0)->SetOpenType(78); # top left
		$entity_list->FindDoor($i+1)->SetOpenType(79); # top right
		$entity_list->FindDoor($i+2)->SetOpenType(80); # bottom right
		$entity_list->FindDoor($i+3)->SetOpenType(81); # bottom left
	}
}

sub UnlockPhaseTwoDoors
{
	for ($i=21; $i<=32; $i=$i+4)
	{
		$entity_list->FindDoor($i+0)->SetOpenType(78); # top left
		$entity_list->FindDoor($i+1)->SetOpenType(79); # top right
		$entity_list->FindDoor($i+2)->SetOpenType(80); # bottom right
		$entity_list->FindDoor($i+3)->SetOpenType(81); # bottom left
	}
}

sub UnlockPhaseThreePortal
{
	$entity_list->FindDoor(62)->SetLockPick(0);
}

sub UnlockPhaseFourStone
{
	$entity_list->FindDoor(83)->SetLockPick(0);
}

sub UnlockPhaseFiveStone
{
	$entity_list->FindDoor(51)->SetLockPick(0);
}
