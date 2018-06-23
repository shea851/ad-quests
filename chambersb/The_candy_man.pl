# Author:  Corporate
# Date:    20160922
# Purpose: Basic buff bot

no warnings;

sub EVENT_SAY {

	# Free buffs -  Spirit of Wolf, Ultravision, Chloroplast, Resist Magic, Shield of Fire, Clarity, Valor, Raging Strength, Augmentation
	@freeBuffs=(278,46,145,64,332,174,312,151,10);

	# Advanced buffs - Spirit of Eagle, Regrowth, Circle of Seasons, Talisman of Epuration, Group Resist Magic, Clarity II, Aegolism, Aanya's Quickening, Maniacle Strength
	@advBuffs=(2517,1568,2519,2529,72,1693,1447,1708,1593);
	
	# Cure - GM Cleansing
	my $cure=6594;

	# Set pp cost of advanced buffs
	my $advCost=250;

	if ($text=~/Hail/i) {
		plugin::Whisper("I got the good stuff, $name. I got you this time but I don't work for free. Remember that.");
		plugin::Whisper("[".quest::saylink("Free self buffs",1)."]");
		plugin::Whisper("[".quest::saylink("Advanced group buffs",1)."] - ".$advCost."pp");
		plugin::Whisper("[".quest::saylink("Cure",1)."]");
	}
	elsif ($text=~/Free/i) {
		foreach my $buff (@freeBuffs) {
			quest::selfcast($buff);
			castPet($client, $buff);
		}
		plugin::Whisper("Good luck, friend!");
	}
	elsif ($text=~/Advanced/i) {
		plugin::Whisper("Advanced group buffs - Are you sure? [".quest::saylink("advbuffsconfirmed", 1, "Yes")."]");
	}
	elsif ($text=~/advbuffsconfirmed/i) {
		if ($client->TakeMoneyFromPP(($advCost * 1000), 1)) {
			foreach my $buff (@advBuffs) {
				if ($client->IsGrouped())
				{
					castGroup($client, $buff);
				}
				else
				{
					quest::selfcast($buff);
					castPet($client, $buff);
				}	
			}
			plugin::Whisper("Good luck, friend!");
		}
		else
		{
			plugin::Whisper("You are broke, get a job. I charge ".$advCost."pp for Advanced buffs.");
		}
	}
	elsif ($text=~/Cure/i) { 
		$client->SpellFinished($cure); 
		castPet($client, $cure);
	}
}

sub castPet {
	my $id = $_[0];
	my $spell = $_[1];
	if ($id->GetPetID()) {
		my $pcpet = $entity_list->GetMobByID($id->GetPetID());
		$id->SpellFinished ($spell, $pcpet);
	}
}

sub castGroup {
	my $id = $_[0];
	my $buff = $_[1];
	my $idGroup = $id->GetGroup();
	for ($count = 0; $count < $idGroup->GroupCount(); $count++) {
		my $gMember = $idGroup->GetMember($count);
		if (defined $gMember && $gMember->GetZoneID() == $zoneid) {
			$gMember->SpellFinished ($buff, $gMember);
			castPet($gMember, $buff);
		}
	}
}
