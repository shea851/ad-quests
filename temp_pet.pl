# Author: Corporate
# Date: 20171121
# Purpose: Kill temp pets to work around code issue

sub EVENT_TARGET_CHANGE
{
	if (!$npc->GetTarget() && ($npc->GetPetType() == 5))
	{
		$npc->Kill();
	}
}