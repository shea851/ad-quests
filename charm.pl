# Author: Corporate
# Date: 20161108
# Purpose: Buff charm pets and debuff them on charm break

my @classicZones	= ( "arena","qeynos","qeynos2","qrg","qeytoqrg","highpasshold","highkeep","freportn","freporte","freportw","runnyeye","qey2hh1","northkarana","southkarana","eastkarana","beholder","blackburrow",
						"paw","rivervale","kithicor","commons","ecommons","erudsxing","erudnext","nektulos","lavastorm","halas","everfrost","soldunga","soldungb","misty","nro","sro","befallen","oasis","tox","hole",
						"neriaka","neriakb","neriakc","neriakd","najena","qcat","innothule","feerrott","cazicthule","oggok","rathemtn","lakerathe","grobb","gfaydark","akanon","steamfont","lfaydark","crushbone",
						"mistmoore","kaladima","felwithea","felwitheb","felwithb","unrest","kedge","guktop","gukbottom","kaladimb","butcher","oot","cauldron","permafrost","paineel","soltemple","warrens","erudnint",
						"stonebrunt","jaggedpine","kerraridge","hateplane","fearplane","airplane" );

my @kunarkZones		= ( "veeshan","charasis","sebilis","chardok","nurga","veksar","karnor","fieldofbone","warslikswood","cabwest","cabeast","swampofnohope","firiona","dreadlands","burningwood","kaesora","skyfire",
						"frontiermtns","overthere","emeraldjungle","trakanon","timorous","droga","citymist","kurn","lakeofillomen","dalnir" );

my @veliousZones	= (	"sleeper","mischiefplane","templeveeshan","kael","skyshrine","growthplane","thurgadinb","iceclad","velketor","thurgadina","eastwastes","cobaltscar","greatdivide","wakening","westwastes",
						"necropolis","sirens","crystal","frozenshadow" );

my @luclinZones		= ( "acrylia","ssratemple","vexthal","sseru","thedeep","akheva","shadowhaven","tenebrous","grimling","hollowshade","nexus","netherbian","paludal","dawnshroud","griegsend","scarlet","thegrey",
						"mseru","umbral","twilight","letalis","fungusgrove","echo","sharvahl","katta","shadeweaver","maiden","bazaar" );

my @popZones		= ( "poknowledge","potranquility","codecay","pojustice","ponightmare","podisease","poinnovation","povalor","bothunder","postorms","hohonora","solrotower","powar","potactics","poair","powater",
						"pofire","poeartha","potimea","hohonorb","nightmareb","poearthb","potimeb","potorment" );

sub EVENT_SPELL_EFFECT_NPC
{
	#quest::debug("EVENT_SPELL_EFFECT_NPC");
	
	my $mod = GetModifier();
	
	# Get amount HP will increase
	my $hpDiff = ($npc->GetMaxHP() * 1.40) - $npc->GetMaxHP();
	
	# Increase HP / other stats
	quest::modifynpcstat('max_hp', ($npc->GetMaxHP() * $mod));
	quest::modifynpcstat('ac', ($npc->GetAC() * ($mod + 0.10)));
	quest::modifynpcstat('min_hit', ($npc->GetMinDMG() * $mod));
	quest::modifynpcstat('max_hit', ($npc->GetMaxDMG() * $mod));
	quest::modifynpcstat('str', ($npc->GetSTR() * $mod));
	quest::modifynpcstat('accuracy', ($npc->GetAccuracyRating() + 250));
	
	# Heal only HP amount increased
	$npc->SetHP($npc->GetHP() + $hpDiff);	
}

sub EVENT_SPELL_FADE
{
	#quest::debug("EVENT_SPELL_FADE");

	# Plugin [../server/plugins/corporates_tools.pl]
	my @npcBaseStats = plugin::NPCStatsDBLookupByID($npc->GetNPCTypeID());
	my $npcBaseHP = $npcBaseStats[0];
	my $npcBaseAC = $npcBaseStats[1];
	my $npcBaseMIN = $npcBaseStats[2];
	my $npcBaseMAX = $npcBaseStats[3];
	my $npcBaseSTR = $npcBaseStats[4];
	my $npcBaseAccuracy = $npcBaseStats[5];
	
	# Get HP ratio before HP max decrease (and round it up)
	my $hpRatio = int($npc->GetHPRatio + 0.5) / 100;
	
	# Decrease HP / other stats
	quest::modifynpcstat('max_hp', $npcBaseHP);
	quest::modifynpcstat('ac', $npcBaseAC);
	quest::modifynpcstat('min_hit', $npcBaseMIN);
	quest::modifynpcstat('max_hit', $npcBaseMAX);
	quest::modifynpcstat('str', $npcBaseSTR);
	quest::modifynpcstat('accuracy', $npcBaseAccuracy);
	
	# Set mob HP back to correct percent after HP max decrease
	$npc->SetHP(($npc->GetMaxHP() * $hpRatio));	
}

sub GetModifier
{
	my $modifier = 1.00;
	
	if ($zonesn ~~ @classicPlanes)
	{
		$modifier = 1.40;
	}
	elsif ($zonesn ~~ @kunarkZones)
	{
		$modifier = 1.35;
	}
	elsif ($zonesn ~~ @veliousZones)
	{
		$modifier = 1.35;
	}
	elsif ($zonesn ~~ @luclinZones)
	{
		$modifier = 1.30;
	}
	elsif ($zonesn ~~ @popZones)
	{
		$modifier = 1.30;
	}
	
	return $modifier;
}