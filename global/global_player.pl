# Author: Corporate
# Date: 20160925
no warnings;

sub EVENT_SIGNAL {
	if ($signal == 8675309)
	{
		quest::movepc(305, 1, 1, 1);
	}
}

sub skillUp {
	foreach my $skill (0..42,48..54,62,66,67,70..74,76,77) {
		next unless $client->CanHaveSkill($skill);
		my $maxSkill = $client->MaxSkill($skill, $client->GetClass(), $ulevel );
		next unless $maxSkill > $client->GetRawSkill($skill);
		$client->SetSkill($skill, $maxSkill );
	}

	quest::traindiscs ($client->GetLevel(), $client->GetLevel());
	quest::scribespells ($ulevel, 1);

	if	(($ulevel == 20 && $class ~~ ["Necromancer","Enchanter","Magician","Wizard"]) || ($ulevel == 30 && $class ~~ ["Druid","Shaman","Cleric"])) {
			$client->Message(5,	"You may only have 1 specialization over the skill 50, the first to exceed skill 50 becomes your specialization!");
	}
}

sub EVENT_LEVEL_UP {
	skillUp();
	$client->Message(15, "Your experiences across the realm have infused you with increased power and knowledge..." );
}

###############################

# Check each tier against "flagaccess" qglobal

sub EVENT_ENTERZONE {

	my @suspendList = plugin::ReadVariable('suspension_%');
	foreach my $val (@suspendList) #val will equal char name, which is always unique
	{
		if ($val eq $client->GetName())
		{
			plugin::DeleteVariable($val);
			$client->Message(15,"MQ WARP IS NOT ALLOWED.");
		}
	}

	my $varFlag = "flagaccess";

	my $hub	= 305; # chambersb
	
	my @hub				= ( "chambersb" );
	
	my @classicZones	= ( "arena","qeynos","qeynos2","qrg","qeytoqrg","highpasshold","highkeep","freportn","freporte","freportw","runnyeye","qey2hh1","northkarana","southkarana","eastkarana","beholder","blackburrow","paw","rivervale",
							"kithicor","commons","ecommons","erudsxing","erudnext","nektulos","lavastorm","halas","everfrost","soldunga","soldungb","misty","nro","sro","befallen","oasis","tox","hole","neriaka","neriakb","neriakc",
							"neriakd","najena","qcat","innothule","feerrott","cazicthule","oggok","rathemtn","lakerathe","grobb","gfaydark","akanon","steamfont","lfaydark","crushbone","mistmoore","kaladima","felwithea","felwitheb",
							"felwithb","unrest","kedge","guktop","gukbottom","kaladimb","butcher","oot","cauldron","permafrost","paineel","soltemple","warrens","erudnint","stonebrunt","jaggedpine","kerraridge" );
	
	my @classicPlanes	= ( "hateplane","fearplane","airplane" );
	
	my @kunarkOpenZones = ( "citymist","kurn","lakeofillomen","dalnir" );
	
	my @kunarkZones		= ( "veeshan","charasis","sebilis","chardok","nurga","veksar","karnor","fieldofbone","warslikswood","cabwest","cabeast","swampofnohope","firiona","dreadlands","burningwood","kaesora","skyfire",
							"frontiermtns","overthere","emeraldjungle","trakanon","timorous","droga" );
	
	my @veliousOpenZones= ( "crystal","frozenshadow" );
	
	my @veliousZones	= (	"sleeper","mischiefplane","templeveeshan","kael","skyshrine","growthplane","thurgadinb","iceclad","velketor","thurgadina","eastwastes","cobaltscar","greatdivide","wakening","westwastes",
							"necropolis","sirens" );
	
	my @luclinZones		= ( "acrylia","ssratemple","vexthal","sseru","thedeep","akheva","shadowhaven","tenebrous","grimling","hollowshade","nexus","netherbian","paludal","dawnshroud","griegsend","scarlet","thegrey","mseru","umbral",
							"twilight","letalis","fungusgrove","echo","sharvahl","katta","shadeweaver","maiden","bazaar" );
	
	my @popZones		= ( "poknowledge","potranquility","codecay","pojustice","ponightmare","podisease","poinnovation","povalor","bothunder","postorms","hohonora","solrotower","powar","potactics","poair","powater","pofire","poeartha",
							"potimea","hohonorb","nightmareb","poearthb","potimeb","potorment" );
	
	my @restrictedZones	= ( "arcstone","bloodfields","buriedsea","direwind","eastkorlach","icefall","kattacastrum","moors","nedaria","steppes","sunderock","wallsofslaughter","delvea","broodlands","guildlobby","gunthak","barindu","natimbi",
							"chardokb","abysmal" );
	
	my @tieredZones 	= ( @hub, @classicZones, @classicPlanes, @kunarkOpenZones, @kunarkZones, @veliousOpenZones, @veliousZones, @luclinZones, @popZones, @restrictedZones );
	
	if ($status < 101) {
		if ($zonesn ~~ @tieredZones) {
			if (($zonesn ~~ @classicPlanes) && ($qglobals{"flagaccess"} < 1)) {
					$client->Message(15,"Speak to the Classic Guardian to gain access to this zone.");
					quest::movepc($hub, 1, 1, 1);
			}
			elsif (($zonesn ~~ @kunarkZones) && ($qglobals{"flagaccess"} < 2)) {
				$client->Message(15,"Speak to the Kunark Guardian to gain access to this zone.");
				quest::movepc($hub, 1, 1, 1);
			}
			elsif (($zonesn ~~ @veliousZones) && ($qglobals{"flagaccess"} < 3)) {
				$client->Message(15,"Speak to the Velious Guardian to gain access to this zone.");
				quest::movepc($hub, 1, 1, 1);
			}
			elsif (($zonesn ~~ @luclinZones) && ($qglobals{"flagaccess"} < 4)) {
				$client->Message(15,"Speak to the Luclin Guardian to gain access to this zone.");
				quest::movepc($hub, 1, 1, 1);
			}
			elsif (($zonesn ~~ @popZones) && ($qglobals{"flagaccess"} < 5)) {
				$client->Message(15,"Speak to the Planes of Power Guardian to gain access to this zone.");
				quest::movepc($hub, 1, 1, 1);
			}
			elsif ($zonesn ~~ @restrictedZones) {
				$client->Message(15,"You may not ever enter these zones.");
				quest::movepc($hub, 1, 1, 1);
			}
		}
		else {
			$client->Message(15,"Issue with zone permissions. Contact a GM.");
			quest::movepc($hub, 1, 1, 1);
		}

		# Stop exploiters with MQ zone bypassing PoP flag system
		if ($zonesn ~~ @popZones) {
			if (quest::has_zone_flag($zoneid) ne plugin::CheckIfZoneHasFlag($zoneid)) {
				$client->Message(15,"You are not flagged for this zone.");
				quest::movepc($hub, 1, 1, 1);
			}
		}

	}
	else {
		$client->Message(15,"[GM] Admin detected, no zone check!");
	}

}

