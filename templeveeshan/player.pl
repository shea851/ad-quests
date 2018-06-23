sub EVENT_ENTERZONE {
	if (defined $qglobals{"vulakcooldown"}) {
		$client->Message (15, "Vulak`Aerr has ".plugin::TimeToQglobalExpiration("vulakcooldown")." remaining on cool-down!");
	}
	else {
		$client->Message (15, "You sense great evil lurking in the shadows...");
	}
}