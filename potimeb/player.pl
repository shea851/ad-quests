# Author: Corporate
# Date: 20180210

sub EVENT_ENTERZONE
{
	# For consistency set these
	my $instZoneID = $zoneid;
	my $raidInstID = $instanceid;
	# Get client lockout status
	my $lockedOut = plugin::AD_CheckInstanceLockout($charid, $instZoneID);
	
	# If you are not locked and if you are in an instance
	#$client->Message(15, "[DEBUG] Lockout status: ".$lockedOut);
	#$client->Message(15, "[DEBUG] Instance ID: ".$raidInstID);
	if (($lockedOut == 0) and ($raidInstID > 0))
	{
		plugin::AD_AddInstanceLockout($charid, $instZoneID, $client->GetCleanName(), 43200); # Add 12 hour default lockout for zoning in
		my $lockoutTimeRemaining = plugin::AD_GetInstanceLockoutTimeRemaining($charid, $instZoneID);
		$client->Message(15, "Your lockout time now has ".$lockoutTimeRemaining." remaining.");
	}
}



# Get expiration time of instance
#my $timeRemaining = plugin::AD_GetRaidInstanceTimeRemaining($client->GetRaid()->GetID(), $instZoneID);
# Friendly message for client
#my $instMsg = plugin::Zone($instZoneID)." (".$raidInstID.") will expire in ".$timeRemaining.".";
#$client->Message(15, $instMsg);