sub EVENT_CONNECT {

	if (!defined $qglobals{"firstwelcome"}) {
		quest::setglobal("firstwelcome",1,5,"F");
		
		$client->Message(15, "Welcome to Addicted Dads. Please visit our forums for custom spell file - addicteddads.proboards.com");
		$client->Message(15, "The recommended client is RoF2 which can also be retrieved from our forums. Titanium likely will not work properly and we will not support it.");
		
		# Add level 1 spells/skills
		if ($ulevel == 1) {
			skillUp();
		}
		
		# Fix common tongue
		if ($client->GetLanguageSkill(0) != 100) {
			$client->SetLanguageSkill(0, 100);
		}
		
		# Max sense heading
		if ($client->GetSkill(40) != 400) {
			$client->SetSkill(40, 400);
		}
	}

	# No flag = classic access
	# Flag level 1 = planes access
	# Flag level 2 = kunark access lvl limit 60
	# Flag level 3+ = lvl limit 65
	# This sets the initial CharMaxLevel qglobal for players that do not have one.
	# The extra logic inside is because this was implemented after people already leveled up.
	if (!defined $qglobals{"CharMaxLevel"})
	{
		# Default max level that will apply to all new players
		my $enforcedMaxLevel = 55;
		
		# Players that already have Kunark access
		if ((defined $qglobals{"flagaccess"}) && ($qglobals{"flagaccess"} == 2))
		{
			$enforcedMaxLevel = 60;
		}
		
		# Players that already have Velious+ access
		if ((defined $qglobals{"flagaccess"}) && ($qglobals{"flagaccess"} >= 3))
		{
			$enforcedMaxLevel = 65;
		}
		
		# Fix for someone who already leveled past their limit
		# The +1 is so they don't lose already gained xp on that level
		if (($client->GetLevel() < 65) && ($enforcedMaxLevel <= $client->GetLevel()))
		{
			$enforcedMaxLevel = $client->GetLevel() + 1;
		}
		
		# And simply if you are 65, then your max level is 65.
		if ($client->GetLevel() == 65)
		{
			$enforcedMaxLevel = 65;
		}
		
		# This is just "protection" against this somehow getting above 65. This should never actually be needed.
		if ($enforcedMaxLevel > 65)
		{
			$enforcedMaxLevel = 65;
		}
		
		$client->Message (15, "Your level cap has been set to ".$enforcedMaxLevel.".");
		quest::setglobal("CharMaxLevel",$enforcedMaxLevel,5,"F");
	}
}
